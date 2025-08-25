WITH skill_stats_mean_median_spread AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly) - ANY_VALUE(v.median_salary), 2) AS mean_median_spread
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2023_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.`year` = 2023
   AND jd.clean_title LIKE '%Analyst%'
    AND jd.clean_title != 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_mean_median_spread
WHERE avg_salary IS NOT NULL
ORDER BY skill_count DESC;