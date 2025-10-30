SELECT salary_year_avg,
    job_title_short,
    CASE
        WHEN salary_year_avg >= 100000 THEN 'High Salary'
        WHEN salary_year_avg >= 50000 THEN 'Mid Salary'
        ElSE 'Low salary'
    END AS salary_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;
WITH company_stats AS (
    SELECT company_id,
        count(company_id) AS total_jobs,
        AVG(salary_year_avg) AS avg_salary
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT cd.name AS company_name,
    cs.total_jobs,
    ROUND(cs.avg_salary, 2) AS avg_salary
FROM company_dim AS cd
    LEFT JOIN company_stats AS cs ON cd.company_id = cs.company_id
ORDER BY cs.total_jobs DESC;
WITH frequent_skills AS(
    SELECT skill_id,
        COUNT(*) AS Total_skills
    FROM skills_job_dim
    GROUP BY skill_id
)
SELECT sd.skills AS skill_name,
    fs.Total_skills
FROM skills_dim AS sd
    LEFT JOIN frequent_skills as fs ON sd.skill_id = fs.skill_id
ORDER BY fs.Total_skills DESC;
WITH company_category AS(
    SELECT company_id,
        COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT cd.name AS company_name,
    cc.total_jobs,
    CASE
        WHEN total_jobs < 10 THEN 'small'
        WHEN total_jobs >= 10
        AND total_jobs < 50 THEN 'medium'
        ELSE 'large'
    END AS category
FROM company_dim AS cd
    LEFT JOIN company_category AS cc ON cd.company_id = cc.company_id
ORDER BY cc.total_jobs ASC;
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