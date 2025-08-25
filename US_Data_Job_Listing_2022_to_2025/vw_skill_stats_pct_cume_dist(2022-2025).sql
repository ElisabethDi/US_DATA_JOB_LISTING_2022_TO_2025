CREATE OR REPLACE VIEW vw_skill_stats_pct_cume_dist_2022 AS
WITH skill_stats_pct_cume_dist AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
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
  WHERE jd.`year` = 2022
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	job_year,
    clean_title,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
ORDER BY cume_dist_num DESC;

SELECT	*
FROM	vw_skill_stats_pct_cume_dist_2022
WHERE	clean_title = 'Data Analyst';

CREATE OR REPLACE VIEW vw_skill_stats_pct_cume_dist_2023 AS
WITH skill_stats_pct_cume_dist AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
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
  WHERE jd.`year` = 2023
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	job_year,
    clean_title,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
ORDER BY cume_dist_num DESC;

SELECT	*
FROM	vw_skill_stats_pct_cume_dist_2024
WHERE	clean_title = 'Data Analyst'
 AND avg_salary IS NOT NULL;

CREATE OR REPLACE VIEW vw_skill_stats_pct_cume_dist_2024 AS
WITH skill_stats_pct_cume_dist AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
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
  WHERE jd.`year` = 2024
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	job_year,
    clean_title,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
ORDER BY cume_dist_num DESC;

SELECT	*
FROM	vw_skill_stats_pct_cume_dist_2024;

CREATE OR REPLACE VIEW vw_skill_stats_pct_cume_dist_2025 AS
WITH skill_stats_pct_cume_dist AS(
  SELECT
	jd.`year`AS job_year,
    jd.clean_title,
    sd.skill_name,
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
  WHERE jd.`year` = 2025
    AND (
      jd.clean_title IN ('Data Analyst', 'Data Engineer', 'Data Scientist')
      OR jd.clean_title LIKE '%Analyst%'
    )
  GROUP BY sd.skill_name, jd.clean_title
)
SELECT
	job_year,
    clean_title,
	skill_name,
	skill_count,
	median_salary,
	avg_salary,
  CONCAT(ROUND(pct_rank_num * 100, 0), '%') AS pct_rank,
  CONCAT(ROUND(cume_dist_num  * 100, 0), '%') AS cumulative_dist
FROM skill_stats_pct_cume_dist
ORDER BY cume_dist_num DESC;

SELECT	*
FROM	vw_skill_stats_pct_cume_dist_2025;