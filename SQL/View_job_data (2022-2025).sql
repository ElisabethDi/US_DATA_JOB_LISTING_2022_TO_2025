-- ================================================================================ --

-- Create a View to access monthly and yearly medians salaries. --
-- Join these medians monthly and yearly salary Views to fact tables to flag over- or under salaries --
-- Use these Views to Integrate into dashboards to track trends and share insights. --
-- --------------------------------------------------------------------------------------- --
-- View: Calculates the median salary for each job title by month and year. --

DROP VIEW IF EXISTS median_salary_view;

DELIMITER //

CREATE VIEW median_salary_view AS
SELECT
  clean_title,
  DATE_FORMAT(date, '%Y-%m') AS month_year,
  YEAR(date) AS year,
  CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2)) AS median_salary
FROM (
  SELECT
    clean_title,
    salary_yearly,
    date,
    ROW_NUMBER() OVER (
      PARTITION BY clean_title, DATE_FORMAT(date, '%Y-%m')
      ORDER BY salary_yearly
    ) AS row_num,
    COUNT(*) OVER (
      PARTITION BY clean_title, DATE_FORMAT(date, '%Y-%m')
    ) AS total_rows
  FROM jobs_master
  WHERE salary_yearly IS NOT NULL
) AS monthly_stats
WHERE row_num IN (
  FLOOR((total_rows + 1) / 2),
  CEIL((total_rows + 1) / 2)
)
GROUP BY clean_title, month_year, year
ORDER BY clean_title, month_year, year;

DELIMITER;

-- ============================================================================== --

SELECT	*
FROM	median_salary_view;