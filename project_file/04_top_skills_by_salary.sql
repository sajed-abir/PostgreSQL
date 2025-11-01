/*
What are the top skills based on salary for my role?
*/

SELECT skills,
ROUND (AVG (salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    /*here you putyour desired data roles and other filters like location, work from home etc*/
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 10;

