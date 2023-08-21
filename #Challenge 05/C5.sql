/*#Challange 05

Imagine you run a popular streaming service that offers subscriptions to users worldwide. 
Customers from different countries can subscribe to your service in their local currencies. 
You have three main tables storing customer data, subscription details, and payment information.

Customer Table: Contains information about each customer, such as a unique customer ID, 
their subscription status (active or inactive), the country they are from, and the currency they use for payments.

Subscription Table: Stores details of each subscription, including a unique subscription ID, 
the customer it belongs to (referenced by the customer ID), the date when the subscription was renewed, and the subscription's duration in months.

Payment Table: Holds payment-related data, such as a unique payment ID, the subscription it is associated with (referenced by the subscription ID), 
the payment amount made by the customer, and the date when the payment was made.

Now, we want to find out the average payment amount received from customers who are currently active subscribers and 
have renewed their subscription during the month of July 2023. Since customers worldwide pay in their local currencies, 
we need to convert the payment amounts to USD (United States Dollars) for analysis.

The exchange rates are as follows:
1 USD  = 0.9 EUR (Euro) (USD to EUR)
1 USD  = 110.0 JPY (Japanese Yen) (USD to JPY)
1 USD  = 81.0 INR (Indian Rupee) (USD to INR)
1 USD =  1.25 CAD 
1 USD = 0.8 GBP

The final output will show the customer_id and their average payment amount in both USD and the customer's local currency, 
along with the exchange rate used for the conversion. If a customer's local currency is USD, 
the average payment amount in their currency will be the same as the average payment in USD, and the exchange rate will be 1.0.
*/

create database challenge5;

use challenge5;

create table customer_table(
customer_id	int,
subscription_status	varchar(200),
country	varchar(200),
currency varchar(200),
PRIMARY KEY (customer_id));

create table subscription_table(
subscription_id	int,
customer_id	int,
renewal_date varchar(200),	
subscription_length_months int,
PRIMARY KEY (subscription_id),
FOREIGN KEY (customer_id) REFERENCES customer_table (customer_id)
);

create table payment_table(
payment_id	int,
subscription_id	int,
amount	double,
payment_date varchar(200),
PRIMARY KEY (payment_id),
FOREIGN KEY (subscription_id) REFERENCES subscription_table (subscription_id)
)

select * from customer_table limit 10;
select * from subscription_table limit 10;

ALTER TABLE subscription_table ADD Column New_renewal_date date;

set sql_safe_updates=0;
Update subscription_table
SET New_renewal_date = Str_To_Date(renewal_date, "%d-%m-%Y");

select * from payment_table limit 10;
ALTER TABLE payment_date ADD Column New_payment_date date;

Update payment_table
SET New_payment_date = Str_To_Date(payment_date, "%d-%m-%Y");

/*--------------------------------------------Query--------------------------------------------*/

SELECT 
    c.customer_id,c.currency,
    AVG(p.amount) AS avg_payment_in_local_currency,
    ROUND(AVG(p.amount / 
        CASE 
            WHEN c.currency = "USD" THEN 1.0
            WHEN c.currency = "CAD" THEN 1.25
            WHEN c.currency = "GBP" THEN 0.8
            WHEN c.currency = "EUR" THEN 0.9
            WHEN c.currency = "JPY" THEN 110.0
            WHEN c.currency = "INR" THEN 81.0
        END
    ),3) AS avg_payment_in_usd,
    CASE 
		WHEN c.currency = "USD" THEN 1.0
		WHEN c.currency = "CAD" THEN 1.25
		WHEN c.currency = "GBP" THEN 0.8
		WHEN c.currency = "EUR" THEN 0.9
		WHEN c.currency = "JPY" THEN 110.0
		WHEN c.currency = "INR" THEN 81.0
    END AS exchange_rate
FROM 
    customer_table c
INNER JOIN 
    subscription_table s ON c.customer_id = s.customer_id
INNER JOIN 
    payment_table p ON s.subscription_id = p.subscription_id
WHERE 
    c.subscription_status = "active"
    AND s.new_renewal_date >= "2023-07-01"
    AND s.new_renewal_date < "2023-08-01"
GROUP BY 
    c.customer_id,
    c.currency;





