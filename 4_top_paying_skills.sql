/*
**Scenario**
Qurstion: What are the top skills based on salary? 
Look at the average salary associated with each skill for Data Analyst positions.
Focuses on roles with specified salaries, regardless of location.
Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.

**Query**
- Calculates the average salary per skill for Data analyst positions. 
- Aggregates average salary by skill. In the SELECT statement: use skills_dim.skills to get the skill name and AVG to calculate the average yearly salary associated with each skill (AVG(job_ostings_fact.salary_year_avg)). It uses ROUND to round the average to 2 decimal places. 
- Uses FROM and INNER JOIN between job_postings_fact, skills_job_dim, and skills_dim to correlate job postings with skills. 
        FROM: First get the data from the job_postings_fact table. 
        First INNER JOIN: (job_postings_fact and skills_job_dim) - link each job IDs with its corresponding skill ID from the skills_job_dim table.
        Second INNER JOIN: (result of the first join and skills_dim) - result from the first join (which now includes job IDs and skill IDs from skills_job_dim) is then joined with the skills_dim table using the skill_id field to get the skill name. 
- It filters jobs (in WHERE clause) based on:
        The job title is 'Data Analyst'  
        A salary exists for the job posting 
- Groups by skills (GROUP BY).
- Orders by average salary in descending order (ORDER BY).

**Reasoning**
Use similar logic to previous query (#3) but using average instead of COUNT.
        1 How to find top skills based on salary? → Look at average salary of each skill by job posting. 
        2 In the SELECT statement I’m going to get skills (to identify each skill) from the skills_dim table and then AVG to get the average salary in job postings from the job_postings_fact table. Also to make it easier to read the results I’ll be using ROUND() on the average to round the result to 2 decimal places. 

SELECT
  skills_dim.skills AS skill, 
  ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
​
        3 Need to connect skills to each job posting so I can get the salary_year_avg and skills → Use FROM and INNER JOIN. 
                First I’ll get the information about each job postings → FROM job_postings_fact.
                Then I need to get the skill linked to each job posting from the skills_job_dim. So I’ll INNER JOIN the job_postings_fact and skill_job_dim . This will be linked using the job_id column that’s in both tables. 
                Next is to get the skill name. Which I’ll be using INNER JOIN with skills_job_dim and skills_dim  and link it by using skill_id column that’s in both tables. 

FROM
  job_postings_fact
INNER JOIN
  skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
​
        4 I only want to look at data analyst roles and jobs that have a salary → Filter it in the WHERE clause using job_title_short and salary_year_avg. 

WHERE
  job_postings_fact.job_title_short = 'Data Analyst' 
  AND job_postings_fact.salary_year_avg IS NOT NULL 
​
        5 I need get the average per skill  → GROUP BY skills (also it will give an error if it’s left blank).

GROUP BY
  skills_dim.skills 
​
        6 I need to get the highest average salary by skill → ORDER BY the average in descending (highest → least) order.

ORDER BY
  avg_salary DESC
*/

-- Calculates the average salary for job postings by individual skill 
SELECT
  skills_dim.skills AS skill, 
  ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM
  job_postings_fact
	INNER JOIN
	  skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	INNER JOIN
	  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Analyst' 
  AND job_postings_fact.salary_year_avg IS NOT NULL 
	-- AND job_work_from_home = True  -- optional to filter for remote jobs
GROUP BY
  skills_dim.skills 
ORDER BY
  avg_salary DESC; 