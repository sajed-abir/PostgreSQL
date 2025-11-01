/*
 Question: What are the most in demand skills for different data roles?
 */
--Using CTE--
WITH remote_job_skills AS(
    SELECT skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skill_to_job
        INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skill_to_job.job_id
    WHERE job_postings.job_work_from_home = TRUE
        AND job_title_short = 'Data Engineer'
    GROUP BY skill_id
)
SELECT skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
    INNER JOIN skills_dim as skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
limit 5;
-- More Simplified Query
SELECT skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    /*here you putyour desired data roles and other filters like location, work from home etc*/
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
