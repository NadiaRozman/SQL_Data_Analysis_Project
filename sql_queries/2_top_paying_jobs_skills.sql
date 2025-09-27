/*
Query 2: Skills for Top-Paying Data Analyst Jobs

Scenario:
Identify the top 10 highest-paying remote Data Analyst jobs and the skills required for those roles.
This helps job seekers see which technical skills align with the best-paying opportunities.
*/

WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.job_id,
    job_title,
    salary_year_avg,
    skills_dim.skills
FROM
    top_paying_jobs
    INNER JOIN skills_job_dim 
        ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
