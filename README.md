# Korea IRL v0.1 Starter

First milestone: Home → Seoul → Seongsu Local Guide → Place Detail.

## Stack
- Nuxt 4 / Vue 3 / TypeScript
- Tailwind CSS v4
- Supabase JS
- Local Supabase: PostgreSQL + PostGIS
- Lucide icons

MapLibre and shadcn-vue are deliberately deferred until the DB-to-screen flow works.

## Prerequisites
- Node.js 22+
- pnpm
- Docker-compatible runtime (Docker Desktop, Podman, OrbStack, Colima, etc.)

## Start
```bash
pnpm install
pnpm supabase:start
cp .env.example .env
# Paste the anon key shown by `supabase start` into .env
pnpm supabase:reset
pnpm supabase:types
pnpm dev
```

Open:
- http://localhost:3000
- http://localhost:3000/seoul
- http://localhost:3000/seongsu
- http://localhost:3000/place/cafe-onion-seongsu

Supabase Studio is normally at http://127.0.0.1:54323.

## Data model
`City → Neighborhood → Place`

`Route → RoutePlace → Place`

## v0.2
1. shadcn-vue: Button/Card/Badge/Tabs
2. MapLibre map + place pins
3. 10 real places + 2 routes
4. image storage strategy
5. admin/content workflow
6. My Trip + Auth after public browsing is stable
