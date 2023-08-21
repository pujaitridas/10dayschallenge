/*#Challenge 09

A bank wants to analyze the daily visits and transactions of its customers throughout a month. 
They have two tables, visit and transaction, with the following details:
The visit table records the user visits to the bank. Each row indicates that a user with the given user_id visited the bank on the specified visit_date.
The transaction table records transactions made by users. 
Each row indicates that a user with the given user_id made a transaction of the specified amount on the specified transaction_date.

The bank wants to generate a report that displays the daily visits and transactions count for each day within the specified month. 
If there are no visits or transactions on a particular day, the report should still display that day with counts of zero.

Write an SQL query to retrieve the following information for each day:
date: The date of the visit or transaction.
visitors_count: The number of distinct users who visited the bank on that date.
transactions_count: The number of distinct users who made transactions on that date.

The report should be ordered by date.
*/

create database challenge9;

use challenge9;

create table visit
(user_id	int,
visit_date varchar(200)
);

create table `transaction`
(user_id	int,
transaction_date varchar(200),
amount int
);

select * from visit limit 10;

select * from `transaction` limit 10;

ALTER TABLE visit ADD Column new_visit_date date;

set sql_safe_updates=0;

Update visit
SET new_visit_date = Str_To_Date(visit_date, "%d-%m-%Y");

ALTER TABLE `transaction` ADD Column new_transaction_date date;

Update `transaction`
SET new_transaction_date = Str_To_Date(transaction_date, "%d-%m-%Y");


/*--------------------------------------------Query--------------------------------------------*/

WITH all_dates AS (
    SELECT DISTINCT new_visit_date AS `date`
    FROM visit
    UNION 
    SELECT DISTINCT new_transaction_date AS `date`
    FROM `transaction`
)
SELECT
  ad.`date`,
  COALESCE(COUNT(DISTINCT v.user_id), 0) AS visitors_count,
  COALESCE(COUNT(DISTINCT t.user_id), 0) AS transactions_count
FROM all_dates ad
LEFT JOIN visit AS v ON ad.`date` = v.new_visit_date
LEFT JOIN `transaction` AS t ON ad.`date` = t.new_transaction_date
GROUP BY ad.`date`
ORDER BY ad.`date`;
    





