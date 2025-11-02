/*
 Question: What are the most optimal skills to learn for different data roles?
 - Most in demand and most paid skills.
 - Here we'll focus on remote jobs only.
 */
--Using CTE:
WITH skills_demand AS (
    SELECT sjd.skill_id,
        sd.skills AS skill,
        COUNT(sjd.job_id) AS demand_count
    FROM job_postings_fact AS jpf
        INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
        INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Analyst'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sjd.skill_id,
        sd.skills
),
average_salary AS (
    SELECT sjd.skill_id,
        sd.skills AS skill,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact AS jpf
        INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
        INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Analyst'
        AND jpf.job_work_from_home = TRUE
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY sjd.skill_id,
        sd.skills
)
SELECT sdmd.skill_id,
    sdmd.skill,
    sdmd.demand_count,
    asal.avg_salary
FROM skills_demand AS sdmd
    INNER JOIN average_salary AS asal ON sdmd.skill_id = asal.skill_id
WHERE demand_count > 20
ORDER BY asal.avg_salary DESC,
    sdmd.demand_count DESC
LIMIT 20;
/*
More Simplified
*/
SELECT skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.job_id) > 20
ORDER BY avg_salary DESC,
    demand_count DESC
LIMIT 20;