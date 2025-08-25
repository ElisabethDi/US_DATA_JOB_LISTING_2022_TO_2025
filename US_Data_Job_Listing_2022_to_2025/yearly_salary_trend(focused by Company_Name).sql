-- sb: Stands for salary base --
-- View calculates the monthly salary trends posted on website by companies searching to fill data positions

CREATE OR REPLACE VIEW yearly_salary_trend AS
SELECT
  sb.year,
  sb.clean_title,
  sb.website,
  sb.company_name,
  sb.month_year,
  sb.avg_salary,
  LAG(sb.avg_salary) OVER (PARTITION BY sb.clean_title, sb.website, sb.company_name
							ORDER BY sb.month_year) AS prev_avg_salary,
  ROUND((sb.avg_salary - LAG(sb.avg_salary) OVER (PARTITION BY sb.clean_title, sb.website, sb.company_name
											ORDER BY sb.month_year))/ LAG(sb.avg_salary) 
                                            OVER (PARTITION BY sb.clean_title, sb.website, sb.company_name
											ORDER BY sb.month_year) * 100, 2) AS pct_change
FROM (
  SELECT
    YEAR(`date`) AS year,
    clean_title,
    website,
    company_name,
    DATE_FORMAT(`date`, '%Y-%m') AS month_year,
    ROUND(AVG(salary_yearly), 2) AS avg_salary
  FROM jobs_master
  WHERE salary_yearly IS NOT NULL
  GROUP BY YEAR(`date`), clean_title, website, company_name, month_year
) AS sb;

SELECT *
FROM yearly_salary_trend
WHERE clean_title LIKE '%Analyst%'
 AND clean_title != 'Data Analyst'
  AND year BETWEEN 2022 AND 2025
  AND prev_avg_salary IS NOT NULL
ORDER BY website, company_name, month_year;
