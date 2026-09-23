import tailwindcss from '@tailwindcss/vite'

export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  css: ['maplibre-gl/dist/maplibre-gl.css', '~/assets/css/main.css'],
  vite: { plugins: [tailwindcss()] },
  runtimeConfig: {
    public: {
      supabaseUrl: process.env.NUXT_PUBLIC_SUPABASE_URL || 'http://127.0.0.1:54321',
      supabaseAnonKey: process.env.NUXT_PUBLIC_SUPABASE_ANON_KEY || '',
    },
  },
  app: {
    head: {
      titleTemplate: '%s · Travelmaker',
      meta: [{ name: 'description', content: 'Travel Korea like you actually live here.' }],
    },
  },
})
