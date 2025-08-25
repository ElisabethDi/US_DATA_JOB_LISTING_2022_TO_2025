DELIMITER $$

CREATE PROCEDURE median_salary_per_month()
BEGIN
  SELECT
    clean_title,
    month_year AS `month`,
    CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2)) AS median_salary
  FROM (
    SELECT
      clean_title,
      salary_yearly,
      DATE_FORMAT(`date`, '%Y-%m') AS month_year,
      ROW_NUMBER() OVER (
        PARTITION BY clean_title, DATE_FORMAT(`date`, '%Y-%m')
        ORDER BY salary_yearly
      ) AS row_num,
      COUNT(*) OVER (
        PARTITION BY clean_title, DATE_FORMAT(`date`, '%Y-%m')
      ) AS total_rows
    FROM jobs_master
    WHERE salary_yearly IS NOT NULL
  ) AS temp
  WHERE row_num IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
  )
  GROUP BY clean_title, month_year
  ORDER BY clean_title, month_year;
END $$

DELIMITER ;

CALL median_salary_per_month;


