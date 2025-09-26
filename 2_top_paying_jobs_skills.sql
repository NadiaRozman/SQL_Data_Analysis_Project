/*
**Scenario** 
Question: What are the top-paying data analyst jobs, and what skills are required? 
Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
Filters for roles with specified salaries that are remote
Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries

**Query**
CTE top_paying_jobs - Identifies the top 10 highest-paying Data Analyst jobs. 
    1. Gets job_id, job_title, and salary_year_avg in SELECT statement. 
        It filters jobs (in the WHERE clause) based on the following:
            The job title is 'Data Analyst'   (job_title = 'Data Analyst')
            Location being remote (job_location = 'Anywhere')
            A salary exists for the job posting (salary_year_avg IS NOT NULL)
    2. Orders by salary_year_avg in descending order from greatest → least (ORDER BY).
    3. Only gets top 10 jobs (LIMIT).

In the main query:
    1. Returns in the SELECT statement the job_id, job_title, salary_year_avg  from top_paying_jobs CTE and the skills from skills_dim.
    2. Use FROM to get the top_paying_jobs CTE. Then INNER JOIN this CTE with the skills_job_dim and skills_dim tables. This join allows us to list the skills associated with each of these top-paying jobs. We only want to include jobs where there’s a skill associated with it. 
    3. Ordered by salary_year_avg in descending order to ensure the highest-paying jobs are listed first, with their respective skills detailed alongside.

**Reasoning**
- I want the top 10 paying jobs first → I’m going to use the previous query (#1) and modify it in a CTE. A CTE is easier to read and makes it easy to copy and paste another query into it → name CTE as top_paying_jobs → WITH top_paying_jobs AS ().
    1. I will use the previous query #1 within the parenthesis (CTE). 
    2. Keep the same as query #1: WHERE, ORDER BY, and LIMIT. Because:
            I only want to look at remote data analyst jobs that have a salary → Why the WHERE conditions stay the same
            I want to get the highest salaries first → Why the ORDER BY stays the same
            I only want the top 10 highest paying jobs → Why the LIMIT stays the same
    3. The only thing I will change is to get these columns: job_id, job_title, salary_year_avg, from the job_postings_fact table. Since that’s all the info I need here. 
    4. Now I have CTE with the top 10 highest paying data analyst job called top_paying_jobs.

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
        AND job_location = 'Boston, MA'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
​
- I still need to figure out the specific skills required for these roles. → So I’m going to match this CTE with the skills required for each job posting that was returned.

- I’ll do this in the main query: 
    1. I’m going to get the skills for these jobs by using FROM and INNER JOIN → Get top_paying_jobs CTE first then join it with skills_job_dim (which has the skills for with each job) → Then INNER JOIN it with skills_dim to get the skill name.

-- What I need to get 

FROM
		-- Get CTE 
    top_paying_jobs
	INNER JOIN
		-- Match job_id from CTE to skill_id
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
	INNER JOIN
		-- Match skill_id from skills_job_dim with skill_id (to get name)
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
​
    2. Return info on the top 10 paying jobs (from my CTE): job_id, job_title, salary_year_avg. Along with skills (skills) associated with those jobs from skills_dim table.

SELECT
		-- These are from top_paying_jobs CTE
    top_paying_jobs.job_id,  -- job_id also in skills_job_dim
    job_title,
    salary_year_avg,
		-- Need this to get the actual skills from the skills_dim
    skills 
​
    3. Order by the job salaries (use ORDER BY) and in descending order to get the top-paying jobs. 

ORDER BY
    top_paying_jobs.salary_year_avg DESC
​
    4. Now put it all together in the main query:

SELECT
    top_paying_jobs.job_id,
    job_title,
    salary_year_avg,
    skills
FROM
    top_paying_jobs
	INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
	INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
*/

-- Gets the top 10 paying Data Analyst jobs 
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg
        -- name AS company_name
    FROM
        job_postings_fact
    -- LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
				AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
-- Skills required for data analyst jobs
SELECT
    top_paying_jobs.job_id,
    job_title,
    salary_year_avg,
    skills
FROM
    top_paying_jobs
	INNER JOIN
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
	INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;