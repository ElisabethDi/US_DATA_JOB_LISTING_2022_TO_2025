SHOW DATABASES;
USE US_Data_Job_Listing_2022_to_2025;
SHOW TABLES;

-- Create a Master Table Schema --

DROP TABLE IF EXISTS `jobs_master`;
CREATE TABLE jobs_master (
  `index` BIGINT NOT NULL,
  job_id BIGINT UNSIGNED NOT NULL,
  `date` DATE,
  `year` YEAR,
  `month` INT,
  company_name TEXT,
  clean_title TEXT,
  seniority_level TEXT,
  location TEXT,
  employment_type TEXT,
  remote_work BOOLEAN,
  job_skills TEXT,
  skills_json JSON,
  salary_hourly DOUBLE,
  salary_yearly DOUBLE,
  salary_standardized DOUBLE,
  website TEXT,
  PRIMARY KEY (job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Populate jobs_master Table

INSERT INTO jobs_master (
  `index`, job_id, `date`, `year`, `month`, company_name, clean_title,
  seniority_level, location, employment_type, remote_work, job_skills,
  skills_json, salary_hourly, salary_yearly, salary_standardized, website
)
SELECT
  `index`, job_id, `date`, `year`, `month`, company_name, 
  clean_title, seniority_level, location, employment_type, 
  remote_work, job_skills, skills_json, salary_hourly, 
  salary_yearly, salary_standardized, website
  
FROM clean_jobs;

DESCRIBE jobs_master;

-- Ensure all rows get matched --
SELECT COUNT(*) 
FROM jobs_master;

-- Verify data insertion --
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT job_id) AS unique_job_ids
FROM jobs_master;


SELECT * 
FROM `jobs_master`
WHERE	year = 2022
LIMIT 100;
-- ===================================================================== --
 -- Data Cleaning: Website --
UPDATE jobs_master
SET website = 'UK Jobs for Stevenage Fans'
WHERE website LIKE '%stevenage%';

UPDATE jobs_master
SET company_name = 'Edward Jones'
WHERE company_name LIKE '%EDWARD JONES%'
   OR company_name LIKE '%EDWARDJONES%';
   
UPDATE	jobs_master
SET		company_name = 'Trillium Health Resources'
WHERE	company_name LIKE '%TRILLIUM HEALTH RESOURCES%'
	OR	company_name LIKE '%TRILLIUMHEALTHRESOURCES%';
-- ===================================================================== --
-- Data Cleaning : skills_json skill names --
-- ===================================================================== --
-- Data Cleaning: Change skill name from go to golang
UPDATE jobs_master
SET skills_json = JSON_SET(
  skills_json,
  JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'go')),    -- finds the path
  'golang'
)
WHERE JSON_VALID(skills_json)
  AND JSON_SEARCH(skills_json, 'one', 'go') IS NOT NULL;
  
-- Data Cleaning: Change skill name from no-sql to nosql
UPDATE jobs_master
SET skills_json = JSON_SET(
  skills_json,
  JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'no-sql')),
  'nosql'
)
WHERE JSON_SEARCH(skills_json, 'one', 'no-sql') IS NOT NULL;

-- Data Cleaning: Change skill name from spreadsheet to google_sheets
UPDATE jobs_master
SET skills_json = JSON_SET(
  skills_json,
  JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'spreadsheet')),
  'google_sheets'
)
WHERE JSON_SEARCH(skills_json, 'one', 'spreadsheet') IS NOT NULL;

-- Data Cleaning: Change skill name from mongo to mongodb
UPDATE jobs_master
SET skills_json = JSON_SET(
  skills_json,
  JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'mongo')),
  'mongodb'
)
WHERE JSON_SEARCH(skills_json, 'one', 'mongo') IS NOT NULL;

-- Data Cleaning: Change skill name from node to Node.js --
UPDATE jobs_master
SET skills_json = JSON_SET(
  skills_json,
  JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'node')),
  'Node.js'
)
WHERE JSON_SEARCH(skills_json, 'one', 'node') IS NOT NULL;
-- ================================================================== --
-- Removing double entry for value "spreadsheet"
UPDATE jobs_master
SET skills_json = JSON_REMOVE(
  skills_json,
  JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'spreadsheet'))
)
WHERE JSON_SEARCH(skills_json, 'one', 'spreadsheet') IS NOT NULL;
-- =========================================================== --
-- Data Cleaning: Change skill name from c/c++ to c, c++
UPDATE jobs_master
SET skills_json = JSON_ARRAY_APPEND(
    JSON_REMOVE(skills_json, JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'c/c++'))),
    '$', 'c',
    '$', 'c++'
)
WHERE JSON_SEARCH(skills_json, 'one', 'c/c++') IS NOT NULL;

-- Data Cleaning: Change skill name from unix/linux to unix, linux --
UPDATE jobs_master
SET skills_json = JSON_ARRAY_APPEND(
    JSON_REMOVE(skills_json, JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'unix/linux'))),
    '$', 'unix',
    '$', 'linux'
)
WHERE JSON_SEARCH(skills_json, 'one', 'unix/linux') IS NOT NULL;

-- Data Cleaning: Change skill name from linux/unix to linux to unix --
UPDATE jobs_master
SET skills_json = JSON_ARRAY_APPEND(
    JSON_REMOVE(skills_json, JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'linux/unix'))),
    '$', 'linux',
    '$', 'unix'
)
WHERE JSON_SEARCH(skills_json, 'one', 'linux/unix') IS NOT NULL;

-- Data Cleaning: Change skill name from  javascript/typescript to javascript, typescript --

UPDATE jobs_master
SET skills_json = JSON_ARRAY_APPEND(
    JSON_REMOVE(skills_json, JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'javascript/typescript'))),
    '$', 'javascript', 
    '$', 'typescript'
)
WHERE JSON_SEARCH(skills_json, 'one', 'javascript/typescript') IS NOT NULL;

-- Data Cleaning: Change skill name from powerpoints to powerpoint

UPDATE jobs_master
SET skills_json = JSON_SET(
    skills_json,
    JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'powerpoints')),
    'powerpoint'
)
WHERE JSON_SEARCH(skills_json, 'one', 'powerpoints') IS NOT NULL;

-- Data Cleaning: Change skill name from visual_basic to  vb.net --

UPDATE jobs_master
SET skills_json = JSON_SET(
    skills_json,
    JSON_UNQUOTE(JSON_SEARCH(skills_json, 'one', 'visual_basic')),
    'vb.net'
)
WHERE JSON_SEARCH(skills_json, 'one', 'visual_basic') IS NOT NULL;
-- ====================================================================--
-- Converting skills_json to json array
-- code_ removes the quotes around the stored JSON value
-- inspection query to diagnose the current format--
SELECT
  job_id,
  skills_json,
  HEX(LEFT(skills_json, 20)) AS prefix_hex
FROM jobs_master
LIMIT 10;

-- Updating by removing the quote wrapper and convert to a true JSON array --
UPDATE jobs_master
SET skills_json = CAST(
    TRIM(
      TRAILING ','
      FROM REPLACE(job_skills, '''', '"')
    ) AS JSON
)
WHERE job_skills LIKE "[%" AND job_skills LIKE "%]";



-- Confirming the changes --
SELECT
  job_id,
  JSON_TYPE(skills_json) AS type,
  JSON_DEPTH(skills_json) AS depth,
  JSON_LENGTH(skills_json) AS skill_count
FROM jobs_master;
-- LIMIT 10;

-- Verifying the changes were correctly executed --
 SELECT JSON_UNQUOTE(skills_json) 
 FROM jobs_master 
 WHERE job_id = X;