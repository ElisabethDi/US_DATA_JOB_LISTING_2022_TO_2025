-- Create function median_salary_every_month_fn --

DROP FUNCTION IF EXISTS median_salary_every_month_fn;

DELIMITER //
CREATE FUNCTION median_salary_every_month_fn(p_month VARCHAR(7))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE med DECIMAL(12,2);
  SELECT CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2))
    INTO med
  FROM jobs_master
  WHERE DATE_FORMAT(date,'%Y-%m') = p_month
    AND salary_yearly IS NOT NULL;
  RETURN med;
END//
DELIMITER ;
-- Query  the meta data --
SELECT ROUTINE_NAME, DATA_TYPE, DTD_IDENTIFIER
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = DATABASE()
  AND ROUTINE_NAME = 'median_salary_every_month_fn';
-- ============================================================================================== --
-- Create function median_salary_monthly_fn --

DROP FUNCTION IF EXISTS median_salary_monthly_fn;

DELIMITER //
CREATE FUNCTION median_salary_monthly_fn(p_month VARCHAR(7))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE med DECIMAL(12,2);
  SELECT CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2))
    INTO med
  FROM jobs_master
  WHERE DATE_FORMAT(date,'%Y-%m') = p_month
    AND salary_yearly IS NOT NULL;
  RETURN med;
END//
DELIMITER ;

-- Query  the meta data --
SELECT ROUTINE_NAME, DATA_TYPE, DTD_IDENTIFIER
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = DATABASE()
  AND ROUTINE_NAME = 'median_salary_monthly_fn';
-- ==================================================================================== --
-- -- Create function median_yearly_salary_fn --
DROP FUNCTION IF EXISTS median_yearly_salary_fn;

DELIMITER //
CREATE FUNCTION median_yearly_salary_fn(p_month VARCHAR(7))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE med DECIMAL(12,2);
  SELECT CAST(ROUND(AVG(salary_yearly), 2) AS DECIMAL(12,2))
    INTO med
  FROM jobs_master
  WHERE DATE_FORMAT(date,'%Y-%m') = p_month
    AND salary_yearly IS NOT NULL;
  RETURN med;
END//
DELIMITER ;
-- Query  the meta data --
SELECT ROUTINE_NAME, DATA_TYPE, DTD_IDENTIFIER
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = DATABASE()
  AND ROUTINE_NAME = 'median_yearly_salary_fn';
-- ================================================================= --