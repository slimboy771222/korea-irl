insert into public.cities(name,name_ko,slug,summary) values('Seoul','서울','seoul','A city of tradition, culture and endless new stories.');
insert into public.neighborhoods(city_id,name,name_ko,slug,summary)
select c.id,x.name,x.name_ko,x.slug,x.summary from public.cities c cross join (values
('Seongsu','성수','seongsu','Cafés, pop-ups, Seoul Forest and creative local culture.'),
('Hongdae','홍대','hongdae','Music, nightlife and youthful street culture.'),
('Myeongdong','명동','myeongdong','Shopping, beauty and an easy first stop in Seoul.'),
('Gangnam','강남','gangnam','Modern Seoul, shopping and K-beauty.')
) x(name,name_ko,slug,summary) where c.slug='seoul';
with n as(select id from public.neighborhoods where slug='seongsu')
insert into public.places(neighborhood_id,name,name_ko,slug,category,short_description,description,address,opening_hours,official_url,location,is_published)
select n.id,v.name,v.name_ko,v.slug,v.category,v.short_description,v.description,v.address,v.opening_hours,v.official_url,
extensions.st_point(v.longitude,v.latitude)::extensions.geography,true from n cross join (values
('Seoul Forest','서울숲','seoul-forest','Nature','A green starting point for exploring Seongsu.','Start with an easy walk through one of central Seoul’s most pleasant urban parks.','273 Ttukseom-ro, Seongdong-gu, Seoul','05:30–21:30','https://parks.seoul.go.kr/',127.0374,37.5443),
('Cafe Onion Seongsu','카페 어니언 성수','cafe-onion-seongsu','Cafe','Industrial-style bakery café in Seongsu.','A well-known bakery café in a renovated industrial space and an easy stop on a Seongsu walk.','8 Achasan-ro 9-gil, Seongdong-gu, Seoul','Check official source','https://www.instagram.com/cafe.onion/',127.0560,37.5446),
('Seongsu Pop-up Street','성수 팝업 거리','seongsu-popup-street','Shopping','A cluster of changing brand pop-ups.','Pop-ups change frequently, so use this stop as a flexible discovery segment rather than a single fixed venue.','Seongsu-dong 2-ga, Seongdong-gu, Seoul',null,null,127.0551,37.5434),
('Seongsu Shopping Walk','성수 쇼핑 거리','seongsu-shopping-walk','Shopping','Independent shops and design-focused retail.','Finish the route browsing local fashion, lifestyle and design shops around Seongsu.','Seongsu-dong, Seongdong-gu, Seoul',null,null,127.0540,37.5430)
) v(name,name_ko,slug,category,short_description,description,address,opening_hours,official_url,longitude,latitude);
insert into public.routes(neighborhood_id,name,slug,summary,duration_minutes,is_published)
select id,'Perfect 5 Hours in Seongsu','perfect-5-hours-seongsu','A walkable half-day route through Seongsu.',300,true from public.neighborhoods where slug='seongsu';
with r as(select id from public.routes where slug='perfect-5-hours-seongsu')
insert into public.route_places(route_id,place_id,stop_order,start_time,stay_minutes,stop_note)
select r.id,p.id,v.stop_order,v.start_time::time,v.stay_minutes,v.stop_note from r cross join (values
('seoul-forest',1,'11:00',60,'Start with a relaxed walk in Seoul Forest.'),
('cafe-onion-seongsu',2,'12:15',60,'Take a café break and try a bakery item.'),
('seongsu-popup-street',3,'14:00',75,'Check what pop-ups are running today.'),
('seongsu-shopping-walk',4,'15:30',90,'Browse local shops and wrap up the route.')
) v(slug,stop_order,start_time,stay_minutes,stop_note) join public.places p on p.slug=v.slug;
