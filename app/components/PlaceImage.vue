<script setup lang="ts">
import { MapPin } from 'lucide-vue-next'

defineOptions({ inheritAttrs: false })

withDefaults(defineProps<{
  src?: string | null
  alt: string
  sizes?: string
  loading?: 'eager' | 'lazy'
  imageClass?: string
  showPlaceholderIcon?: boolean
}>(), {
  loading: 'lazy',
  imageClass: '',
  showPlaceholderIcon: false,
})
</script>

<template>
  <div v-bind="$attrs" class="h-full w-full">
    <img v-if="src" :src="src" :alt="alt" :loading="loading" decoding="async" :sizes="sizes" :class="['h-full w-full object-cover', imageClass]" />
    <div v-else class="flex h-full w-full items-center justify-center text-[var(--brand-muted)]" role="img" :aria-label="`${alt} unavailable`">
      <MapPin v-if="showPlaceholderIcon" class="h-6 w-6" />
    </div>
  </div>
</template>
