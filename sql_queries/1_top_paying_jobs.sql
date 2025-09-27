/*
Query 1: Top-Paying Data Analyst Jobs

Scenario:
Identify the top 10 highest-paying remote Data Analyst roles with specified salaries.
This highlights the most lucrative opportunities while focusing on remote flexibility.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
WHERE
    job_title = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
