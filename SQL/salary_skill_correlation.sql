
--  CORRELATION ANALYSIS BETWEEN SKILLS AND SALARY --
-- jobs_master Table (2022 - 2025)--

SELECT
  sd.skill_name,
  jm.year,
  COUNT(*) AS skill_count,
  ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
  ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
  ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON jm.job_id = sl.job_id
GROUP BY sd.skill_name, jm.year
ORDER BY skill_count DESC;

-- ======================================================== --
-- 20 Highest Paying Salaries per Skill (2023) --


SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2022_job_data jd ON jm.job_id = jd.job_id
WHERE jd.year = 2022
GROUP BY sd.skill_name
ORDER BY avg_salary DESC
LIMIT 20;
-- ========================================================= --
-- Top 20 most In-Demand Skills with Salary (2022) --

SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2022_job_data jd ON jm.job_id = jd.job_id
WHERE jd.year = 2022
GROUP BY sd.skill_name
ORDER BY skill_count DESC
LIMIT 20;

-- ======================================================== --
-- 20 Highest Paying Salaries per Skill (2023) --
SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2023_job_data jd ON jm.job_id = jd.job_id
WHERE jd.year = 2023
GROUP BY sd.skill_name
ORDER BY avg_salary DESC
LIMIT 20;
-- ========================================================= --
-- Top 20 most In-Demand Skills with Salary (2023) --
SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
	LEFT JOIN 2023_job_data jd	ON jm.job_id = jd.job_id
WHERE jd.year = 2023
GROUP BY sd.skill_name
ORDER BY skill_count DESC
LIMIT 20;

-- ======================================================== --
-- 20 Highest Paying Salaries per Skill (2024) --
SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2024_job_data jd	ON jm.job_id = jd.job_id
WHERE jd.year = 2024
GROUP BY sd.skill_name
ORDER BY avg_salary DESC
LIMIT 20;
-- ========================================================= --
-- Top 20 most In-Demand Skills with Salary (2024) --
SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2024_job_data jd	ON jm.job_id = jd.job_id
WHERE jd.year = 2024
GROUP BY sd.skill_name
ORDER BY skill_count DESC
LIMIT 20;

-- ======================================================== --
-- 20 Highest Paying Salaries per Skill (2025) --
SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2025_job_data jd	ON jm.job_id = jd.job_id
WHERE jd.year = 2025
GROUP BY sd.skill_name
ORDER BY avg_salary DESC
LIMIT 20;
-- ========================================================= --
-- Top 20 most In-Demand Skills with Salary for Year 2025 --
SELECT
	jd.year,
	sd.skill_name, 
	COUNT(*) AS skill_count,
	ROUND(AVG(jm.salary_yearly), 2) AS avg_salary,
	ROUND(MIN(jm.salary_yearly), 2) AS min_salary,
	ROUND(MAX(jm.salary_yearly), 2) AS max_salary
FROM skill_link sl
JOIN skills_dim sd ON sl.skill_id = sd.skill_id
JOIN jobs_master jm ON sl.job_id = jm.job_id
LEFT JOIN 2025_job_data jd	ON jm.job_id = jd.job_id
WHERE jd.year = 2025
GROUP BY sd.skill_name
ORDER BY skill_count DESC
LIMIT 20;
-- ======================================================= --
-- DEBUGGING -- Output returns the month(of the job.date) 
-- as oppose job.date = output date data (full date format)
-- ====================================================== --
SELECT Month(job.date), job.salary_yearly, m.median_salary
FROM `2022_job_data` AS job
LEFT JOIN `median_salary_view` AS m
  ON job.clean_title = m.clean_title
     AND m.month_year = DATE_FORMAT(job.`date`, '%Y-%m')
LIMIT 20;
-- =============================================================== --
-- Testing JOIN Operation with median_salary_view --
SELECT	jd.clean_title, v.year, v.median_salary
FROM	median_salary_view v
JOIN	2022_job_data jd
	ON	v.clean_title = jd.clean_title
WHERE	v.year = 2022;

-- ======================================================= --
-- DEBUGGING -- Filtering for analyst title --
-- ==============================================================
SELECT DISTINCT clean_title
FROM 2024_job_data
WHERE clean_title LIKE '%Analyst%'
LIMIT 20;
-- ========================================== --
-- How many rows match that filter -- 14209 count-
SELECT COUNT(*) AS analyst_count
FROM 2024_job_data
WHERE year = 2024
  AND clean_title LIKE '%Analyst%';
-- =========================================== --
-- Confirm the join works with those filtered titles --
SELECT DISTINCT sd.skill_name
FROM skill_link sl
JOIN skills_dim sd ON sd.skill_id = sl.skill_id
JOIN jobs_master jm ON jm.job_id = sl.job_id
JOIN 2024_job_data jd ON jd.job_id = jm.job_id
WHERE jd.year = 2024
  AND jd.clean_title LIKE '%Analyst%'
LIMIT 10;
-- =================================== --






