/*
===============================================
 Query 1: Top-Paying Data Analyst Jobs
===============================================

Scenario:
- Identify the top 10 highest-paying Data Analyst roles that are remote.
- Only include postings with specified (non-null) salaries.
- Bonus: Include company names for more context.

Why?
- Highlights the most lucrative opportunities in the Data Analyst job market.  
- Provides insight into both salary potential and employer diversity.  
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
LEFT JOIN company_dim 
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
Key Insights from Results:
- Wide Salary Range: Salaries span from $184,000 up to $650,000, showing strong earning potential.  
- Diverse Employers: Companies like SmartAsset, Meta, and AT&T are among the top, representing different industries.  
- Job Title Variety: Ranges from “Data Analyst” to senior/leadership roles such as “Director of Analytics,”  
  highlighting career path diversity within data analytics.  

Sample Results:
================
[
  {
    "job_id": 226942,
    "job_title": "Data Analyst",
    "salary_year_avg": 650000.0,
    "company_name": "Mantys"
  },
  {
    "job_id": 547382,
    "job_title": "Director of Analytics",
    "salary_year_avg": 336500.0,
    "company_name": "Meta"
  },
  {
    "job_id": 552322,
    "job_title": "Associate Director- Data Insights",
    "salary_year_avg": 255829.5,
    "company_name": "AT&T"
  },
  ...
]
*/
