CREATE OR REPLACE VIEW vw_skill_stats_median_salary_2022 AS
WITH skill_stats_median_salary AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2022_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.`year` = 2022
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC;

SELECT	*
FROM	vw_skill_stats_median_salary_2022;

CREATE OR REPLACE VIEW vw_skill_stats_median_salary_2023 AS
WITH skill_stats_median_salary AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2023_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.`year` = 2023
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC;

SELECT	*
FROM	vw_skill_stats_median_salary_2023;

CREATE OR REPLACE VIEW vw_skill_stats_median_salary_2024 AS
WITH skill_stats_median_salary AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2024_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.`year` = 2024
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC;

SELECT	*
FROM	vw_skill_stats_median_salary_2024;

CREATE OR REPLACE VIEW vw_skill_stats_median_salary_2025 AS
WITH skill_stats_median_salary AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2025_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.`year` = 2025
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC;

SELECT	*
FROM	vw_skill_stats_median_salary_2025;