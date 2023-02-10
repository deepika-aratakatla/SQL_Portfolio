---------------------------------------------------------------------------------------------------------
                           Fecthing the Data from Airline DB database via PostgreSQl
---------------------------------------------------------------------------------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.Using Orders table, write the query to count distinct customers who purchase anything from Northwind
Expected output: Single number denoting the distinct transacting customers
Query :  	
select count(distinct customer_id) 
from orders

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

2.	Get the details of the orders made by VINET, TOMSP, HANAR, VICTE, SUPRD, CHOPS from the orders table.
Expected columns in the output – Order_id, order_date, customer_id, Ship_country and Employee_id

Query :   	
select order_id , 
order_date, 
customer_id, 
ship_country , 
employee_id
from orders 
where customer_id in ('VINET', 'TOMSP', 'HANAR', 'VICTE', 'SUPRD', 'CHOPS')

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

3.	According to the customers table, list down the customer_ids which start from "L" and end at "S"
Expected columns in the output – Customer_id

Query : 
select customer_id
from customers
where customer_id like 'L%' and customer_id like '%S'
		 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

4.	According to the customers table, list down the customer_ids of france which starts from “L”
Expected columns in the output – Customer_id
Query : 
select customer_id
from customers
where country = 'France' and customer_id like 'L%'

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

5.	The company is planning to give a 10% discount on products above 10 dollars price point(including). Get the list of the product_id which are going to be listed at discounted price
Expected columns in the output – Product_id
Query : 
select DISTINCT(product_id)
from order_details 
where unit_price >= 10

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

6.	According to the products table, which category_ids have more than 500 units_in_stock?
Expected columns in the output – category_id, total units_in_stock

Query: 
select  category_id, 
sum(units_in_stock) total_unit_stock
       		from products 
group by category_id
having  sum(units_in_stock) > 500

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

7.	According to the products table, list the supplier_ids responsible for supplying exactly 5 products from the list.
Expected columns in the output –  supplier id, total products supplied

Query: 
select supplier_id, 
count(product_id) as total_products_supplied
from products 
group by supplier_id 
having count(product_id)=5

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

8.	Using the orders table, create a table where the count of orders placed would be mentioned against every customer_id.
Expected columns in the output – Customer_id, count of orders
Query: 
select customer_id, 
count(order_id) count_of_orders
from orders 
group by customer_id

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

9. Using the orders table, create a table where the count of orders placed would be mentioned against every customer_id but only for customers having at least 10 orders
Expected columns in the output – Customer_id, count of orders
Query:
select customer_id, 
count(order_id) count_of_orders
from orders 
group by customer_id
having count(order_id)>=10

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

10.	The Order_Details table is unique at the order_id and product_id levels. It shows the various products ordered for every order_id. Northwind is using bigger boxes for orders having 6 or more product_ids. Can you extract the list of order ids along with the count of products ordered?
Expected output: Order_id, count of products
Query:   	
select order_id, 
count(product_id) count_of_products
from order_details
		group by order_id
having count(product_id) >=6

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
