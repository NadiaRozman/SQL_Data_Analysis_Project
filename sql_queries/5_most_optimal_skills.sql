/*
===============================================
 Query 5: Most Optimal Skills to Learn
===============================================

Scenario:
- Identify skills that are both in high demand and associated with high average salaries for Data Analyst roles.  
- Focus on remote positions with specified salaries.  

Why?
- Provides strategic insights for career development by targeting skills that offer both job security (demand) and strong financial returns (salary).  
*/

-- Identifies skills in high demand for Data Analyst roles
WITH skills_demand AS (
  SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
    INNER JOIN skills_job_dim 
      ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
      ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_dim.skill_id
),

-- Skills with high average salaries for Data Analyst roles
average_salary AS (
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
  FROM
    job_postings_fact
    INNER JOIN skills_job_dim 
      ON job_postings_fact.job_id = skills_job_dim.job_id
    -- Note: no join to skills_dim here since we don’t need skill names again
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_job_dim.skill_id
)

-- Return high demand and high salaries for 10 skills 
SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 2) AS avg_salary -- Rounded to 2 decimals
FROM
  skills_demand
  INNER JOIN average_salary 
    ON skills_demand.skill_id = average_salary.skill_id
-- Optional: uncomment WHERE demand_count > 10 to filter out low-demand skills
ORDER BY
  demand_count DESC, 
  avg_salary DESC
LIMIT 10; 

/*
Key Insights from Results:
- High-Demand Programming: Python and R dominate demand, though salaries remain moderate compared to niche tools.  
- Cloud Platforms: Snowflake, Azure, AWS, and BigQuery show both strong demand and attractive salaries — critical for modern data environments.  
- BI & Visualization Tools: Tableau and Looker stand out, proving the importance of storytelling through data.  
- Databases: Oracle, SQL Server, and NoSQL maintain relevance, reflecting enduring demand for data management skills.  

Sample Results:
================
[
  { "skills": "sql",       "demand_count": "398", "avg_salary": "97237.16" },
  { "skills": "excel",     "demand_count": "256", "avg_salary": "87288.21" },
  { "skills": "python",    "demand_count": "236", "avg_salary": "101397.22" },
  { "skills": "tableau",   "demand_count": "230", "avg_salary": "99287.65" },
  { "skills": "r",         "demand_count": "148", "avg_salary": "100498.77" },
  { "skills": "power bi",  "demand_count": "110", "avg_salary": "97431.30" },
  { "skills": "sas",       "demand_count": "63",  "avg_salary": "98902.37" },
  { "skills": "powerpoint","demand_count": "58",  "avg_salary": "88701.09" },
  { "skills": "looker",    "demand_count": "49",  "avg_salary": "103795.30" }
]
*/