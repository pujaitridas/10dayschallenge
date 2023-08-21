/*#Challenge 06
In an E-commerce store, we have sales data recorded in the "sales" table, containing information about cashier ids, department names, 
and discounts given by the cashier.

Instructions:
Import the data from the "sales.csv" file into MySql enviornment.

Write an SQL query to display the cashier_id along with the total discount amount issued by each cashier, then 
add the top department name with the highest refund given by each cashier, then 
add the total amount of discount given by the each cashier in the top department and 
how many times the cashier gives the discount in that top department.

At the end, it'll show the cashier_id, total_discount_amount, top_department_name, top_department_total_discount, and top_department_total_count.
*/

create database challenge6;

use challenge6;

create table sales(
cashier_id	int,
department_name	varchar(200),
discount double
)

select * from sales limit 20;

/*--------------------------------------------Query--------------------------------------------*/  

WITH ranked_data AS (
    SELECT
        cashier_id,department_name AS top_department_name,
        SUM(discount) AS top_department_total_discount,
        COUNT(*) AS top_department_total_count,
        DENSE_RANK() OVER (PARTITION BY cashier_id ORDER BY SUM(discount) DESC) AS department_rank
    FROM
        sales
    GROUP BY
        cashier_id,
        department_name
)

SELECT
    s.cashier_id,
    ROUND(SUM(s.discount), 2) AS total_discount_amount,
    r.top_department_name,
    ROUND(r.top_department_total_discount, 2) AS top_department_total_discount,
    r.top_department_total_count
FROM
    sales s
INNER JOIN
    ranked_data r ON s.cashier_id = r.cashier_id
WHERE
    r.department_rank = 1
GROUP BY
    s.cashier_id,
    r.top_department_name,
    r.top_department_total_discount,
    r.top_department_total_count
ORDER BY
    s.cashier_id;

    
    

















    
    
    
    