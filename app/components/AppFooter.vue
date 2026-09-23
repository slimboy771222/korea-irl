<template>
  <footer class="bg-[var(--brand-ink)] text-white">
    <div class="mx-auto max-w-7xl px-5 py-8 md:py-10">
      <div class="grid gap-8 md:grid-cols-[1fr_auto_auto] md:gap-16">
        <div class="max-w-sm">
          <NuxtLink to="/" class="inline-flex shrink-0 items-center">
            <img src="/brand/travelmaker-logo-footer.png" alt="Travelmaker Korea" class="h-12 w-auto md:h-14" decoding="async">
          </NuxtLink>
          <p class="mt-3 text-sm font-medium text-white/80">Korea, in real life.</p>
          <p class="mt-1 text-sm leading-6 text-white/65">Travel Korea like you actually live here.<br>Real tips. Local spots. Routes that make sense.</p>
        </div>

        <nav aria-label="Explore" class="text-sm">
          <h2 class="font-medium text-white">Explore</h2>
          <div class="mt-3 flex flex-wrap gap-x-5 gap-y-2 text-white/65 md:flex-col md:gap-2">
            <NuxtLink to="/seoul" class="transition-colors hover:text-white">Destinations</NuxtLink>
            <NuxtLink to="/seongsu" class="transition-colors hover:text-white">Local</NuxtLink>
            <span class="text-white/45">Food</span>
            <span class="text-white/45">K-Culture</span>
          </div>
        </nav>

        <nav aria-label="Plan" class="text-sm">
          <h2 class="font-medium text-white">Plan</h2>
          <div class="mt-3 flex flex-wrap gap-x-5 gap-y-2 text-white/65 md:flex-col md:gap-2">
            <NuxtLink to="/seongsu" class="transition-colors hover:text-white">Itineraries</NuxtLink>
            <span class="text-white/45">Getting Around</span>
            <span class="text-white/45">Korea 101</span>
            <span class="text-white/45">Travel Tips</span>
          </div>
        </nav>
      </div>

      <div class="mt-8 flex flex-col gap-2 border-t border-white/15 pt-4 text-xs text-white/50 md:mt-10 md:flex-row md:items-center md:justify-between">
        <p>© 2026 Travelmaker. All rights reserved.</p>
        <p>Built by Travelmaker</p>
      </div>
    </div>
  </footer>
</template>
