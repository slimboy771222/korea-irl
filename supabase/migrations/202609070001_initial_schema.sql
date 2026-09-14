create extension if not exists pgcrypto;
create extension if not exists postgis with schema extensions;

create table public.cities (
  id uuid primary key default gen_random_uuid(), name text not null, name_ko text,
  slug text not null unique, summary text, created_at timestamptz not null default now()
);
create table public.neighborhoods (
  id uuid primary key default gen_random_uuid(), city_id uuid not null references public.cities(id) on delete cascade,
  name text not null, name_ko text, slug text not null unique, summary text, created_at timestamptz not null default now()
);
create table public.places (
  id uuid primary key default gen_random_uuid(), neighborhood_id uuid references public.neighborhoods(id) on delete set null,
  name text not null, name_ko text, slug text not null unique, category text not null,
  short_description text, description text, address text, opening_hours text, official_url text,
  cover_image_url text, location extensions.geography(Point,4326), is_published boolean not null default false,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index places_location_gix on public.places using gist(location);
create index places_category_idx on public.places(category);
create index places_published_idx on public.places(is_published);
create table public.routes (
  id uuid primary key default gen_random_uuid(), neighborhood_id uuid references public.neighborhoods(id) on delete set null,
  name text not null, slug text not null unique, summary text, duration_minutes integer,
  is_published boolean not null default false, created_at timestamptz not null default now()
);
create table public.route_places (
  route_id uuid not null references public.routes(id) on delete cascade,
  place_id uuid not null references public.places(id) on delete cascade,
  stop_order integer not null, start_time time, stay_minutes integer, stop_note text,
  primary key(route_id,stop_order), unique(route_id,place_id)
);
create or replace view public.place_cards as
select p.id,p.slug,p.name,p.name_ko,p.category,p.short_description,p.description,p.address,p.opening_hours,p.official_url,p.cover_image_url,
       n.name neighborhood,n.slug neighborhood_slug,
       extensions.st_y(p.location::extensions.geometry) latitude,
       extensions.st_x(p.location::extensions.geometry) longitude
from public.places p left join public.neighborhoods n on n.id=p.neighborhood_id where p.is_published=true;
create or replace view public.route_detail as
select r.id route_id,r.slug route_slug,r.name route_name,r.duration_minutes,rp.stop_order,rp.start_time,rp.stay_minutes,rp.stop_note,
       p.id place_id,p.slug place_slug,p.name place_name,p.category place_category,
       extensions.st_y(p.location::extensions.geometry) latitude,
       extensions.st_x(p.location::extensions.geometry) longitude
from public.routes r join public.route_places rp on rp.route_id=r.id join public.places p on p.id=rp.place_id
where r.is_published=true and p.is_published=true;
alter table public.cities enable row level security;
alter table public.neighborhoods enable row level security;
alter table public.places enable row level security;
alter table public.routes enable row level security;
alter table public.route_places enable row level security;
create policy "Public read cities" on public.cities for select using(true);
create policy "Public read neighborhoods" on public.neighborhoods for select using(true);
create policy "Public read published places" on public.places for select using(is_published=true);
create policy "Public read published routes" on public.routes for select using(is_published=true);
create policy "Public read route stops" on public.route_places for select using(exists(select 1 from public.routes r where r.id=route_id and r.is_published=true));
grant select on public.place_cards to anon,authenticated;
grant select on public.route_detail to anon,authenticated;
