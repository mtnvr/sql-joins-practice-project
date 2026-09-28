CREATE DATABASE join_project_db;

Create Table products(
product_id INT primary key,
product_name VARCHAR(100),
category text,
price numeric(10,2),
stock_quantity INT,
is_available BOOLEAN,
added_on DATE
);

Create Table orders(
order_id INT Primary key,
product_id INT,
quantity INT,
order_date DATE,
customer_name VARCHAR (50),
payment_method VARCHAR (50)
);

select * from products;
select * from orders;


-----Q1. Show each order along with the product name and price
select o.order_id,o.customer_name,p.product_name,p.price from orders o
inner join products p
on o.product_id = p. product_id;

-----Q2. Show all product even if they were never ordered
select p.product_name,o.order_id
from products p
left join orders o
on o.product_id = p.product_id ;

-----Q3. Show Orders for only electronics category
select o.order_id, p.product_name,p.category 
from orders o 
join products p
on o.product_id = p.product_id
where p.category = 'Electronics';

-----Q4. List all orders sorted by Product Price (High to Low)
select o.order_id, p.product_name,p.price
from orders o 
join products p
on o.product_id = p.product_id
order by p.price desc;

-----Q5. Show number of orders placed for each product 
select p.product_name,count(o.order_id) as total_orders 
from products p 
join orders o
on p.product_id = o.product_id
Group by p.product_name;

-----Q6. Show total revenue earned per product
select p.product_name,Sum(o.quantity * p.price) as Revenue
from products p 
join orders o
on p.product_id = o.product_id
Group by p.product_name;

-----Q7. Show products where total order revneue > 2000
select p.product_name,Sum(o.quantity * p.price) as Revenue
from products p 
join orders o
on p.product_id = o.product_id
Group by p.product_name
having Sum(o.quantity * p.price) > 2000;

-----Q8. Show Unique Customers have ordered fitness products
select distinct o.customer_name
from orders o
Join products p 
on o.product_id = p.product_id 
where p.category = 'Fitness';
