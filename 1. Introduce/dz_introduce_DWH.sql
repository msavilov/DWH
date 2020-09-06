create table films (
id integer (10) PRIMARY KEY
film_key integer (10) not null
id_films integer CONSTRAINT firstkey PRIMARY KEY,
title varchar (100) NOT null
FOREIGN KEY (id_genre) REFERENCES films_genre (id_genre)
FOREIGN KEY (id_genre) REFERENCES films_genre (id_genre)
FOREIGN KEY (film_key) REFERENCES films_raw (id)

);

create table films_genre (
id_genre integer CONSTRAINT firstkey PRIMARY key
genre varchar (40) not null

);

create table films_studio (
id_genre integer CONSTRAINT firstkey PRIMARY key
genre varchar (40) not null
);