WITH skill_stats_pct_rank AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2023_job_data jd ON jm.job_id = jd.job_id
  WHERE jd.`year` = 2023
  AND jd.clean_title LIKE '%Analyst%'
   AND jd.clean_title != 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
*
FROM skill_stats_pct_rank
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC;