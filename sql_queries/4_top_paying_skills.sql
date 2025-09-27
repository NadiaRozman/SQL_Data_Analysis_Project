/*
===============================================
 Query 4: Skills Based on Salary
===============================================

Scenario:
- Calculate the average salary associated with each skill for Data Analyst positions.  
- Focus only on roles with specified (non-null) salaries, regardless of location.  

Why?
- Highlights which skills command the highest salaries.  
- Helps job seekers identify the most financially rewarding skills to acquire or improve.  
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True    -- optional: focus on remote jobs
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
Key Insights from Results:
- Big Data & Machine Learning: Highest salaries are tied to PySpark, Couchbase, DataRobot, and Jupyter, showing a premium on data processing and predictive modeling expertise.  
- Development & Deployment Tools: GitLab, Kubernetes, and Airflow skills highlight the lucrative overlap between analytics and data engineering.  
- Cloud Expertise: Tools like Elasticsearch, Databricks, and GCP further prove how cloud-based environments are reshaping high-paying analytics roles.  

Sample Results:
================
[
  { "skills": "pyspark",       "avg_salary": 208172 },
  { "skills": "bitbucket",     "avg_salary": 189155 },
  { "skills": "couchbase",     "avg_salary": 160515 },
  { "skills": "watson",        "avg_salary": 160515 },
  { "skills": "datarobot",     "avg_salary": 155486 },
  { "skills": "gitlab",        "avg_salary": 154500 },
  { "skills": "swift",         "avg_salary": 153750 },
  { "skills": "jupyter",       "avg_salary": 152777 },
  { "skills": "pandas",        "avg_salary": 151821 },
  { "skills": "elasticsearch", "avg_salary": 145000 }
  ...
]
*/
