-- Dimension: skills
DROP TABLE  skills_dim;

CREATE TABLE skills_dim (
  skill_id   INT AUTO_INCREMENT PRIMARY KEY,
  skill_name VARCHAR(100) UNIQUE NOT NULL
);

DROP TABLE  skill_link;

CREATE TABLE skill_link (
  job_id   BIGINT UNSIGNED NOT NULL,
  skill_id INT NOT NULL,
  PRIMARY KEY (job_id, skill_id),
  FOREIGN KEY (job_id)   REFERENCES jobs_master(job_id),
  FOREIGN KEY (skill_id) REFERENCES skills_dim(skill_id)
);
-- ====================================================================== --
-- Rebuild the skills_dim and skill_link tables

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE skill_link;
TRUNCATE skills_dim;
SET FOREIGN_KEY_CHECKS = 1;
-- ============================================================================ --  
-- populate skills_dim and skill_likn table with cleaned json skill name values --

INSERT IGNORE INTO skills_dim (skill_name)
SELECT DISTINCT jt.skill
FROM jobs_master jm
CROSS JOIN JSON_TABLE(jm.skills_json, '$[*]'
  COLUMNS(skill VARCHAR(100) PATH '$')
) AS jt;
-- ========================================================================= --
INSERT INTO skill_link (job_id, skill_id)
SELECT DISTINCT t.job_id, t.skill_id
FROM (
  -- derive all job/skill pairs from JSON
  SELECT
    jm.job_id,
    sd.skill_id
  FROM jobs_master jm
  CROSS JOIN JSON_TABLE(
    jm.skills_json, '$[*]'
    COLUMNS(skill VARCHAR(100) PATH '$')
  ) AS jt
  JOIN skills_dim sd
    ON sd.skill_name = jt.skill
) AS t
LEFT JOIN skill_link sl
  ON sl.job_id = t.job_id
 AND sl.skill_id = t.skill_id
WHERE sl.job_id IS NULL;  -- only insert non-existing pairs
-- ==================================================================================== --
-- Verification the values has been inserted correctly --
SELECT sd.skill_name, COUNT(sl.job_id) AS job_count
FROM skills_dim sd
JOIN skill_link sl ON sd.skill_id = sl.skill_id
GROUP BY sd.skill_name
ORDER BY job_count DESC
LIMIT 129;


  




















  
  
  



  
