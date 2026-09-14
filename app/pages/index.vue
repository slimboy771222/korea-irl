<script setup lang="ts">
import { Map, MapPin, Utensils, Music, ShoppingBag, Mountain } from 'lucide-vue-next'
useSeoMeta({ title:'Travel Korea Like You Actually Live Here', description:'Local routes, practical tips and authentic places for your trip to Korea.' })
const { $supabase } = useNuxtApp()
const { data: places } = await useAsyncData('home-places', async()=>{ const {data,error} = await $supabase.from('place_cards').select('*').limit(4); if(error) throw error; return data })
const categories=[{label:'Itinerary',icon:Map},{label:'Destinations',icon:MapPin},{label:'Food',icon:Utensils},{label:'K-Culture',icon:Music},{label:'Shopping',icon:ShoppingBag},{label:'Nature',icon:Mountain}]
</script>
<template><main>
<section class="bg-[linear-gradient(120deg,#1f2937,#6b7280)] text-white"><div class="mx-auto max-w-7xl px-5 py-20 md:py-28"><p class="mb-3 text-sm font-medium uppercase tracking-[0.18em]">Korea, in real life</p><h1 class="max-w-2xl text-4xl font-semibold leading-tight md:text-6xl">Travel Korea<br>Like You Actually<br>Live Here.</h1><p class="mt-5 max-w-xl text-white/80">Real tips. Local spots. Routes that make sense.</p><div class="mt-8 flex max-w-xl rounded-xl bg-white p-2 text-[var(--brand-ink)] shadow-xl"><input class="min-w-0 flex-1 bg-transparent px-3 outline-none" placeholder="Where do you want to go?"/><button class="rounded-lg bg-[var(--brand-ink)] px-5 py-3 text-sm text-white">Search</button></div></div></section>
<section class="mx-auto max-w-7xl px-5 py-8"><div class="grid grid-cols-3 gap-3 md:grid-cols-6"><div v-for="item in categories" :key="item.label" class="rounded-2xl border border-[var(--brand-border)] bg-white p-4 text-center"><component :is="item.icon" class="mx-auto mb-2 h-5 w-5"/><span class="text-xs font-medium">{{ item.label }}</span></div></div></section>
<section class="mx-auto max-w-7xl px-5 py-8"><div class="mb-5 flex items-end justify-between"><div><p class="text-sm text-[var(--brand-muted)]">Curated for first-time visitors</p><h2 class="text-2xl font-semibold">Popular right now</h2></div><NuxtLink to="/seoul" class="text-sm font-medium">See all →</NuxtLink></div><div class="grid gap-5 sm:grid-cols-2 lg:grid-cols-4"><PlaceCard v-for="place in places || []" :key="place.id" :place="place"/></div></section>
</main></template>
