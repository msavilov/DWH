DROP TABLE IF EXISTS stage.films;

CREATE TABLE stage.films (
	id varchar(10),
	title varchar(400),
	studio varchar(400),
	"year" varchar(200),
	director varchar(400),
	srcipt_author varchar(400),
	cameraman varchar(400),
	age varchar(200),
	genre varchar(200),
	country varchar(400),
	category varchar(100),
	price double precision,
	"cost" double precision,
	status char(1),
	"date" varchar(20)
);

insert into metadata.csv (filename, schema_name, table_name, source_field, source_field_type, target_field, target_field_type, ord, "decimal")
VALUES
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'ID', 'String', 'ID', 'varchar(400)', 19, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'НАЗВАНИЕ', 'String', 'title', 'varchar(400)', 20, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'СТУДИЯ', 'String', 'studio', 'varchar(400)', 21, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'ГОД ПРОИЗВОДСТВА', 'String', 'year', 'varchar(200)', 22, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'РЕЖИССЁР', 'String', 'director', 'varchar(400)', 23, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'СЦЕНАРИСТ', 'String', 'srcipt_author', 'varchar(400)', 24, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'ОПЕРАТОР', 'String', 'cameraman', 'varchar(400)', 25, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'ВОЗРАСТНАЯ КАТЕГОРИЯ', 'String', 'age', 'varchar(200)', 26, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'ЖАНР', 'String', 'genre', 'varchar(200)', 27, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'СТРАНА', 'String', 'country', 'varchar(400)', 28, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'КАТЕГОРИЯ', 'String', 'category', 'varchar(100)', 29, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'РОЗНИЧНАЯ', 'Number', 'price', 'double precision', 30, '.'),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'СЕБЕСТОИМОСТЬ', 'Number', 'cost', 'double precision', 31, '.'),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'СТАТУС', 'String', 'status', 'char(1)', 32, ','),
	('D:\Netology Data Engineer\2. DWH\5_ETL_Pentaho2\csv\films.csv', 'stage', 'films',  'ДАТА', 'String', 'date', 'varchar(20)', 33, ',')
;

TRUNCATE stage.films;

SELECT * FROM stage.books b ;