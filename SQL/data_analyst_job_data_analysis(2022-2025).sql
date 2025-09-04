-- All Data Analyst CTE --
-- =============================================== --
-- Year: 2022 --
-- ============================================== --
-- CTE: 2022 Median Salary --
-- Data Analyst Positions --
-- ================================================================ --
WITH ordered_median AS (
  SELECT
	year,
    clean_title,
    salary_yearly,
    ROW_NUMBER() OVER (PARTITION BY clean_title ORDER BY salary_yearly) AS row_num,
    COUNT(*) OVER (PARTITION BY clean_title) AS total_rows
  FROM `2022_job_data`
  WHERE salary_yearly IS NOT NULL
  AND clean_title = 'Data Analyst'
)
SELECT
	year,
	clean_title,
	ROUND(AVG(salary_yearly), 2) AS median_salary
FROM ordered_median
WHERE row_num IN (FLOOR((total_rows + 1) / 2),
					CEIL((total_rows + 1) / 2))
GROUP BY year, clean_title;
-- ================================================================================== ==
-- COMPARISON: 2022 yearly salary vs median salary --
-- Data Analyst Positions --

SELECT
	job.year,
  job.clean_title,
  job.job_id,
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
AND job.clean_title = 'Data Analyst';

-- ====================================================================================== --
-- SKILLS vs SALARY 2022--
-- Data Analyst --
-- ====================================================================================== --
-- CTE: 2022 Top 20 In-Demand Skill with Percentile Ranking and Salary Distribution --
-- Data Analyst Positions --
-- NOTE: No median salary data is being used --

WITH skill_stats_pct_rank AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2022_job_data jd ON jm.job_id = jd.job_id
  WHERE jd.year = 2022
  AND jd.clean_title = 'Data Analyst' 
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
year,
clean_title,
skill_id,
skill_name
FROM skill_stats_pct_rank
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC
LIMIT 20;


-- =============================================================== --
-- CTE: 2022 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Top Skill Count for Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
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
  WHERE jd.year = 2022
	AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE	min_salary IS NOT NULL
 AND	avg_salary IS NOT NULL
  AND	max_salary IS NOT NULL
ORDER BY skill_count DESC;

-- =============================================================== --
-- CTE: 2022 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Top Percentage Rank for Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2022_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2022
   AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
  ORDER BY pct_rank 
)
SELECT *
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY pct_rank DESC;
-- ======================================================== --
-- CTE: 2022 SKILL STATS MEAN MEDIAN SPREAD --
-- Data Analyst Positions --

WITH skill_stats_mean_median_spread AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly) - ANY_VALUE(v.median_salary), 2) AS mean_median_spread
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2022_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2022
   AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_mean_median_spread
WHERE avg_salary IS NOT NULL
ORDER BY skill_count DESC;
-- =========================================================== --
-- CTE: 2022 SKILL STATS PERCENTILE RANK and CUMULATIVE DISTRIBUTION
-- Data Analyst Positions --

WITH skill_stats_pct_cume_dist AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) AS pct_rank_num,
    CUME_DIST() OVER (ORDER BY AVG(jm.salary_yearly)) AS cume_dist_num
  FROM skill_link sl
    JOIN skills_dim sd ON sl.skill_id = sd.skill_id
    JOIN jobs_master jm ON jm.job_id = sl.job_id
    JOIN 2022_job_data jd ON jd.job_id = jm.job_id
    LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2022
   AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	year,
    clean_title,
    skill_id,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
WHERE avg_salary IS NOT NULL
ORDER BY cume_dist_num DESC;

-- ========================================================================= --
-- Year: 2023 --
-- ========================================================================= --
-- COMPARISON: 2023 Yearly Salary VS Median Salary for Data Analyst Positions --

SELECT
	job.year,
	job.date AS 'Job Posted Date',
	job.clean_title,
    job.job_id,
    job.company_name,
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
	AND job.clean_title = 'Data Analyst';

-- ========================================================== --
-- CTE: 2023 Top 20 In-Demand Skills with Percentile Ranking and Salary Distribution --
-- Data Analyst Positions --

