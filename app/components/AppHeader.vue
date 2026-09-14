<script setup lang="ts">import { Heart, Search, UserRound } from 'lucide-vue-next'</script>
<template>
  <header class="sticky top-0 z-50 border-b border-[var(--brand-border)] bg-white/95 backdrop-blur">
    <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-5">
      <BrandLogo />
      <nav class="hidden items-center gap-6 text-sm md:flex">
        <NuxtLink to="/seoul">Destinations</NuxtLink><NuxtLink to="/seongsu">Local</NuxtLink><a href="#">Plan Your Trip</a><a href="#">Getting Around</a>
      </nav>
      <div class="flex items-center gap-4"><Search class="h-5 w-5"/><Heart class="h-5 w-5"/><UserRound class="h-5 w-5"/></div>
    </div>
  </header>
</template>
