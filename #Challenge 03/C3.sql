/*#Challenge 03 
Using the dataset from Challenge 1 - 
Write a SQL query to find the rank to each salesperson on the basis of number of car sold. 
Please use continuous rank and rank should be visible in your out-put.*/

use cars_db;

/*--------------------------------------------Query--------------------------------------------*/

SELECT 
	s.`name` as `Salesman_name`, 
	COUNT(c.sale_id) AS `Number_of_cars_sold`, 
	DENSE_RANK() OVER (ORDER BY COUNT(c.sale_id) DESC) AS `rank`          #continuous rank
FROM 
	salespersons s 
		INNER JOIN 
	car_details c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id,s.`name`
ORDER BY `rank`;