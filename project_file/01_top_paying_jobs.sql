/*
Question: What are the top paying data / data_analyst jobs?
    - Identify the top 10 highest paying Data roles /alyst roles available remotely / US / On-site.
    - Focuses on job postings with specified salaries.
    -Highlight the top paying opportunities for Data Roles / Data Analyst, offering insights into
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE --Change the job_title_short to specify your desired roles eg. Data Engineer/Data Scientist
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT(10);