WITH skill_stats_pct_rank AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(sd.skill_name) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly) DESC) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2023_job_data jd ON jm.job_id = jd.job_id
  WHERE jd.year = 2023
   AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_pct_rank
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY skill_count DESC;


-- ===================================================================== --
-- CTE: 2023 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER 
			(ORDER BY AVG(jm.salary_yearly) DESC) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2023_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2023
    AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY skill_count DESC;
-- =============================================================== --
-- CTE: 2023 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2023_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2023
     AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
  ORDER BY pct_rank
)
SELECT *
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY pct_rank DESC;
-- ======================================================== --
-- CTE: 2023 MEAN MEDIAN SPREAD by SKILL --
-- Data Analyst Position --

WITH skill_stats_mean_median_spread AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
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
  WHERE jd.year = 2023
       AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_mean_median_spread
WHERE avg_salary IS NOT NULL
ORDER BY skill_count DESC;

-- =========================================================== --
-- CTE: 2023 SKILL STATS PERCENTILE RANK and CUMULATIVE DISTRIBUTION --
-- Data Analyst Positions --

WITH skill_stats_pct_cume_dist AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) AS pct_rank_num,
    CUME_DIST() OVER (ORDER BY AVG(jm.salary_yearly)) AS cume_dist_num
  FROM skill_link sl
    JOIN skills_dim sd ON sl.skill_id = sd.skill_id
    JOIN jobs_master jm ON jm.job_id = sl.job_id
    JOIN 2023_job_data jd ON jd.job_id = jm.job_id
    LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2023
       AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	year,
    clean_title,
    skill_id,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
WHERE	avg_salary IS NOT NULL
ORDER BY cume_dist_num DESC;
-- =============================================================== --
-- YEAR: 2024 --
-- ========================================================================= --
-- COMPARISON: 2024 Yearly Salary VS Median Salary for Data Analyst Positions --

SELECT
	job.date AS 'Job Posted Date',
	job.clean_title,
    job.job_id,
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
	AND job.clean_title = 'Data Analyst';

-- ========================================================== --
-- CTE: 2024 Top 20 In-Demand Skills with Percentile Ranking and Salary Distribution --
-- Data Analyst Positions --

WITH skill_stats_pct_rank AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly) DESC) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2024_job_data jd ON jm.job_id = jd.job_id
  WHERE jd.year = 2024
   AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_pct_rank
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY skill_count DESC
LIMIT 20;

-- ===================================================================== --
-- CTE: 2024 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER 
			(ORDER BY AVG(jm.salary_yearly) DESC) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2024_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2024
    AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY skill_count DESC;
-- =============================================================== --
-- CTE: 2024 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2024_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2024
     AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
  ORDER BY pct_rank
)
SELECT *
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY pct_rank DESC;
-- ======================================================== --
-- CTE: 2024 MEAN MEDIAN SPREAD by SKILL --
-- Data Analyst Position --

WITH skill_stats_mean_median_spread AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly) - ANY_VALUE(v.median_salary), 2) AS mean_median_spread
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2024_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2024
       AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_mean_median_spread
WHERE avg_salary IS NOT NULL
ORDER BY skill_count DESC;

-- =========================================================== --
-- CTE: 2024 SKILL STATS PERCENTILE RANK and CUMULATIVE DISTRIBUTION --
-- Data Analyst Positions --

WITH skill_stats_pct_cume_dist AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) AS pct_rank_num,
    CUME_DIST() OVER (ORDER BY AVG(jm.salary_yearly)) AS cume_dist_num
  FROM skill_link sl
    JOIN skills_dim sd ON sl.skill_id = sd.skill_id
    JOIN jobs_master jm ON jm.job_id = sl.job_id
    JOIN 2024_job_data jd ON jd.job_id = jm.job_id
    LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2024
       AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	year,
    clean_title,
    skill_id,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
WHERE avg_salary IS NOT NULL
ORDER BY cume_dist_num DESC;

