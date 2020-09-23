DROP TABLE IF EXISTS public.films CASCADE;

CREATE TABLE public.films (
	id serial PRIMARY KEY,
	film_key int,
	title varchar(400) NOT null,
	studio SMALLINT REFERENCES public.studio(id),
	"year" SMALLINT REFERENCES public."year"(id),
	director SMALLINT REFERENCES public.director(id),
	script_author SMALLINT REFERENCES public.script_author(id),
	cameraman SMALLINT REFERENCES public.cameraman(id),
	"age" SMALLINT REFERENCES public."age"(id),
	genre SMALLINT REFERENCES public.genre(id),
	country	SMALLINT REFERENCES public.country(id),
	category SMALLINT REFERENCES public.category(id),
	price varchar(10),
	"cost" varchar(10),
	status bpchar(1),
	start_ts date,
	end_ts date,
	is_corrent boolean,
	create_ts date,
	update_ts date
);

INSERT INTO public.films (film_key, title, studio, "year", director, script_author, cameraman, "age", genre, country, category, price, "cost", status, start_ts, end_ts, is_corrent, create_ts, update_ts)
SELECT
	fr.id AS film_key,
	fr.title AS title,
	s.id AS studio,
	y.id AS "year",
	d.id AS director,
	sa.id AS script_author,
	cm.id AS cameraman,
	pa.id AS "age",
	g.id AS genre,
	co.id AS country,
	c.id AS category,
	fr.price AS price,
	fr."cost" AS "cost",
	fr.status AS status,
	COALESCE(fr."date"::date, '1900-01-01'::date) AS start_ts,
	COALESCE(((LEAD(date) OVER w)::date - INTERVAL '1 day')::date, '2999-12-31'::date) as end_ts,
	(((LEAD(date) OVER w)::date - INTERVAL '1 day')::date IS null)::bool AS is_corrent,
	LOCALTIMESTAMP AS create_ts,
	LOCALTIMESTAMP AS update_ts
FROM films_raw fr
JOIN public.cameraman cm ON fr.cameraman = cm."name"
JOIN public.age pa ON fr.age = pa.name
JOIN public.category c ON fr.category = c."name"
JOIN public.country co ON fr.country = co."name"
JOIN public.director d ON fr.director = d."name"
JOIN public.studio s ON fr.studio = s."name"
JOIN public."year" y ON fr."year" = y."year"
JOIN public.script_author sa ON fr.script_author = sa."name"
JOIN public.genre g ON fr.genre = g."name"
WINDOW w AS (PARTITION BY fr.id ORDER BY fr.date);

--
--Создам таблицу для Студий и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.studio;
CREATE TABLE public.studio (
	id serial PRIMARY KEY,
	name varchar(400)
);
INSERT INTO public.studio(name)
SELECT 
	DISTINCT unnest(string_to_array(studio, ', '))
FROM public.films_raw;
--

--Создам таблицу для Года и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public."year";
CREATE TABLE public."year" (
	id serial PRIMARY KEY,
	"year" varchar(200)
);
INSERT INTO public."year"("year")
SELECT 
	DISTINCT year
FROM public.films_raw;
--

--Создам таблицу для Режисёра и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.director;
CREATE TABLE public.director (
	id serial PRIMARY KEY,
	"name" varchar(400)
);
INSERT INTO public.director("name")
SELECT 
	DISTINCT unnest(string_to_array("director", ', '))
FROM public.films_raw;
--

--Создам таблицу для Сценариста и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.script_author;
CREATE TABLE public.script_author (
	id serial PRIMARY KEY,
	"name" varchar(400)
);
INSERT INTO public.script_author("name")
SELECT 
	DISTINCT unnest(string_to_array(script_author, ', '))
FROM public.films_raw;
--

--Создам таблицу для Оператора и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.cameraman;
CREATE TABLE public.cameraman (
	id serial PRIMARY KEY,
	"name" varchar(400)
);
INSERT INTO public.cameraman("name")
SELECT 
	DISTINCT unnest(string_to_array(cameraman, ', '))
FROM public.films_raw;
--

--Создам таблицу для Возрастной категории и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public."age";
CREATE TABLE public."age" (
	id serial PRIMARY KEY,
	"name" varchar(400)
);
INSERT INTO public."age"("name")
SELECT 
	DISTINCT "age"
FROM public.films_raw;
--

--Создам таблицу для Жанра и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.genre;
CREATE TABLE public.genre (
	id serial PRIMARY KEY,
	"name" varchar(400)
);
INSERT INTO public.genre("name")
SELECT 
	DISTINCT unnest(string_to_array(genre, ', '))
FROM public.films_raw;
--

--
--Создам таблицу для Стран и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.country;
CREATE TABLE public.country (
	id serial PRIMARY KEY,
	name varchar(400)
);
INSERT INTO public.country(name)
SELECT 
	DISTINCT unnest(string_to_array(country, '|'))
FROM public.films_raw;
--

--
--Создам таблицу для Жанра и наполню её уникальными записями из films_raw
DROP TABLE IF EXISTS public.category;
CREATE TABLE public.category (
	id serial PRIMARY KEY,
	"name" varchar(400)
);
INSERT INTO public.category("name")
SELECT 
	DISTINCT category
FROM public.films_raw;
--


--создам "переходные" таблицы. Заполнять их не стал 

CREATE TABLE public.films_to_country (
	film_id int NOT NULL references public.films(id),
	country_id int NOT NULL REFERENCES public.country(id)
);
CREATE TABLE public.films_to_age (
	film_id int NOT NULL references public.films(id),
	age_id int NOT NULL REFERENCES public."age"(id)
);
CREATE TABLE public.films_to_cameraman (
	film_id int NOT NULL references public.films(id),
	cameraman_id int NOT NULL REFERENCES public.cameraman(id)
);
CREATE TABLE public.films_to_category (
	film_id int NOT NULL references public.films(id),
	category_id int NOT NULL REFERENCES public.category(id)
);
CREATE TABLE public.films_to_director (
	film_id int NOT NULL references public.films(id),
	director_id int NOT NULL REFERENCES public.director(id)
);
CREATE TABLE public.films_to_genre (
	film_id int NOT NULL references public.films(id),
	genre_id int NOT NULL REFERENCES public.genre(id)
);
CREATE TABLE public.films_to_script_author (
	film_id int NOT NULL references public.films(id),
	script_author_id int NOT NULL REFERENCES public.script_author(id)
);
CREATE TABLE public.films_to_script_studio(
	film_id int NOT NULL references public.films(id),
	studio_id int NOT NULL REFERENCES public.studio(id)
);
CREATE TABLE public.films_to_script_year (
	film_id int NOT NULL references public.films(id),
	year_id int NOT NULL REFERENCES public."year"(id)
);