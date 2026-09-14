<script setup lang="ts">
import { Heart, MapPin } from 'lucide-vue-next'
defineProps<{ place: { slug:string; name:string; short_description?:string|null; neighborhood?:string|null; category?:string|null; cover_image_url?:string|null } }>()
</script>
<template>
  <article class="overflow-hidden rounded-2xl border border-[var(--brand-border)] bg-white transition hover:-translate-y-0.5 hover:shadow-md">
    <NuxtLink :to="`/place/${place.slug}`">
      <div class="aspect-[4/3] bg-neutral-200"><img v-if="place.cover_image_url" :src="place.cover_image_url" :alt="place.name" class="h-full w-full object-cover"/></div>
      <div class="p-4"><div class="mb-2 flex items-start justify-between gap-3"><div><h3 class="font-semibold">{{ place.name }}</h3><p class="mt-1 flex items-center gap-1 text-xs text-[var(--brand-muted)]"><MapPin class="h-3.5 w-3.5"/> {{ place.neighborhood || 'Seoul' }} · {{ place.category || 'Place' }}</p></div><Heart class="h-5 w-5 shrink-0"/></div><p class="line-clamp-2 text-sm text-[var(--brand-muted)]">{{ place.short_description }}</p></div>
    </NuxtLink>
  </article>
</template>
