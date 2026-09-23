<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import type { Map as MapLibreMap, Marker } from 'maplibre-gl'

const props = withDefaults(defineProps<{
  latitude: number
  longitude: number
  label?: string
  zoom?: number
}>(), {
  label: 'Place location',
  zoom: 15,
})

const mapElement = ref<HTMLElement | null>(null)
let map: MapLibreMap | undefined
let marker: Marker | undefined

const coordinates = () => [props.longitude, props.latitude] as [number, number]

onMounted(async () => {
  if (!mapElement.value) return

  const maplibregl = await import('maplibre-gl')
  map = new maplibregl.Map({
    container: mapElement.value,
    style: {
      version: 8,
      sources: {
        osm: {
          type: 'raster',
          tiles: ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
          tileSize: 256,
          attribution: '© OpenStreetMap contributors',
        },
      },
      layers: [{ id: 'osm', type: 'raster', source: 'osm' }],
    },
    center: coordinates(),
    zoom: props.zoom,
  })

  marker = new maplibregl.Marker({ color: '#e85a45' })
    .setLngLat(coordinates())
    .setPopup(new maplibregl.Popup({ offset: 24 }).setText(props.label))
    .addTo(map)
})

watch(() => [props.longitude, props.latitude, props.zoom] as const, () => {
  if (!map || !marker) return
  marker.setLngLat(coordinates())
  map.flyTo({ center: coordinates(), zoom: props.zoom })
})

onBeforeUnmount(() => map?.remove())
</script>

<template>
  <div ref="mapElement" class="aspect-square overflow-hidden rounded-2xl" :aria-label="`${label} map`" />
</template>
