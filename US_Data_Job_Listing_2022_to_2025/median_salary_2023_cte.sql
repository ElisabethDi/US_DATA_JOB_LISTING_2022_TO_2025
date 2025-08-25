WITH ordered_median AS(
  SELECT `year`AS job_year, clean_title AS title, salary_yearly,
    ROW_NUMBER() OVER (PARTITION BY clean_title ORDER BY salary_yearly) AS row_num,
    COUNT(*) OVER (PARTITION BY clean_title) AS total_rows
  FROM `2023_job_data`
  WHERE salary_yearly IS NOT NULL
  AND clean_title LIKE '%Analyst%'
   AND clean_title != 'Data Analyst'
)
SELECT	job_year, title,
		ROUND(AVG(salary_yearly), 2) AS median_salary
FROM ordered_median
WHERE row_num IN (FLOOR((total_rows + 1) / 2),
				  CEIL((total_rows + 1) / 2))
GROUP BY job_year, title;