-- ======================================================================== --
-- Year: 2025 --
-- ========================================================================= --
-- COMPARISON: 2025 Yearly Salary VS Median Salary for Data Analyst Positions --

SELECT
	job.date AS 'Job Posted Date',
	job.clean_title,
    job.job_id,
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
	AND job.clean_title = 'Data Analyst';

-- ========================================================== --
-- CTE: 2025 Top 20 In-Demand Skills with Percentile Ranking and Salary Distribution --
-- Data Analyst Positions --

WITH skill_stats_pct_rank AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly) DESC) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2025_job_data jd ON jm.job_id = jd.job_id
  WHERE jd.year = 2025
   AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_pct_rank
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY skill_count DESC
LIMIT 20;

-- ===================================================================== --
-- CTE: 2025 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    -- Pulling values from median salary view
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER 
			(ORDER BY AVG(jm.salary_yearly) DESC) * 100, 0),'%') AS pct_rank -- Percentile a skill’s pay falls into. --
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON sl.job_id = jm.job_id
  JOIN 2025_job_data jd ON jm.job_id = jd.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2025
    AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY skill_count DESC;
-- =============================================================== --
-- CTE: 2025 SKILL STATS with MEDIAN SALARY and Percentile Ranking --
-- Data Analyst Positions --

WITH skill_stats_median_salary AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    MIN(jm.salary_yearly) AS min_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    MAX(jm.salary_yearly) AS max_salary,
    CONCAT(ROUND(PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) * 100, 0),'%') AS pct_rank
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2025_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2025
     AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
  ORDER BY pct_rank
)
SELECT *
FROM skill_stats_median_salary
WHERE avg_salary IS NOT NULL
 AND min_salary IS NOT NULL
  AND max_salary IS NOT NULL
ORDER BY pct_rank DESC;
-- ======================================================== --
-- CTE: 2025 MEAN MEDIAN SPREAD by SKILL --
-- Data Analyst Position --

WITH skill_stats_mean_median_spread AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_id,
    sd.skill_name,
    COUNT(*) AS skill_count,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly) - ANY_VALUE(v.median_salary), 2) AS mean_median_spread
  FROM skill_link sl
  JOIN skills_dim sd ON sl.skill_id = sd.skill_id
  JOIN jobs_master jm ON jm.job_id = sl.job_id
  JOIN 2025_job_data jd ON jd.job_id = jm.job_id
  LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2025
       AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	*
FROM skill_stats_mean_median_spread
WHERE avg_salary IS NOT NULL
ORDER BY skill_count DESC;

-- =========================================================== --
-- CTE: 2025 SKILL STATS PERCENTILE RANK and CUMULATIVE DISTRIBUTION --
-- Data Analyst Positions --

