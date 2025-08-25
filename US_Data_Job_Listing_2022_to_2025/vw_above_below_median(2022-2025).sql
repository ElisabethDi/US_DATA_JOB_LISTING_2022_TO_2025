CREATE OR REPLACE VIEW vw_above_below_median_2022 AS
WITH ordered_median AS (
  SELECT
    job.`year` AS job_year,
    job.clean_title,
    job.salary_yearly,
    m.median_salary,
    CASE
      WHEN job.salary_yearly > m.median_salary THEN 'Above Median'
      WHEN job.salary_yearly < m.median_salary THEN 'Below Median'
      ELSE 'At Median'
    END AS Comparison
  FROM `2022_job_data` AS job
  LEFT JOIN `median_salary_view` AS m
    ON job.clean_title = m.clean_title
   AND m.month_year = DATE_FORMAT(job.`date`, '%Y-%m')
  WHERE job.salary_yearly IS NOT NULL
    AND (
      job.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR job.clean_title LIKE '%Analyst%'
    )
)
SELECT
  job_year,
  clean_title,
  salary_yearly,
  median_salary,
  Comparison
FROM ordered_median;

SELECT	*
FROM	vw_above_below_median_2022;

CREATE OR REPLACE VIEW vw_above_below_median_2023 AS
WITH ordered_median AS (
  SELECT
    job.`year` AS job_year,
    job.clean_title,
    job.salary_yearly,
    m.median_salary,
    CASE
      WHEN job.salary_yearly > m.median_salary THEN 'Above Median'
      WHEN job.salary_yearly < m.median_salary THEN 'Below Median'
      ELSE 'At Median'
    END AS Comparison
  FROM `2023_job_data` AS job
  LEFT JOIN `median_salary_view` AS m
    ON job.clean_title = m.clean_title
   AND m.month_year = DATE_FORMAT(job.`date`, '%Y-%m')
  WHERE job.salary_yearly IS NOT NULL
    AND (
      job.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR job.clean_title LIKE '%Analyst%'
    )
)
SELECT
  job_year,
  clean_title,
  salary_yearly,
  median_salary,
  Comparison
FROM ordered_median;

SELECT	*
FROM	vw_above_below_median_2023;


CREATE OR REPLACE VIEW vw_above_below_median_2024 AS
WITH ordered_median AS (
  SELECT
    job.`year` AS job_year,
    job.clean_title,
    job.salary_yearly,
    m.median_salary,
    CASE
      WHEN job.salary_yearly > m.median_salary THEN 'Above Median'
      WHEN job.salary_yearly < m.median_salary THEN 'Below Median'
      ELSE 'At Median'
    END AS Comparison
  FROM `2024_job_data` AS job
  LEFT JOIN `median_salary_view` AS m
    ON job.clean_title = m.clean_title
   AND m.month_year = DATE_FORMAT(job.`date`, '%Y-%m')
  WHERE job.salary_yearly IS NOT NULL
    AND (
      job.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR job.clean_title LIKE '%Analyst%'
    )
)
SELECT
  job_year,
  clean_title,
  salary_yearly,
  median_salary,
  Comparison
FROM ordered_median;

SELECT	*
FROM	vw_above_below_median_2024
WHERE	clean_title LIKE '%Analyst%'
 AND 	clean_title != 'Data Analyst';

CREATE OR REPLACE VIEW vw_above_below_median_2025 AS
WITH ordered_median AS (
  SELECT
    job.`year` AS job_year,
    job.clean_title,
    job.salary_yearly,
    m.median_salary,
    CASE
      WHEN job.salary_yearly > m.median_salary THEN 'Above Median'
      WHEN job.salary_yearly < m.median_salary THEN 'Below Median'
      ELSE 'At Median'
    END AS Comparison
  FROM `2025_job_data` AS job
  LEFT JOIN `median_salary_view` AS m
    ON job.clean_title = m.clean_title
   AND m.month_year = DATE_FORMAT(job.`date`, '%Y-%m')
  WHERE job.salary_yearly IS NOT NULL
    AND (
      job.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR job.clean_title LIKE '%Analyst%'
    )
)
SELECT
  job_year,
  clean_title,
  salary_yearly,
  median_salary,
  Comparison
FROM ordered_median;

SELECT	*
FROM	vw_above_below_median_2025;

