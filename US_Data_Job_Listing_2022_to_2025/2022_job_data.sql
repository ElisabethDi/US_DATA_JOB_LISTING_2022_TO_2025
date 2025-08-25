-- Create Table Schema  for 2022_job_table

DROP TABLE IF EXISTS `2022_job_data`;

CREATE TABLE `2022_job_data` (
  `job_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `index` INT ,
  `date` DATE ,
  `year` YEAR ,
  `month` INT ,
  `company_name` TEXT,
  `clean_title` TEXT,
  `seniority_level` TEXT,
  `location` TEXT,
  `employment_type` TEXT,
  `remote_work` BOOLEAN,
  `job_skills` TEXT,
  `skills_json` JSON,
  `salary_hourly` DOUBLE,
  `salary_yearly` DOUBLE,
  `salary_standardized` DOUBLE,
  `website` TEXT,
  PRIMARY KEY (`job_id`), 
  FOREIGN KEY (job_id) REFERENCES jobs_master(job_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserting 2022 data to table 2022_job_data --

INSERT INTO `2022_job_data`
  (`index`, `date`, `year`, `month`, `company_name`, `clean_title`,
   `seniority_level`, `location`, `employment_type`, `remote_work`,
   `job_skills`, `skills_json`,`salary_hourly`, `salary_yearly`, 
   `salary_standardized`, `website`)
SELECT
  `index`, `date`, `year`, `month`, `company_name`, `clean_title`,
  `seniority_level`, `location`, `employment_type`, `remote_work`,
  `job_skills`, `skills_json`,`salary_hourly`, `salary_yearly`, `salary_standardized`, 
  `website`
FROM `jobs_master`
WHERE `year` = 2022;

SELECT COUNT(*) FROM `2022_job_data`;
SELECT * FROM `2022_job_data` LIMIT 25;

-- checking the current structure
DESCRIBE `2022_job_data`;

-- Confirming table structure
SHOW CREATE TABLE `2022_job_data`;

ALTER TABLE `2022_job_data` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- =================================================================================== --
-- skills_json data isn’t uniform.
-- some rows are nested strings, others are raw text, others are proper arrays.
-- These are the steps taken to return array entries with correct skill_count in each array --
-- ======================================================================================= --
-- Diagnosing data variety of skills_json states
SELECT
  JSON_TYPE(skills_json) AS type,
  COUNT(*) AS cnt
FROM 2022_job_data
GROUP BY JSON_TYPE(skills_json);

SELECT job_id, skills_json
FROM 2024_job_data
WHERE JSON_TYPE(skills_json) = 'STRING'
LIMIT 10;
-- ==================================================================== --
-- Fix string datatype entries that represent nested quoted arrays --

UPDATE 2022_job_data
SET skills_json = CAST(
    JSON_UNQUOTE(JSON_EXTRACT(skills_json, '$[0]')) AS JSON
)
WHERE JSON_TYPE(skills_json) = 'STRING'
AND skills_json LIKE '"[%' 
AND JSON_VALID(JSON_UNQUOTE(JSON_EXTRACT(skills_json, '$[0]')));

UPDATE 2022_job_data
SET skills_json = CAST(
  REPLACE(
    REPLACE(
      REPLACE(skills_json, '''', '"'),    -- convert single quotes to double
      '", "', '","'                        -- tighten comma spacing
    ),
    '"[', '["'                            -- ensure proper prefix
  ) AS JSON
)
WHERE JSON_TYPE(skills_json) = 'STRING'
  AND skills_json LIKE "['%']";
-- ====================================================================== --
-- Handling any residual ARRAY data that still contain a single string

UPDATE 2022_job_data
SET skills_json = CAST(
    JSON_UNQUOTE(JSON_EXTRACT(skills_json, '$[0]')) AS JSON
)
WHERE JSON_TYPE(skills_json) = 'ARRAY'
  AND JSON_TYPE(JSON_EXTRACT(skills_json, '$[0]')) = 'STRING'
  AND JSON_VALID(JSON_UNQUOTE(JSON_EXTRACT(skills_json, '$[0]')));
  
 -- ============================================================= -- 
-- Verify the data --
SELECT
   JSON_TYPE(skills_json) AS type,
   JSON_LENGTH(skills_json) AS skill_count,
   COUNT(*) AS cnt
FROM 2022_job_data
GROUP BY JSON_TYPE(skills_json), skill_count
ORDER BY type, skill_count;
-- ================================================ --
SELECT
  job_id,
  skills_json,
  JSON_TYPE(skills_json) AS type,
  JSON_LENGTH(skills_json) AS skill_count
FROM 2022_job_data
LIMIT 5;

SELECT job_id, skills_json
FROM	2022_job_data
LIMIT	10;


















