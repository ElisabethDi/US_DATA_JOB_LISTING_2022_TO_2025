SELECT	job.`year`AS job_year, job.clean_title, job.salary_yearly, m.median_salary,
  CASE
    WHEN job.salary_yearly > m.median_salary THEN 'Above Median'
    WHEN job.salary_yearly < m.median_salary THEN 'Below Median'
    ELSE 'At Median'
  END AS Comparison
FROM `2023_job_data` AS job
	LEFT JOIN `median_salary_view` AS m ON job.clean_title = m.clean_title
     AND m.month_year = DATE_FORMAT(job.`date`, '%Y-%m')
WHERE job.salary_yearly IS NOT NULL
AND job.clean_title LIKE '%Analyst%'
 AND job.clean_title != 'Data Analyst';