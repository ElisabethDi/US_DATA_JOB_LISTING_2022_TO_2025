-- Stored Procedure: MEDIAN_MONTHLY_SALARY()
-- ============================================================== --
DELIMITER //
DROP PROCEDURE IF EXISTS median_monthly_salary;
CREATE PROCEDURE median_monthly_salary(IN period_year_month VARCHAR(7))
BEGIN
  SELECT
    clean_title,
    month_year,
    CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2)) AS median_salary
  FROM (
    SELECT
      clean_title,
      salary_yearly,
      DATE_FORMAT(date, '%Y-%m') AS month_year,
      ROW_NUMBER() OVER (PARTITION BY clean_title, DATE_FORMAT(date, '%Y-%m') ORDER BY salary_yearly) AS row_num,
      COUNT(*) OVER (PARTITION BY clean_title, DATE_FORMAT(date, '%Y-%m')) AS total_rows
    FROM jobs_master
    WHERE DATE_FORMAT(date, '%Y-%m') = period_year_month
      AND salary_yearly IS NOT NULL
  ) AS monthly_stats
  WHERE row_num IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
  )
  GROUP BY clean_title, month_year
  ORDER BY clean_title, month_year;
END//
DELIMITER ;
-- ==================================================== --
CALL median_monthly_salary ('2022-11');
-- ===================================================== --
-- Stored Procedure: MEDIAN SALARY EVERY MONTH () --

DROP PROCEDURE IF EXISTS median_salary_every_month;

DELIMITER //
DROP PROCEDURE IF EXISTS median_salary_every_month;
CREATE PROCEDURE median_salary_every_month()
BEGIN
  SELECT
    clean_title,
    month_year AS 'month',
    CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2)) AS median_salary
  FROM (
    SELECT
      clean_title,
      salary_yearly,
      DATE_FORMAT(date, '%Y-%m') AS month_year,
      ROW_NUMBER() OVER (PARTITION BY clean_title, DATE_FORMAT(date, '%Y-%m') ORDER BY salary_yearly) AS row_num,
      COUNT(*) OVER (PARTITION BY clean_title, DATE_FORMAT(date, '%Y-%m')) AS total_rows
    FROM jobs_master
    WHERE salary_yearly IS NOT NULL
  ) AS temp_table
  WHERE row_num IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
  )
  GROUP BY clean_title, month_year
  ORDER BY clean_title, month_year;
END//
DELIMITER ;
-- ========================================================= --
CALL median_salary_every_month();
-- ========================================================= --

-- Stored Procedure: MEDIAN YEARLY SALARY () --

DELIMITER //
DROP PROCEDURE IF EXISTS median_yearly_salary;
CREATE PROCEDURE median_yearly_salary()
BEGIN
  SELECT
    clean_title,
    year,
    CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2)) AS median_salary
  FROM (
    SELECT
      clean_title,
      salary_yearly,
      year,
      ROW_NUMBER() OVER (PARTITION BY clean_title, year ORDER BY salary_yearly) AS row_num,
      COUNT(*) OVER (PARTITION BY clean_title, year) AS total_rows
    FROM jobs_master
    WHERE salary_yearly IS NOT NULL
  ) AS temp_table
  WHERE row_num IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
  )
  GROUP BY clean_title, year
  ORDER BY clean_title, year;
END//
DELIMITER ;
-- ======================================================= --
CALL median_yearly_salary();
-- ====================================================== --














