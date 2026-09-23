<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { Map, MapPin, Utensils, Music, ShoppingBag, Mountain } from 'lucide-vue-next'
useSeoMeta({ title:'Travel Korea Like You Actually Live Here', description:'Local routes, practical tips and authentic places for your trip to Korea.' })
const { $supabase } = useNuxtApp()
const { data: places } = await useAsyncData('home-places', async()=>{ const {data,error} = await $supabase.from('place_cards').select('*').limit(4); if(error) throw error; return data })
const categories=[{label:'Itinerary',icon:Map},{label:'Destinations',icon:MapPin},{label:'Food',icon:Utensils},{label:'K-Culture',icon:Music},{label:'Shopping',icon:ShoppingBag},{label:'Nature',icon:Mountain}]
const { getPublicUrl } = useStoragePublicUrl()
const heroSlides = [
  { label: 'Seoul Spring', path: 'hero/seoul.webp', desktopPosition: 'center center', mobilePosition: '72% center' },
  { label: 'Busan Summer', path: 'hero/busan.webp', desktopPosition: 'center center', mobilePosition: '65% center' },
  { label: 'Jeju Autumn', path: 'hero/jeju.webp', desktopPosition: 'center center', mobilePosition: '70% center' },
  { label: 'Gyeongju Winter', path: 'hero/gyeongju.webp', desktopPosition: 'center center', mobilePosition: '75% center' },
].map((slide) => ({ ...slide, url: getPublicUrl('site-images', slide.path) }))
const activeSlide = useState('hero-active-slide', () => Math.floor(Math.random() * heroSlides.length))
const isHovered = ref(false)
const hasManualSelection = ref(false)
const isMobile = ref(false)
const prefersReducedMotion = ref(false)
let rotationTimer: ReturnType<typeof setInterval> | undefined
let mobileQuery: MediaQueryList | undefined
let motionQuery: MediaQueryList | undefined

useHead({ link: [{ rel: 'preload', as: 'image', href: heroSlides[activeSlide.value].url }] })

const selectSlide = (index: number) => {
  activeSlide.value = index
  hasManualSelection.value = true
}
const rotateSlide = () => { activeSlide.value = (activeSlide.value + 1) % heroSlides.length }
const stopRotation = () => { if (rotationTimer) window.clearInterval(rotationTimer) }
const syncRotation = () => {
  stopRotation()
  if (!isMobile.value && !prefersReducedMotion.value && !isHovered.value && !hasManualSelection.value) rotationTimer = window.setInterval(rotateSlide, 7000)
}
const updatePreferences = () => {
  isMobile.value = mobileQuery?.matches || false
  prefersReducedMotion.value = motionQuery?.matches || false
}

onMounted(() => {
  mobileQuery = window.matchMedia('(max-width: 767px)')
  motionQuery = window.matchMedia('(prefers-reduced-motion: reduce)')
  updatePreferences()
  mobileQuery.addEventListener('change', updatePreferences)
  motionQuery.addEventListener('change', updatePreferences)
  syncRotation()
})
watch([isHovered, hasManualSelection, isMobile, prefersReducedMotion], () => { if (import.meta.client) syncRotation() })
onBeforeUnmount(() => {
  stopRotation()
  mobileQuery?.removeEventListener('change', updatePreferences)
  motionQuery?.removeEventListener('change', updatePreferences)
})
</script>
<template><main>
<section class="relative isolate h-[72svh] min-h-[620px] overflow-hidden bg-[var(--brand-ink)] text-white md:h-auto md:min-h-0" @mouseenter="isHovered=true" @mouseleave="isHovered=false"><div class="absolute inset-0" aria-hidden="true"><img v-for="(slide,index) in heroSlides" :key="slide.path" :src="slide.url" :alt="slide.label" :loading="index===0?'eager':'lazy'" :fetchpriority="index===0?'high':'low'" class="hero-image absolute inset-0 h-full w-full object-cover transition-opacity ease-in-out" :class="[index===activeSlide?'opacity-100':'opacity-0',prefersReducedMotion?'duration-0':'duration-1000']" :style="{'--hero-desktop-position':slide.desktopPosition,'--hero-mobile-position':slide.mobilePosition}"/></div><div class="absolute inset-0 bg-gradient-to-r from-black/80 via-black/50 to-black/15" aria-hidden="true"/><div class="relative mx-auto max-w-7xl px-5 py-20 md:py-28"><p class="mb-3 text-sm font-medium uppercase tracking-[0.18em]">Korea, in real life</p><h1 class="max-w-2xl text-4xl font-semibold leading-tight md:text-6xl">Travel Korea<br>Like You Actually<br>Live Here.</h1><p class="mt-5 max-w-xl text-white/80">Real tips. Local spots. Routes that make sense.</p><div class="mt-8 flex max-w-xl rounded-xl bg-white p-2 text-[var(--brand-ink)] shadow-xl"><input class="min-w-0 flex-1 bg-transparent px-3 outline-none" placeholder="Where do you want to go?"/><button class="rounded-lg bg-[var(--brand-ink)] px-5 py-3 text-sm text-white">Search</button></div></div><div class="absolute bottom-5 right-5 z-10 flex gap-2 md:bottom-7 md:right-7"><button v-for="(slide,index) in heroSlides" :key="slide.path" type="button" class="h-2 rounded-full bg-white/70 transition-all" :class="index===activeSlide?'w-5 bg-white':'w-2 hover:bg-white'" :aria-label="`Show ${slide.label}`" :aria-pressed="index===activeSlide" @click="selectSlide(index)"/></div></section>
<section class="mx-auto max-w-7xl px-5 py-8"><div class="grid grid-cols-3 gap-3 md:grid-cols-6"><div v-for="item in categories" :key="item.label" class="rounded-2xl border border-[var(--brand-border)] bg-white p-4 text-center"><component :is="item.icon" class="mx-auto mb-2 h-5 w-5"/><span class="text-xs font-medium">{{ item.label }}</span></div></div></section>
<section class="mx-auto max-w-7xl px-5 py-8"><div class="mb-5 flex items-end justify-between"><div><p class="text-sm text-[var(--brand-muted)]">Curated for first-time visitors</p><h2 class="text-2xl font-semibold">Popular right now</h2></div><NuxtLink to="/seoul" class="text-sm font-medium">See all →</NuxtLink></div><div class="grid gap-5 sm:grid-cols-2 lg:grid-cols-4"><PlaceCard v-for="place in places || []" :key="place.id" :place="place"/></div></section>
</main></template>

<style scoped>
.hero-image { object-position: var(--hero-desktop-position); }
@media (max-width: 767px) { .hero-image { object-position: var(--hero-mobile-position); } }
</style>
