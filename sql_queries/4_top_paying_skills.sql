/*
Query 4: Skills Based on Salary

Scenario:
Calculate the average salary associated with each skill for Data Analyst roles with valid salary data.
This reveals which technical skills tend to be most financially rewarding.
*/

SELECT
    skills_dim.skills AS skill, 
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC;
