use ecommerce_analytics;
SELECT count("Order_ID") from orders;
RENAME TABLE ecommerce_cleaned TO orders;

-- Basic Bussiness Qsns
SELECT count("Order_ID") from orders;
SELECT count("Customer_ID") from orders;
SELECT SUM(Gross_Sales) FROM orders;
SELECT SUM(`Discount_Amount`) FROM orders;
SELECT SUM(Net_Sales) FROM orders;
SELECT SUM(`Profit`) FROM orders;
SELECT AVG(`Net_Sales`) FROM orders;
SELECT SUM(`Quantity`) FROM orders;

-- Sales Analysis

SELECT `Month_Name`, SUM(net_sales) FROM orders
GROUP BY `Month_Name`;
SELECT `Month_Name`, SUM(`Profit`) FROM orders
GROUP BY `Month_Name`;
SELECT `City`, SUM(net_sales) FROM orders
GROUP BY `City`;
SELECT `Product_Category`, SUM(net_sales) FROM orders
GROUP BY `Product_Category`;
SELECT `Product_Name`, SUM(net_sales) FROM orders
GROUP BY `Product_Name`;
SELECT `Product_Name`, SUM(net_sales) FROM orders
GROUP BY `Product_Name`
ORDER BY SUM(net_sales) DESC
limit 10;
SELECT `Product_Name`, SUM(`Profit`) FROM orders
GROUP BY `Product_Name`
ORDER BY SUM(`Profit`) DESC
limit 10;

-- Customer Analysis
SELECT `Customer_Name`, SUM(`Net_Sales`) FROM orders
GROUP BY `Customer_Name`
ORDER BY SUM(`Net_Sales`) DESC
limit 10;
SELECT `Customer_Name`, SUM(`Profit`) FROM orders
GROUP BY `Customer_Name`
ORDER BY SUM(`Profit`) DESC
limit 10;
SELECT `Customer_Name`, COUNT(`Order_ID`) FROM orders
GROUP BY `Customer_Name`
ORDER BY COUNT(`Order_ID`) DESC;
SELECT `Customer_Name`, COUNT(`Order_ID`) FROM orders
GROUP BY `Customer_Name`
HAVING COUNT(`Order_ID`)=1;
SELECT `Customer_Name`, COUNT(`Order_ID`) FROM orders
GROUP BY `Customer_Name`
HAVING COUNT(`Order_ID`)>1;
SELECT `Customer_Name`, AVG(`Net_Sales`) FROM orders
GROUP BY `Customer_Name`;

-- Business Performance
SELECT `Payment_Method`, SUM(`Net_Sales`) FROM orders
GROUP BY `Payment_Method`;
SELECT `Sales_Channel`, SUM(`Net_Sales`) FROM orders
GROUP BY `Sales_Channel`;
SELECT `Order_Status`, COUNT(`Order_ID`) FROM orders
GROUP BY `Order_Status`;
SELECT `Order_Status`, SUM(`Net_Sales`) FROM orders
GROUP BY `Order_Status`;
SELECT `Discount_%`, SUM(`Net_Sales`),SUM(`Profit`) FROM orders
GROUP BY `Discount_%`;

-- Advanced 

SELECT Category, Product, Sales,
DENSE_RANK() OVER(PARTITION BY Category ORDER BY Sales DESC) as Ranking
FROM(
    SELECT Product_Category as Category,
           Product_Name as Product,
           SUM(Net_Sales) as Sales FROM orders
           GROUP BY Product_Category,Product_Name
)x;

SELECT DATE_FORMAT(order_date,"%Y-%m")as month,
SUM(Net_Sales)as monthly_sales,SUM(SUM(Net_Sales))
OVER(ORDER BY DATE_FORMAT(order_date,"%Y-%m")) as cumulative_Sales
FROM orders
GROUP BY DATE_FORMAT(order_date,"%Y-%m")
ORDER BY month;

SELECT DATE_FORMAT(order_date,"%Y-%m")as month,
SUM(Net_Sales)as monthly_sales,LAG(SUM(Net_Sales))
OVER(ORDER BY DATE_FORMAT(order_date,"%Y-%m")) as MoM
FROM orders
GROUP BY DATE_FORMAT(order_date,"%Y-%m")
ORDER BY month;

SELECT customer_id,customer_name, SUM(Net_Sales) ,DENSE_RANK()
OVER(ORDER BY SUM(Net_Sales))as ranks 
from orders
GROUP BY customer_id,customer_name;

SELECT customer_id,custumer_name,SUM(Net_Sales)
where SUM(Net_sales)>AVG(Net_sales)
FROM orders
GROUP BY customer_id,custumer_name
ORDER BY SUM(Net_Sales);


SELECT Customer_name, SUM(Net_Sales) AS total_sales, AVG(net_sales)
FROM orders
GROUP BY Customer_name
HAVING SUM(Net_Sales) > (
    SELECT AVG(Net_Sales)
    FROM orders
);                
