--Домашнее задание 
--1) Добавляю Музыку
INSERT INTO dim.product (code, name, artist, product_type, product_category, unit_price, unit_cost, status, effective_ts, expire_ts, is_current)
WITH director as (
    SELECT DISTINCT f2d.film_id, first_value(fd.name) over (partition by film_id order by director_id) as director_id
    FROM nds.films_to_director f2d
    JOIN nds.films_director fd on fd.id = f2d.director_id
)
SELECT
  f.id::varchar as code,
  f.title as name,
  coalesce(director.director_id, 'Неизвестно') as artist,
  'Фильм' as product_type,
  coalesce(fg.name , 'Неизвестно') as product_category,
  f.price as unit_price,
  f.cost as unit_cost,
  CASE
      WHEN f.status = 'p' THEN 'Ожидается'
      WHEN f.status = 'o' THEN 'Доступен'
      WHEN f.status = 'e' THEN 'Не продаётся'
  END AS status,
  f.start_ts as effective_ts,
  f.end_ts as expire_ts,
  f.is_current
FROM nds.films f
LEFT JOIN director on director.film_id = f.id
LEFT JOIN nds.films_genre fg on f.genre_id = fg.id
;

--2) Добавляю Книги
--после исполнения исходного скрипта nds.sql у меня отсутствуют какие-либо записи 
--в такблице nds.book_to_author. Попытки как-то исправить ни к чему не привели.
--поэтому вместо автора укажу издательство, не оставлять большой раздел пустым

INSERT INTO dim.product (code, name, artist, product_type, product_category, unit_price, unit_cost, status, effective_ts, expire_ts, is_current)
SELECT
  b.id::varchar as code,
  b.nomenclature as name,
  coalesce(bp.name, 'Неизвестно') as artist,
  'Книга' as product_type,
  coalesce(bc.name , 'Неизвестно') as product_category,
  b.price as unit_price,
  b.cost as unit_cost,
  CASE
      WHEN b.status = 'p' THEN 'Ожидается'
      WHEN b.status = 'o' THEN 'Доступен'
      WHEN b.status = 'e' THEN 'Не продаётся'
  END AS status,
  b.start_ts as effective_ts,
  b.end_ts as expire_ts,
  b.is_current
FROM nds.book b
LEFT JOIN nds.book_category bc on bc.id = b.category_id 
LEFT JOIN nds.book_publisher bp on bp.id = b.publisher_id
;

-- проверки на корректное число элементов
SELECT count(*) FROM dim.product p 
WHERE product_type = 'Книга';

SELECT count(*) FROM nds.book b;

SELECT * FROM dim.product
WHERE product_type = 'Книга'
LIMIT 10;
--

--3) обновить в таблицу Покупатель subscriber_class
-- так и не получилось. Выдаёт ошибку:
--SQL Error [23502]: ОШИБКА: нулевое значение в столбце "id" нарушает ограничение NOT NULL
--  Detail: Ошибочная строка содержит (null, null, null, null, null, null, null, null, null, null, null, R1).

ALTER TABLE dim.customer drop COLUMN subscriber_class;

ALTER TABLE dim.customer ADD COLUMN IF NOT EXISTS subscriber_class varchar(4);

INSERT INTO dim.customer (subscriber_class)

WITH sum_sales AS 
(
	WITH sales AS 
	(
		SELECT 
			customer_key, si.sales_value, date(dt)
		FROM fact.sale_item si
		WHERE dt BETWEEN now() - INTERVAL '12 Month' AND now()
		UNION
		SELECT 
			cs.customer_id, s.price, cs.date
		FROM nds.customers_subscriptions cs
		JOIN nds.subscriptions s ON cs.subscription_id = s.id
		WHERE cs.date BETWEEN now() - INTERVAL '12 Month' AND now()
	)
	SELECT
		DISTINCT customer_key, sum(sales_value) over (partition by customer_key ) AS sum_val
	FROM sales
)
SELECT 
	CASE 
		WHEN sum_val / (SELECT max(sum_val) FROM sum_sales) <= 0.24 THEN 'R1'
    	WHEN sum_val / (SELECT max(sum_val) FROM sum_sales) BETWEEN 0.25 and 0.50 THEN 'R2'
    	WHEN sum_val / (SELECT max(sum_val) FROM sum_sales) BETWEEN 0.51 and 0.75 THEN 'R3'
    	WHEN 0.76 <= sum_val/(SELECT max(sum_val) FROM sum_sales) THEN 'R4'
	END AS subscriber_classmax
FROM sum_sales;