<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import type { Map as MapLibreMap, Marker } from 'maplibre-gl'

type RouteStop = {
  latitude: number | null
  longitude: number | null
  place_name: string
  stop_order: number
}

const props = defineProps<{ stops: RouteStop[] }>()

const mapElement = ref<HTMLElement | null>(null)
const validStops = computed(() => props.stops
  .filter((stop) => stop.latitude !== null && stop.longitude !== null)
  .sort((a, b) => a.stop_order - b.stop_order))

let map: MapLibreMap | undefined
let markers: Marker[] = []
let maplibregl: typeof import('maplibre-gl') | undefined
let isMapLoaded = false
const routeSourceId = 'route'
const routeLayerId = 'route-line'

const coordinatesFor = (stop: RouteStop) => [stop.longitude!, stop.latitude!] as [number, number]

const markerElement = (stop: RouteStop) => {
  const element = document.createElement('div')
  element.className = 'flex h-7 w-7 items-center justify-center rounded-full border-2 border-white bg-[var(--brand-accent)] text-xs font-semibold text-white shadow-md'
  element.textContent = String(stop.stop_order)
  element.setAttribute('aria-label', `Stop ${stop.stop_order}: ${stop.place_name}`)
  return element
}

const renderRoute = () => {
  if (!map || !maplibregl || !isMapLoaded) return

  markers.forEach((marker) => marker.remove())
  markers = validStops.value.map((stop) => new maplibregl!.Marker({ element: markerElement(stop) })
    .setLngLat(coordinatesFor(stop))
    .setPopup(new maplibregl!.Popup({ offset: 18 }).setText(`${stop.stop_order}. ${stop.place_name}`))
    .addTo(map!))

  const coordinates = validStops.value.map(coordinatesFor)
  if (!coordinates.length) {
    if (map.getLayer(routeLayerId)) map.removeLayer(routeLayerId)
    if (map.getSource(routeSourceId)) map.removeSource(routeSourceId)
    return
  }

  const routeData = {
    type: 'Feature' as const,
    properties: {},
    geometry: { type: 'LineString' as const, coordinates },
  }
  const source = map.getSource(routeSourceId)

  if (source) {
    ;(source as import('maplibre-gl').GeoJSONSource).setData(routeData)
  } else {
    map.addSource(routeSourceId, { type: 'geojson', data: routeData })
    map.addLayer({
      id: routeLayerId,
      type: 'line',
      source: routeSourceId,
      paint: { 'line-color': '#e85a45', 'line-width': 4, 'line-opacity': 0.85 },
    })
  }

  if (coordinates.length === 1) {
    map.flyTo({ center: coordinates[0], zoom: 15 })
  } else if (coordinates.length > 1) {
    const bounds = coordinates.reduce(
      (result, coordinate) => result.extend(coordinate),
      new maplibregl.LngLatBounds(coordinates[0], coordinates[0]),
    )
    map.fitBounds(bounds, { padding: 48, maxZoom: 15, duration: 0 })
  }
}

onMounted(async () => {
  if (!mapElement.value) return

  maplibregl = await import('maplibre-gl')
  map = new maplibregl.Map({
    container: mapElement.value,
    style: 'https://tiles.openfreemap.org/styles/liberty',
    center: [126.978, 37.5665],
    zoom: 12,
  })
  map.on('load', () => {
    isMapLoaded = true
    renderRoute()
  })
})

watch(validStops, renderRoute, { deep: true })

onBeforeUnmount(() => map?.remove())
</script>

<template>
  <div ref="mapElement" lang="en" class="aspect-square overflow-hidden rounded-2xl" aria-label="Route map" />
</template>
