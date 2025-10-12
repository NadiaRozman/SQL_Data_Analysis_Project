/*
===============================================
 Query 2: Skills for Top Paying Data Analyst Jobs
===============================================

Scenario:
- Identify the top 10 highest-paying remote Data Analyst roles. 
- Add the specific skills required for those jobs.  

Why?
- Provides insight into what technical skills are most valued 
  in high-paying roles. 
- Helps job seekers focus on skills that align with top salaries.  
*/

WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim 
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim 
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;

/*
Key Insights from Results:
- SQL appears in 8 of the top-paying roles.  
- Python is close behind with 7 roles.  
- Tableau shows up in 6 roles.  
- Other skills include R, Excel, Snowflake, Pandas, Power BI, AWS, Azure.  

Conclusion:
- Even at the highest salary levels, core skills (SQL, Python, Tableau, Excel) remain essential.  
- Specialized tools (Snowflake, GitLab, Pandas, cloud platforms) add extra value depending on the company’s stack.  
*/