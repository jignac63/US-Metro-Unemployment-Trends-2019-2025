--1) List tables you own

SELECT TABLE_NAME
FROM user_tables;
--2) Preview your raw dataset
SELECT *
FROM "New-Data"
FETCH FIRST 5 ROWS ONLY;
--3) See columns + order + types
SELECT column_id, column_name, data_type
FROM user_tab_columns
WHERE table_name = 'New-Data'
ORDER BY column_id;
--4) Create cleaned “fact” table
CREATE TABLE UNEMP_FACT (
    SERIES_ID VARCHAR2(100),
    SERIES_NAME VARCHAR2(400),
    UNITS VARCHAR2(100),
    REGION_NAME VARCHAR2(200),
    REGION_CODE VARCHAR2(50),
    OBS_DATE DATE,
    VALUE_NUM NUMBER
);

--5) Generate the UNPIVOT INSERT script dynamically
--Your big query creates a text string that becomes an INSERT…SELECT statement using UNPIVOT across all date columns.

SELECT
'INSERT INTO UNEMP_FACT (SERIES_ID, SERIES_NAME, UNITS, REGION_NAME, REGION_CODE, OBS_DATE, VALUE_NUM)
 SELECT SERIES_ID, SERIES_NAME, UNITS, REGION_NAME, REGION_CODE,
        TO_DATE(obs_date, ''YYYY-MM-DD'') AS obs_date,
        CASE
          WHEN value IS NULL OR TRIM(value) IS NULL THEN NULL
          ELSE TO_NUMBER(REGEXP_REPLACE(value, ''[^0-9\.\-]'', ''''))
        END AS value_num
 FROM "NEW-DATA"
 UNPIVOT (value FOR obs_date IN ('
||
LISTAGG('"'||COLUMN_NAME||'" AS '''||COLUMN_NAME||'''', ', ')
  WITHIN GROUP (ORDER BY COLUMN_ID)
||
'));'
AS GENERATED_SQL
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'New-Data'
  AND REGEXP_LIKE(COLUMN_NAME, '^\d{4}-\d{2}-\d{2}$');

--Step A — Fix one issue first (important) Oracle stores unquoted object names in uppercase. Your table is "New-Data" (quoted, mixed case). That causes pain.
CREATE TABLE NEW_DATA AS
SELECT * FROM "New-Data";


DROP Table UNEMP_FACT PURGE;
  
  CREATE TABLE UNEMP_FACT (
    SERIES_ID    VARCHAR2(100),
    SERIES_NAME  VARCHAR2(400),
    UNITS        VARCHAR2(100),
    REGION_NAME  VARCHAR2(200),
    REGION_CODE  VARCHAR2(50),
    OBS_DATE     DATE,
    VALUE_NUM    NUMBER
);

--Step C — Generate the INSERT SQL again (but for NEW_DATA)
SELECT
'INSERT INTO UNEMP_FACT (SERIES_ID, SERIES_NAME, UNITS, REGION_NAME, REGION_CODE, OBS_DATE, VALUE_NUM)
 SELECT SERIES_ID, SERIES_NAME, UNITS, REGION_NAME, REGION_CODE,
        TO_DATE(obs_date, ''YYYY-MM-DD'') AS obs_date,
        CASE
          WHEN value IS NULL OR TRIM(value) IS NULL THEN NULL
          ELSE TO_NUMBER(REGEXP_REPLACE(value, ''[^0-9\.\-]'', ''''))
        END AS value_num
 FROM NEW_DATA
 UNPIVOT (value FOR obs_date IN ('
||
LISTAGG('"'||COLUMN_NAME||'" AS '''||COLUMN_NAME||'''', ', ')
  WITHIN GROUP (ORDER BY COLUMN_ID)
||
'));'
AS GENERATED_SQL
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'NEW_DATA'
  AND REGEXP_LIKE(COLUMN_NAME, '^\d{4}-\d{2}-\d{2}$');


---------The Query for  Visualization in Power BI-----

--1) Confirm the problem (run this)
SELECT data_type, COUNT(*) cnt
FROM user_tab_columns
WHERE table_name = 'NEW_DATA'
  AND REGEXP_LIKE(column_name, '^\d{4}-\d{2}-\d{2}$')
GROUP BY data_type
ORDER BY cnt DESC;

--Step 1 — Identify the VARCHAR2 column
SELECT column_name
FROM user_tab_columns
WHERE table_name = 'NEW_DATA'
  AND REGEXP_LIKE(column_name, '^\d{4}-\d{2}-\d{2}$')
  AND data_type = 'VARCHAR2';

  -- Step 2 — Convert that one column to NUMBER
UPDATE NEW_DATA
SET "2025-10-01" =
    TO_NUMBER(REGEXP_REPLACE("2025-10-01", '[^0-9\.\-]', ''));

COMMIT;

--Step 3 — Change its datatype to NUMBER
ALTER TABLE NEW_DATA
MODIFY ("2025-10-01" NUMBER);

--Step 4 — Verify again
SELECT data_type, COUNT(*)
FROM user_tab_columns
WHERE table_name = 'NEW_DATA'
  AND REGEXP_LIKE(column_name, '^\d{4}-\d{2}-\d{2}$')
GROUP BY data_type;

--Instead of creating extra views,we fixed the root cause:All UNPIVOT columns must have same datatype.This is exactly what you would do in a real company environment.



INSERT INTO UNEMP_FACT (SERIES_ID, SERIES_NAME, UNITS, REGION_NAME, REGION_CODE, OBS_DATE, VALUE_NUM)
 SELECT SERIES_ID, SERIES_NAME, UNITS, REGION_NAME, REGION_CODE,
        TO_DATE(obs_date, 'YYYY-MM-DD') AS obs_date,
        CASE
          WHEN value IS NULL OR TRIM(value) IS NULL THEN NULL
          ELSE TO_NUMBER(REGEXP_REPLACE(value, '[^0-9\.\-]', ''))
        END AS value_num
 FROM NEW_DATA
 UNPIVOT (value FOR obs_date IN ("2019-01-01" AS '2019-01-01', "2019-02-01" AS '2019-02-01', "2019-03-01" AS '2019-03-01', "2019-04-01" AS '2019-04-01', "2019-05-01" AS '2019-05-01', "2019-06-01" AS '2019-06-01', "2019-07-01" AS '2019-07-01', "2019-08-01" AS '2019-08-01', "2019-09-01" AS '2019-09-01', "2019-10-01" AS '2019-10-01', "2019-11-01" AS '2019-11-01', "2019-12-01" AS '2019-12-01', "2020-01-01" AS '2020-01-01', "2020-02-01" AS '2020-02-01', "2020-03-01" AS '2020-03-01', "2020-04-01" AS '2020-04-01', "2020-05-01" AS '2020-05-01', "2020-06-01" AS '2020-06-01', "2020-07-01" AS '2020-07-01', "2020-08-01" AS '2020-08-01', "2020-09-01" AS '2020-09-01', "2020-10-01" AS '2020-10-01', "2020-11-01" AS '2020-11-01', "2020-12-01" AS '2020-12-01', "2021-01-01" AS '2021-01-01', "2021-02-01" AS '2021-02-01', "2021-03-01" AS '2021-03-01', "2021-04-01" AS '2021-04-01', "2021-05-01" AS '2021-05-01', "2021-06-01" AS '2021-06-01', "2021-07-01" AS '2021-07-01', "2021-08-01" AS '2021-08-01', "2021-09-01" AS '2021-09-01', "2021-10-01" AS '2021-10-01', "2021-11-01" AS '2021-11-01', "2021-12-01" AS '2021-12-01', "2022-01-01" AS '2022-01-01', "2022-02-01" AS '2022-02-01', "2022-03-01" AS '2022-03-01', "2022-04-01" AS '2022-04-01', "2022-05-01" AS '2022-05-01', "2022-06-01" AS '2022-06-01', "2022-07-01" AS '2022-07-01', "2022-08-01" AS '2022-08-01', "2022-09-01" AS '2022-09-01', "2022-10-01" AS '2022-10-01', "2022-11-01" AS '2022-11-01', "2022-12-01" AS '2022-12-01', "2023-01-01" AS '2023-01-01', "2023-02-01" AS '2023-02-01', "2023-03-01" AS '2023-03-01', "2023-04-01" AS '2023-04-01', "2023-05-01" AS '2023-05-01', "2023-06-01" AS '2023-06-01', "2023-07-01" AS '2023-07-01', "2023-08-01" AS '2023-08-01', "2023-09-01" AS '2023-09-01', "2023-10-01" AS '2023-10-01', "2023-11-01" AS '2023-11-01', "2023-12-01" AS '2023-12-01', "2024-01-01" AS '2024-01-01', "2024-02-01" AS '2024-02-01', "2024-03-01" AS '2024-03-01', "2024-04-01" AS '2024-04-01', "2024-05-01" AS '2024-05-01', "2024-06-01" AS '2024-06-01', "2024-07-01" AS '2024-07-01', "2024-08-01" AS '2024-08-01', "2024-09-01" AS '2024-09-01', "2024-10-01" AS '2024-10-01', "2024-11-01" AS '2024-11-01', "2024-12-01" AS '2024-12-01', "2025-01-01" AS '2025-01-01', "2025-02-01" AS '2025-02-01', "2025-03-01" AS '2025-03-01', "2025-04-01" AS '2025-04-01', "2025-05-01" AS '2025-05-01', "2025-06-01" AS '2025-06-01', "2025-07-01" AS '2025-07-01', "2025-08-01" AS '2025-08-01', "2025-09-01" AS '2025-09-01', "2025-10-01" AS '2025-10-01', "2025-11-01" AS '2025-11-01'));

 --1) Quick confirm 

 SELECT data_type, COUNT(*) cnt
FROM user_tab_columns
WHERE table_name = 'NEW_DATA'
  AND REGEXP_LIKE(column_name, '^\d{4}-\d{2}-\d{2}$')
GROUP BY data_type;

--3) Verify the load worked
SELECT COUNT(*) AS rows_loaded
FROM UNEMP_FACT;

SELECT *
FROM UNEMP_FACT
FETCH FIRST 10 ROWS ONLY;

--1) Sanity checks (do these 3)
--A) Row count (did we load data?)

SELECT count(*) AS rows_loaded
FROM UNEMP_FACT

--B) Date range
SELECT MIN(obs_date) AS min_date, MAX(obs_date) AS max_date
FROM UNEMP_FACT;

--C) Quick null check
SELECT
SUM(CASE WHEN value_num IS NULL THEN 1 ELSE 0 END) AS null_values,
COUNT(*) AS total_rows
FROM UNEMP_FACT;

--2) Create 3 “Power BI-ready” views (use these for charts)
CREATE OR REPLACE VIEW VW_UNEMP_TREND AS
SELECT obs_date,
       AVG(value_num) AS avg_unemp_rate
FROM UNEMP_FACT
WHERE value_num IS NOT NULL
GROUP BY obs_date;

--View 2: Top 10 metros by latest month unemployment

CREATE OR REPLACE VIEW VW_UNEMP_TOP10_LATEST AS
WITH latest AS (
  SELECT MAX(obs_date) AS max_dt FROM UNEMP_FACT
)
SELECT region_name,
       value_num AS unemp_rate_latest
FROM UNEMP_FACT f
JOIN latest l ON f.obs_date = l.max_dt
WHERE value_num IS NOT NULL
ORDER BY value_num DESC
FETCH FIRST 10 ROWS ONLY;

--View 3: Year-over-Year change by metro (latest month vs same month last year)

CREATE OR REPLACE VIEW VW_UNEMP_YOY_CHANGE AS
WITH latest AS (
  SELECT MAX(obs_date) AS max_dt FROM UNEMP_FACT
),
cur AS (
  SELECT region_name, value_num AS cur_rate
  FROM UNEMP_FACT f JOIN latest l ON f.obs_date = l.max_dt
),
prev AS (
  SELECT region_name, value_num AS prev_rate
  FROM UNEMP_FACT f JOIN latest l ON f.obs_date = ADD_MONTHS(l.max_dt, -12)
)
SELECT c.region_name,
       c.cur_rate,
       p.prev_rate,
       (c.cur_rate - p.prev_rate) AS yoy_change
FROM cur c
LEFT JOIN prev p ON c.region_name = p.region_name
ORDER BY yoy_change DESC NULLS LAST;
