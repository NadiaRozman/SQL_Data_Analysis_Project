/*
**Scenario**
Question: What are the top-paying data analyst jobs?
Identify the top 10 highest-paying Data Analyst roles that are available remotely.
Focuses on job postings with specified salaries.
Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.

**Query:**
- Gets the following columns in the SELECT statement: job_id, job_title, job_location, job_schedule_type, salary_year_avg, job_posted_date.
- Filters in the WHERE clause for:
		'Data Analyst' jobs only (job_title = 'Data Analyst')
		A salary exists (salary_year_avg IS NOT NULL)
		Only includes remote jobs (job_location = 'Anywhere')
- Orders the results by salary_year_avg in descending order (using ORDER BY).
- Only include the top 10 jobs (LIMIT).

**Reasoning**
-   Look at job_postings_fact table. 
FROM job_postings_fact
​
-   I want to know more about the jobs so let’s get relevant job info → Get job_id, job_title, job_location, job_schedule_type, salary_year_avg, job_posted_date columns in the SELECT statement. 
    This lets me know about the job title, location, whether or not it’s full-time, and the salary.
    This is all good to know when exploring jobs.

SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date
​
-   I need to look at specific types of jobs → Add conditions in the WHERE clause. 
    I only want to look at data analyst jobs.

WHERE 
	job_title = 'Data Analyst'
​
-   And look at jobs that are remote → Location is anywhere. 

AND job_location = 'Anywhere'
​
-   And I only want to look at jobs where there is a average yearly salary → salary_year_avg needs to not be null. 

AND salary_year_avg IS NOT NULL
​
-   Since I only want the top paying jobs → I’m going to order by the salary_year_avg in descending order (to get highest paying jobs first). 

ORDER BY 
	salary_year_avg DESC
​
-   I only want to look at the top 10 highest paying jobs → Use LIMIT. 

LIMIT 10
*/

--Top 10 highest paying data analyst roles that are either remote or local
SELECT
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date
-- name AS company_name
FROM
	job_postings_fact
-- LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
	job_title = 'Data Analyst'
	AND salary_year_avg IS NOT NULL
	AND job_location = 'Anywhere'
ORDER BY
	salary_year_avg DESC 
LIMIT 10;