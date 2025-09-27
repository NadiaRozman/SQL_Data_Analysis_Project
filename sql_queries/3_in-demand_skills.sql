/*
===============================================
 Query 3: In-Demand Skills for Data Analysts
===============================================

Scenario:
- Identify the top 5 most in-demand skills for Data Analyst roles.
- Join job postings with skills tables (similar to Query 2) to count how often each skill appears.
- Focus on all job postings (remote + non-remote).

Why?
- Reveals which skills are most frequently requested by employers.  
- Provides job seekers with clear guidance on which technical skills to prioritize.
*/

SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM
  job_postings_fact
  INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Analyst'
	-- AND job_work_from_home = True -- optional to filter for remote jobs
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 5;

/*
Key Insights from Results:
- SQL and Excel remain foundational, appearing in the highest number of postings.  
- Python, Tableau, and Power BI emphasize the growing importance of programming and data visualization.  
- Together, these highlight a balance between classic tools (Excel) and modern data stack skills (SQL, Python, BI tools).  

Sample Results:
================
[
  { "skills": "sql",      "demand_count": 92628 },
  { "skills": "excel",    "demand_count": 67031 },
  { "skills": "python",   "demand_count": 57326 },
  { "skills": "tableau",  "demand_count": 46554 },
  { "skills": "power bi", "demand_count": 39468 }
]
*/