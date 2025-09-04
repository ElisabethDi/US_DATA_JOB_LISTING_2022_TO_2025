-- sb: Stands for salary base --
-- View calculates the monthly salary trends posted on website searching to fill data positions

CREATE OR REPLACE VIEW website_yearly_salary_trend AS
SELECT
  sb.year,
  sb.clean_title,
  sb.website,
  sb.month_year,
  sb.avg_salary,
  LAG(sb.avg_salary) 
    OVER (
      PARTITION BY sb.clean_title, sb.website
      ORDER BY sb.month_year
    ) AS prev_avg_salary,
  ROUND(
    (sb.avg_salary - LAG(sb.avg_salary) 
       OVER (
         PARTITION BY sb.clean_title, sb.website
         ORDER BY sb.month_year
       ))
    / LAG(sb.avg_salary) 
        OVER (
          PARTITION BY sb.clean_title, sb.website
          ORDER BY sb.month_year
        ) * 100,
    2
  ) AS pct_change
FROM (
  SELECT
    YEAR(`date`) AS year,
    clean_title,
    website,
    DATE_FORMAT(`date`, '%Y-%m') AS month_year,
    ROUND(AVG(salary_yearly), 2) AS avg_salary
  FROM jobs_master
  WHERE salary_yearly IS NOT NULL
  GROUP BY YEAR(`date`), clean_title, website, month_year
) AS sb;

SELECT *
FROM website_yearly_salary_trend
WHERE clean_title = 'Data Engineer'
  AND year BETWEEN 2022 AND 2025
  AND prev_avg_salary IS NOT NULL
ORDER BY website, month_year;