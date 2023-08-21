/*#Challenge 10

Consider a database with three tables: 'trades,' 'salesreps,' and 'clients.' 
The 'trades' table contains trade information including face value, actual revenue, and churn dates for different clients. 
The 'salesreps' table holds information about sales representatives, including their first and last names. 
Lastly, the 'clients' table stores details about different clients.

In the "trades" table, the column named "churn_date" contains dates when a trade was marked as churned. 
If the churn date is not null (or not empty), it means the trade has been considered as churned. 
In other words, a "churned" trade is one where the client has decided to end their relationship or service with the company, 
resulting in the trade being marked as no longer active or relevant.

Your task is to identify the top 10 most churned clients based on the number of churned trades. 
For each of these top churned clients, determine the sales representative(s) involved, the total face value, the total actual revenue, and 
the percentage of face value that is down from revenue for each sales representative. 
The percentage down from revenue is calculated as ((Face Value - Actual Revenue) / Face Value) * 100.

Write a SQL query that accomplishes this. 
Your query should retrieve the client name, sales representative name(merge first_name and last_name into one column), 
total face value, total actual revenue, and percentage down from revenue for each sales representative. 
The results should be ordered in descending order based on the percentage down from revenue, and only the top 10 results should be displayed.
*/

create database challenge10;

use challenge10;

create table trades
(trade_id int,
client_id int,
salesperson_id int,
trade_date varchar(200),
facevalue int,
actual_revenue int,
churn_date varchar(200)
);

create table salesreps
(salesrep_id int,
first_name varchar(200),
last_name varchar(200)
);

create table clients
(client_id	int,
`name` varchar(200),
signup_date varchar(200)
);

select * from trades limit 25;

select * from salesreps limit 25;

select * from clients limit 25;

ALTER TABLE trades ADD Column new_churn_date date;

set sql_safe_updates=0;

Update trades
SET new_churn_date = Str_To_Date(churn_date, "%d-%m-%Y");

/*--------------------------------------------Query--------------------------------------------*/  

WITH MostChurnedClient AS (
    SELECT client_id, COUNT(*) AS churn_count
    FROM trades t
    WHERE new_churn_date!='0000-00-00'
    GROUP BY client_id
    ORDER BY churn_count DESC
    LIMIT 10
)
SELECT
    c.name AS `client name`,
    CONCAT(s.first_name," ",s.last_name) AS  `sales representative name`,
    SUM(t.facevalue) AS `salesrep total face value`,
    SUM(t.actual_revenue) AS `salesrep total actual revenue`,
    (SUM(t.facevalue) - SUM(t.actual_revenue)) / SUM(t.facevalue) * 100 AS `percentage down from revenue`
FROM trades t
INNER JOIN MostChurnedClient mcc ON t.client_id = mcc.client_id
INNER JOIN salesreps s ON t.salesperson_id = s.salesrep_id
INNER JOIN clients c ON t.client_id = c.client_id
WHERE new_churn_date!='0000-00-00'
group by `client name`,`sales representative name`
order by `percentage down from revenue` desc
limit 10;





    
