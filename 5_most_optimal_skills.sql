/*
**Scenario**
Question: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst? 
Identify skills in high demand and associated with high average salaries for Data Analyst roles
Concentrates on remote positions with specified salaries
Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis

**Query**
CTE skills_demand - identifies skills in demand for Data Analyst roles (aggregates count by skill):
        - This is similar to Query #3.
        - In the  SELECT statement it gets:
                skill_id for the id of the skill 
                skills for skill name 
                Counts job (job_id) using COUNT. 

        - Uses FROM and INNER JOIN to match job_postings_fact with skills_dim through skills_job_dim, to link job postings with the required skills.
                FROM: First get the data from the job_postings_fact table. 
                First INNER JOIN: (job_postings_fact and skills_job_dim) - link each job IDs with its corresponding skill ID from the skills_job_dim table.
                Second INNER JOIN: (result of the first join and skills_dim) - result from the first join (which now includes job IDs and skill IDs from skills_job_dim) is then joined with the skills_dim table using the skill_id field to get the skill name 

        - Filters in the WHERE clause: 
                'Data Analyst' positions 
                with specified salaries, 
                that are remote
                Groups by skill ID (GROUP BY). 

        - CTE average_salary - calculates the average salary per skill for Data Analyst roles (aggregates average salary by skill):
                This is similar to Query #4. 
                In SELECT statement it: 
                            Gets skill_id
                            Average salary (salary_year_avg) using AVG.
                Uses FROM and INNER JOIN to link job postings to skills.
                            FROM: We’ll be first grabbing data from the job_postings_fact table. 
                            INNER JOIN: (job_postings_fact and skills_job_dim) - link each job IDs with its corresponding skill ID from the skills_job_dim table.
        - Filters in the WHERE clause: 
                'Data Analyst' positions 
                with specified salaries, 
                that are remote.
                Groups by skill ID (GROUP BY). 

        - Main Query:
                Combines skills_demand and average_salary: The main query joins (INNER JOIN) these two CTEs by skill ID to align demand counts with average salaries for each skill.
                Selects skills, demand counts, and average salaries (SELECT): 
                For each skill, it shows how many times it's mentioned across job postings (demand_count) and the average salary (avg_salary) for jobs requiring that skill, rounding salaries (ROUND) to 2 decimal places for readability.
[Note: In Luke’s video he has ROUND() in the average_salary CTE around the AVG(salary_year_avg). This would return the same results.]
                Orders by demand and salary: Orders by count of skills by job postings and average salary (ORDER BY). Both are in descending order (highest → lowest). 
                Limits to top 10: Focuses on the top 10 skills (LIMIT).

**Reasoning**
I want to get the skills with the highest demand → We’ll be using Query #3 and modifying it → Create a CTE called skills_demand.
        1 How do we find the most in demand sills? → Look at count of skills (how many times a skill showed up in all of the job postings) by job posting. 
        2 In the SELECT statement I’m going to get skill_id (to identify each skill) and then COUNT the job_id to count how often each skill appears in job postings. I also need the skills column to get the skill name. 

SELECT
    skills_dim.skill_id,
		skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
​
        3 Need to connect skills to each job posting so I can get skill_id , skills and job_id columns and filter out the job title using job_title_short→ Use FROM and INNER JOIN.
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
        4 Next I only want to look at specific jobs → Filter in the WHERE clause:
                Only want to look at data analyst roles → use job_title_short to filter for data analyst jobs.
                Get jobs where there is a salary attached to the job → use salary_year_avg to look at non null values. 
                And only look at remote jobs → use job_work_from_home to look at remote roles.
  
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
​
        5 I need to count by the type of skills → GROUP BY the skill_id. For this we don’t need to group by the skills column because we are grouping a primary key (skill_id) we don’t need to group by another column in the select statement. Typically you would need to include all columns in the GROUP BY statement, but in this case you don’t. 
  
  GROUP BY
    skills_dim.skill_id
​
        6 I want to get the skills with the highest salary → We’ll be using Query #4 and modifying it → Create a CTE called average_salary.
                How to find top skills based on salary? → Look at average salary of each skill by job posting.
                In the SELECT statement we’re going to get skills (to identify each skill) and then AVG to get the average salary in job postings. 
 
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
​
        7 Need to connect skills to each job posting to get skill_id and salary_year_avg→ Use FROM and INNER JOIN. I’ll only be joining skill_job_dim table to match the jobs with the skills. Unlike Query #4 we won’t be joining by skills_dim since we don’t need the skill name. I will get the skill name when we join this CTE with the skills_demand CTE in the main query. 
                First I’ll get the information about each job postings → FROM job_postings_fact.
                Then I need to get the skill linked to each job posting from the skills_job_dim. So I’ll INNER JOIN the job_postings_fact and skill_job_dim . This will be linked using the job_id column that’s in both tables. 
 
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
​
        8 Next I only want to look at specific jobs → Filter in the WHERE clause:
                Only want to look at data analyst roles → use job_title_short to filter for data analyst jobs.
                Get jobs where there is a salary attached to the job → use salary_year_avg to look at non null values. 
                And only look at remote jobs → use job_work_from_home to look at remote roles.
 
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
​
        9 I need to count by the type of skills → GROUP BY the skill_id. 
  
  GROUP BY
    skills_dim.skill_id
​
        10 In the main query I’ll join these two CTEs so we can match high demand (skills_demand) with high paying jobs (average_salary). 
        11 In the SELECT statement I’m going to get the skill name (skills), the count of skills per job (demand_count), and the average salary for data analyst roles (avg_salary). For the average I’m going to use ROUND() to round the average to two decimal places to make it easier to read. 

SELECT
  skills_demand.skills,
  skills_demand.demand_count,
  ROUND(average_salary.avg_salary, 2) AS avg_salary --ROUND to 2 decimals 
​
        12 I’m going to get the skills demand CTE first in the FROM statement → Then I’m going to INNER JOIN it with the average_salary CTE on skill_id. I’m doing this so I can match the high demand for each skill with the average salary for each skill.

FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
​
        13 Next I’m going to order by the most in demand skills (demand_count) and then the average salary per skill (avg_salary). Both will be in descending order so I can get the highest (of both) first.

ORDER BY
  demand_count DESC, 
	avg_salary DESC
​
        14 Only get the top 10 skills → Use LIMIT.

LIMIT 10
*/

-- Identifies skills in high demand for Data Analyst roles
-- Use Query #3 (but modified)
WITH skills_demand AS (
  SELECT
    skills_dim.skill_id,
		skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	  INNER JOIN
	    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
  WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
		AND job_postings_fact.salary_year_avg IS NOT NULL
    AND job_postings_fact.job_work_from_home = True
  GROUP BY
    skills_dim.skill_id
),
-- Skills with high average salaries for Data Analyst roles
-- Use Query #4 (but modified)
average_salary AS (
  SELECT
    skills_job_dim.skill_id,
    AVG(job_postings_fact.salary_year_avg) AS avg_salary
  FROM
    job_postings_fact
	  INNER JOIN
	    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	  -- There's no INNER JOIN to skills_dim because we got rid of the skills_dim.name 
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
  ROUND(average_salary.avg_salary, 2) AS avg_salary --ROUND to 2 decimals 
FROM
  skills_demand
	INNER JOIN
	  average_salary ON skills_demand.skill_id = average_salary.skill_id
-- WHERE demand_count > 10
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 10 --Limit 25
; 