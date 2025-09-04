CREATE OR REPLACE VIEW vw_website_yearly_salary_trend_2022 AS
SELECT *
FROM website_yearly_salary_trend
WHERE `year` = 2022
  AND (
    clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
    OR clean_title LIKE '%Analyst%'
  )
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;

SELECT	*
FROM	vw_website_yearly_salary_trend_2022
WHERE	clean_title != 'Data ANalyst';

CREATE OR REPLACE VIEW vw_website_yearly_salary_trend_2023 AS
SELECT *
FROM website_yearly_salary_trend
WHERE `year` = 2023
  AND (
    clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
    OR clean_title LIKE '%Analyst%'
  )
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;

SELECT	*
FROM	vw_website_yearly_salary_trend_2023
WHERE	clean_title != 'Data ANalyst';

CREATE OR REPLACE VIEW vw_website_yearly_salary_trend_2024 AS
SELECT *
FROM website_yearly_salary_trend
WHERE `year` = 2024
  AND (
    clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
    OR clean_title LIKE '%Analyst%'
  )
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;

SELECT	*
FROM	vw_website_yearly_salary_trend_2024
WHERE	clean_title != 'Data ANalyst';


CREATE OR REPLACE VIEW vw_website_yearly_salary_trend_2025 AS
SELECT *
FROM website_yearly_salary_trend
WHERE `year` = 2025
  AND (
    clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
    OR clean_title LIKE '%Analyst%'
  )
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;

SELECT	*
FROM	vw_website_yearly_salary_trend_2025
WHERE	clean_title != 'Data ANalyst';