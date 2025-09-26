/*
**Scenario**
Question: What are the most in-demand skills for data analysts?
Identify the top 5 in-demand skills for a data analyst.
Focus on all job postings. 
Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers. 

**Query**
Identifies the top 5 most demanded skills by counting instances across all jobs postings.
    1 Counts occurrences of each skill using COUNT and get the actual skill skills. Both in the SELECT statement.  
    2 Uses FROM and INNER JOIN between job_postings_fact, skills_job_dim, and skills_dim to correlate job postings with skills. 
            FROM: First get data from the job_postings_fact table. 
            First INNER JOIN: (job_postings_fact and skills_job_dim) - link each job IDs with its corresponding skill ID from the skills_job_dim table.
            Second INNER JOIN: (result of the first join and skills_dim) - result from the first join (which now includes job IDs and skill IDs from skills_job_dim) is then joined with the skills_dim table using the skill_id field to get the skill name. 
    3 WHERE clause filters job titles for ‘Data Analyst’ roles (using job_title_short). 
    4 Groups by skill associate with a job posting  (GROUP BY).
    5 Orders by demand aka the count in descending order (ORDER BY).
    6 Limits to top 5 skills (LIMIT). 

**Reasoning**
- How to find the most in demand skills? → Look at count of skills (how many times a skill showed up in all of the job postings) by job posting. 
        In the SELECT statement we’re going to get skills (to identify each skill) and then COUNT to count how often each skill appears in job postings. 

SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
​
- Need to connect skills to each job posting to get skills, job_id and job_title_short (for the WHERE clause) → Use FROM and INNER JOIN.
                1 First I’ll get the information about each job postings → FROM job_postings_fact.
                2 Then I need to get the skill linked to each job posting from the skills_job_dim. So I’ll INNER JOIN the job_postings_fact and skill_job_dim . This will be linked using the job_id column that’s in both tables. 
                3 Next is to get the skill name. Which I’ll be using INNER JOIN with skills_job_dim and skills_dim  and link it by using skill_id column that’s in both tables. 
FROM
  job_postings_fact
	-- link skills to each job posting
  INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  -- link skill_id to skill name 
	INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
​
- Only want to look at data analyst roles → Filter it in the WHERE clause using job_title_short.

WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Analyst'
​
- I need to count by the type of skills → GROUP BY skills (also it will give an error if it’s left blank).

GROUP BY
  skills_dim.skills
​
- I need to get the top 5 skills → Use LIMIT.

LIMIT 5
​
- I need to get the highest count of skills → ORDER BY the count in descending (highest → least) order. 

ORDER BY
  demand_count DESC
*/

-- Identifies the top 5 most demanded skills for Data Analyst job postings
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