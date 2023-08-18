/*# Challenge 02
Using the dataset from Challenge 1 - 
Write a SQL query to find the top 3 salespeople (salesman_id, name) based on the total sales amount they achieved. 
The result should be sorted in descending order of the total sales amount.*/

use cars_db;

/*--------------------------------------------Query--------------------------------------------*/

SELECT 
    s.salesman_id, s.`name`, SUM(cost_$) AS `total_sales_amount`
FROM
    salespersons s
        INNER JOIN
    car_details c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id , s.`name`
ORDER BY total_sales_amount DESC
LIMIT 3;