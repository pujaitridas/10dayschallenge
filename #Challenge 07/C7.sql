/*#Challenge 07

You have two tables in your database: employees and projects. 
The employees table contains information about employees, such as their employee_id, employee_name, team and salary. 
The projects table contains information about projects, including project_name, employee_id, start_date, expected_end_date, end_date, and budget.

Your task is to write an SQL query to identify the most efficient employee within each team, considering their salary, 
the number of completed projects, the total worth of those projects, and the timely completion of projects and project completion bonuses or deductions:

To determine the efficiency of each employee within their respective team, 
we have formulated an advanced efficiency score that evaluates their value contribution to the company, considering various factors. 
The efficiency score is designed to identify employees who deliver optimal value in relation to their salary, 
while also considering individual project completion performance.

The efficiency score is calculated using the following formula:

Efficiency Score = (Total Worth of Completed Projects * (1 + (Timely Completion Score * 0.2 + Bonus - Deduction))) / Salary

Where:

Total Worth of Completed Projects: This represents the sum of the budgets of all projects completed by the employee.
Timely Completion Score: For each project, this is a binary score (0 or 1) indicating whether the project was completed on or before the expected end date.
Bonus: A value to be added to the efficiency score for projects completed within time. 
The bonus rewards employees for completing projects earlier than the expected end date in this scenario the value is 1.
Deduction: A value to be subtracted from the efficiency score for projects completed over time.
The deduction penalizes employees for completing projects after the expected end date in this scenario the value is 0.5.
Salary: This refers to the employee's salary.

Your SQL query should display the team, employee_name and efficiency_score, below is an sample of query result.
*/


create database challenge7;

use challenge7;

create table employees(
employee_id	int,
employee_name varchar(200),
team varchar(200),
salary int
);

create table projects(
project_name varchar(200),
employee_id	int,
start_date	varchar(200),
expected_end_date varchar(200)	,
end_date	varchar(200),
budget int );

select * from employees limit 10;
select * from projects limit 20;

ALTER TABLE projects ADD Column New_expected_end_date date;

set sql_safe_updates=0;

Update projects
SET New_expected_end_date = Str_To_Date(expected_end_date, "%m/%d/%Y");

ALTER TABLE projects ADD Column New_end_date date;

set sql_safe_updates=0;

Update projects
SET New_end_date = Str_To_Date(end_date, "%m/%d/%Y");

/*--------------------------------------------Query--------------------------------------------*/

WITH ProjectCompletionMetrics AS (
    SELECT
        e.team,
        e.employee_name,
        SUM(CASE WHEN p.New_end_date <= p.New_expected_end_date THEN 1 ELSE 0 END) AS timely_completion_score,
        SUM(CASE WHEN p.New_end_date <= p.New_expected_end_date THEN 1 ELSE -0.5 END) AS bonus_deduction,
        SUM(p.budget) AS total_worth_completed_projects,
        e.salary,
        COUNT(*) AS completed_projects_count
    FROM employees e
    INNER JOIN projects p ON e.employee_id = p.employee_id
	GROUP BY e.team, e.employee_name, e.salary
),
RankedEmployees AS (
    SELECT
        pcm.*,
        DENSE_RANK() OVER (PARTITION BY pcm.team 
        ORDER BY ((pcm.total_worth_completed_projects * (1 + (pcm.timely_completion_score * 0.2 + pcm.bonus_deduction))) / pcm.salary) DESC) AS rank_within_team
    FROM ProjectCompletionMetrics pcm
)
SELECT
    re.team,
    re.employee_name,
    ROUND((re.total_worth_completed_projects * 
    (1 + (re.timely_completion_score * 0.2 + re.bonus_deduction))) / re.salary, 2) AS efficiency_score
FROM RankedEmployees re
WHERE re.rank_within_team = 1
ORDER BY re.team;

