WITH skill_stats_pct_cume_dist AS (
  SELECT
	jd.year,
    jd.clean_title,
    sd.skill_name,
    sd.skill_id,
    COUNT(*) AS skill_count,
    ANY_VALUE(v.median_salary) AS median_salary,
    ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
    PERCENT_RANK() OVER (ORDER BY AVG(jm.salary_yearly)) AS pct_rank_num,
    CUME_DIST() OVER (ORDER BY AVG(jm.salary_yearly)) AS cume_dist_num
  FROM skill_link sl
    JOIN skills_dim sd ON sl.skill_id = sd.skill_id
    JOIN jobs_master jm ON jm.job_id = sl.job_id
    JOIN 2025_job_data jd ON jd.job_id = jm.job_id
    LEFT JOIN median_salary_view v ON v.clean_title = jd.clean_title
  WHERE jd.year = 2025
       AND jd.clean_title = 'Data Analyst'
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	year,
    clean_title,
    skill_id,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
ORDER BY cume_dist_num DESC;

-- ======================================================== ==
-- 2022: Post Counts for Data Analyst job posts including Salaries by Websites & Company --
-- (What It Shows: How often does a company use a website to post Data Analyst positions. 
-- What's the salary range and average for those posts.) --
SELECT
 year,
 website,
 company_name,
 clean_title,
  COUNT(*) AS total_posts,
  MIN(salary_yearly) AS min_salary,
  ROUND(AVG(salary_yearly), 2) AS avg_salary,
  MAX(salary_yearly) AS max_salary
FROM jobs_master 
WHERE
 year = 2022
 AND salary_yearly IS NOT NULL
   AND clean_title = 'Data Analyst'
GROUP BY
 website,
 company_name,
 clean_title
ORDER BY
  total_posts DESC;
  -- ======================================================== ==
-- 2023: Post Counts and Data Anlyst Salaries by Website & Company --
-- (What It Shows: How often does a company use a website to post Data Analyst positions. 
-- What's the salary range and average for those posts.) --
SELECT
 year,
 website,
 company_name,
 clean_title,
  COUNT(*) AS total_posts,
  MIN(jm.salary_yearly) AS min_salary,
  ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
  MAX(jm.salary_yearly) AS max_salary
FROM jobs_master jm
WHERE
 year = 2023
 AND salary_yearly IS NOT NULL
  AND salary_standardized IS NOT NULL
   AND clean_title = 'Data Analyst'
GROUP BY
 website,
 company_name,
 clean_title
ORDER BY
  total_posts DESC;
  -- ======================================================== ==
-- 2024: Post Counts and Data Anlyst Salaries by Website & Company --

SELECT
 year,
 website,
 company_name,
 clean_title,
  COUNT(*) AS total_posts,
  MIN(jm.salary_yearly) AS min_salary,
  ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
  MAX(jm.salary_yearly) AS max_salary
FROM jobs_master jm
WHERE
 year = 2024
 AND salary_yearly IS NOT NULL
  AND salary_standardized IS NOT NULL
   AND clean_title = 'Data Analyst'
GROUP BY
 website,
 company_name,
 clean_title
ORDER BY
  total_posts DESC;
  -- ======================================================== ==
-- 2025: Post Counts and Data Anlyst Salaries by Website & Company --

SELECT
 year,
 website,
 company_name,
 clean_title,
  COUNT(*) AS total_posts,
  MIN(jm.salary_yearly) AS min_salary,
  ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
  MAX(jm.salary_yearly) AS max_salary
FROM jobs_master jm
WHERE
 year = 2025
 AND salary_yearly IS NOT NULL
  AND salary_standardized IS NOT NULL
   AND clean_title = 'Data Analyst'
GROUP BY
 website,
 company_name,
 clean_title
ORDER BY
  total_posts DESC;
-- ================================================================================= --
-- 2024 Studying salary trends for Data Anaylst --
-- Track Salary Differences Over Time --
-- (What This Does: Returns monthly average salary per company and website for Data Analyst.
-- Calculates percentage change month-over-month to see if pay is rising or falling.)
  
WITH company_monthly AS (
  SELECT
    year,
	website,
	company_name,
	clean_title,
	DATE_FORMAT(date, '%Y-%m') AS month_year,	
    AVG(salary_yearly) AS avg_salary
  FROM jobs_master 
  WHERE
   year = 2022
    AND clean_title = 'Data Analyst'
    AND salary_yearly IS NOT NULL
	
  GROUP BY
   website,
   company_name,
   clean_title,
   month_year
),
trends AS (
  SELECT
    year,
    website,
    company_name,
    clean_title,
    month_year,
    avg_salary,
    ROUND(LAG(avg_salary) OVER (PARTITION BY website, company_name, clean_title ORDER BY month_year),2) AS prev_avg_salary
  FROM company_monthly
)
SELECT
  year,
  website,
  company_name,
  clean_title,
  month_year,
  ROUND(avg_salary, 2) AS current_salary,
  prev_avg_salary,
  ROUND((avg_salary - prev_avg_salary) / prev_avg_salary * 100, 2) AS pct_change
FROM trends
WHERE prev_avg_salary IS NOT NULL
ORDER BY website, company_name, month_year;
-- ================================================================================= --
-- 2023 Studying salary trends for Data Anaylst --
-- Track Salary Differences Over Time --
  
  WITH company_monthly AS (
  SELECT
   year,
   website,
   company_name,
   clean_title,
    DATE_FORMAT(date, '%Y-%m') AS month_year,
    AVG(salary_yearly) AS avg_salary
  FROM jobs_master 
  WHERE
   year = 2023
    AND clean_title = 'Data Analyst'
    AND salary_yearly IS NOT NULL
	
  GROUP BY
   website,
   company_name,
   clean_title,
   month_year
),
trends AS (
  SELECT
    year,
    website,
    company_name,
    clean_title,
    month_year,
    avg_salary,
    ROUND(LAG(avg_salary) OVER (PARTITION BY website, company_name, clean_title ORDER BY month_year),2) AS prev_avg_salary
  FROM company_monthly
)
SELECT
  year,
  website,
  company_name,
  clean_title,
  month_year,
  ROUND(avg_salary, 2) AS current_salary,
  prev_avg_salary,
  ROUND((avg_salary - prev_avg_salary) / prev_avg_salary * 100, 2) AS pct_change
FROM trends
WHERE prev_avg_salary IS NOT NULL
ORDER BY website, company_name, month_year;
-- ================================================================================= --
-- 2024 Studying salary trends for Data Anaylst --
-- Track Salary Differences Over Time --

  WITH company_monthly AS (
  SELECT
   year,
   website,
   company_name,
   clean_title,
    DATE_FORMAT(date, '%Y-%m') AS month_year,
    AVG(salary_yearly) AS avg_salary
  FROM jobs_master 
  WHERE
   year = 2024
    AND clean_title = 'Data Analyst'
    AND salary_yearly IS NOT NULL
	
  GROUP BY
   website,
   company_name,
   clean_title,
   month_year
),
trends AS (
  SELECT
	year,
    website,
    company_name,
    clean_title,
    month_year,
    avg_salary,
    LAG(avg_salary) OVER (PARTITION BY website, company_name, clean_title ORDER BY month_year) AS prev_avg_salary
  FROM company_monthly
)
SELECT
  year,
  website,
  company_name,
  clean_title,
  month_year,
  avg_salary AS current_salary,
  prev_avg_salary,
 ROUND((avg_salary - prev_avg_salary) / prev_avg_salary * 100, 2) AS pct_change
FROM trends
WHERE prev_avg_salary IS NOT NULL
ORDER BY website, company_name, month_year;
-- ================================================================================= --
-- 2025: Studying salary trends for Data Anaylst --
-- Track Salary Differences Over Time --

  WITH company_monthly AS (
  SELECT
   year,
   website,
   company_name,
   clean_title,
    DATE_FORMAT(date, '%Y-%m') AS month_year,
    AVG(salary_yearly) AS avg_salary
  FROM jobs_master 
  WHERE
   year = 2025
    AND clean_title = 'Data Analyst'
    AND salary_yearly IS NOT NULL
	
  GROUP BY
   website,
   company_name,
   clean_title,
   month_year
),
trends AS (
  SELECT
    year,
    website,
    company_name,
    clean_title,
    month_year,
    avg_salary,
    ROUND(LAG(avg_salary) OVER (PARTITION BY website, company_name, clean_title ORDER BY month_year),2) AS prev_avg_salary
  FROM company_monthly
)
SELECT
  year,
  website,
  company_name,
  clean_title,
  month_year,
  ROUND(avg_salary, 2) AS current_salary,
  prev_avg_salary,
  ROUND((avg_salary - prev_avg_salary) / prev_avg_salary * 100, 2) AS pct_change
FROM trends
WHERE prev_avg_salary IS NOT NULL
ORDER BY website, company_name, month_year;
-- ================================================================================= --
-- MONTHLY SALARY TRENDS BY WEBSITES --
SELECT *
FROM website_yearly_salary_trend
WHERE clean_title = 'Data Analyst'
  AND year BETWEEN 2022 AND 2023
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;

-- MONTHLYSALARY TRENDS BY COMPANY NAMES --
SELECT *
FROM yearly_salary_trend
WHERE clean_title = 'Data Analyst'
  AND year BETWEEN 2022 AND 2025
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;





