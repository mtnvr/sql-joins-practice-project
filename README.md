# SQL Joins Practice Project

A hands-on practice project covering SQL JOINs, aggregation and filtering on a small e-commerce database (`products` and `orders`), written for PostgreSQL.

## Repository Structure

```
sql-joins-practice-project/
├── README.md
├── joins_practice.sql        # database, tables and Q1–Q8
└── data/
    ├── Products_Table.csv    # 20 products
    └── Orders_Table.csv      # 20 orders
```

## Tables

**products**: `product_id`, `product_name`, `category`, `price`, `stock_quantity`, `is_available`, `added_on`

**orders**: `order_id`, `product_id`, `quantity`, `order_date`, `customer_name`, `payment_method`

`orders.product_id` refers to `products.product_id`, which is the column every JOIN uses.

## Concepts Covered

- INNER JOIN and LEFT JOIN
- Filtering with WHERE
- Sorting with ORDER BY
- Aggregation with COUNT and SUM
- GROUP BY and HAVING
- DISTINCT

## How to Run

1. Run the `CREATE DATABASE` and `CREATE TABLE` statements from `joins_practice.sql`.
2. Import `data/Products_Table.csv` first, then `data/Orders_Table.csv`.
   - pgAdmin: right-click the table, choose **Import/Export Data**, set Format to csv and turn Header on.
   - psql:
     ```sql
     \copy products FROM 'data/Products_Table.csv' WITH (FORMAT csv, HEADER true);
     \copy orders FROM 'data/Orders_Table.csv' WITH (FORMAT csv, HEADER true);
     ```
3. Run Q1–Q8 from `joins_practice.sql`.

## Questions and Results

### Q1. Show each order along with the product name and price
```sql
select o.order_id,o.customer_name,p.product_name,p.price from orders o
inner join products p
on o.product_id = p.product_id;
```
Returns all 20 orders. First rows:

| order_id | customer_name | product_name   | price   |
|---------:|---------------|----------------|--------:|
| 1        | Rohan         | Fitness Band   | 1451.69 |
| 2        | Anjali        | Power Bank     | 831.88  |
| 3        | Rohan         | Wireless Mouse | 1611.53 |
| 4        | Akarsh        | HDMI Cable     | 552.97  |
| 5        | Simran        | Notebook       | 1987.74 |

### Q2. Show all products even if they were never ordered
```sql
select p.product_name,o.order_id
from products p
left join orders o
on o.product_id = p.product_id;
```
Returns 26 rows. A LEFT JOIN keeps every product, and these six were never ordered, so their `order_id` is NULL:

| product_name      | order_id |
|-------------------|----------|
| Bluetooth Speaker | NULL     |
| Laptop Stand      | NULL     |
| LED Desk Lamp     | NULL     |
| Monitor           | NULL     |
| Backpack          | NULL     |
| Webcam            | NULL     |

### Q3. Show orders for only the Electronics category
```sql
select o.order_id, p.product_name,p.category
from orders o
join products p
on o.product_id = p.product_id
where p.category = 'Electronics';
```

| order_id | product_name   | category    |
|---------:|----------------|-------------|
| 2        | Power Bank     | Electronics |
| 3        | Wireless Mouse | Electronics |
| 10       | Headphones     | Electronics |
| 17       | Smartphone     | Electronics |

### Q4. List all orders sorted by product price (high to low)
```sql
select o.order_id, p.product_name,p.price
from orders o
join products p
on o.product_id = p.product_id
order by p.price desc;
```
Returns all 20 orders. Top 5:

| order_id | product_name   | price   |
|---------:|----------------|--------:|
| 5        | Notebook       | 1987.74 |
| 11       | Notebook       | 1987.74 |
| 3        | Wireless Mouse | 1611.53 |
| 20       | Yoga Mat       | 1514.86 |
| 1        | Fitness Band   | 1451.69 |

### Q5. Show the number of orders placed for each product
```sql
select p.product_name,count(o.order_id) as total_orders
from products p
join orders o
on p.product_id = o.product_id
group by p.product_name;
```
Returns 14 products (the ones that were ordered). Most ordered:

| product_name   | total_orders |
|----------------|-------------:|
| Pen Set        | 3            |
| Coffee Mug     | 2            |
| Desk Organizer | 2            |
| Notebook       | 2            |
| Water Bottle   | 2            |

Every other product was ordered once.

### Q6. Show total revenue earned per product
```sql
select p.product_name,sum(o.quantity * p.price) as revenue
from products p
join orders o
on p.product_id = o.product_id
group by p.product_name;
```
Top 5 by revenue:

| product_name   | revenue  |
|----------------|---------:|
| Notebook       | 13914.18 |
| Fitness Band   | 7258.45  |
| Coffee Mug     | 6381.18  |
| Pen Set        | 5240.50  |
| Wireless Mouse | 4834.59  |

### Q7. Show products where total order revenue is greater than 2000
```sql
select p.product_name,sum(o.quantity * p.price) as revenue
from products p
join orders o
on p.product_id = o.product_id
group by p.product_name
having sum(o.quantity * p.price) > 2000;
```

| product_name   | revenue  |
|----------------|---------:|
| Notebook       | 13914.18 |
| Fitness Band   | 7258.45  |
| Coffee Mug     | 6381.18  |
| Pen Set        | 5240.50  |
| Wireless Mouse | 4834.59  |
| Power Bank     | 4159.40  |
| Water Bottle   | 2525.94  |

### Q8. Show unique customers who ordered Fitness products
```sql
select distinct o.customer_name
from orders o
join products p
on o.product_id = p.product_id
where p.category = 'Fitness';
```

| customer_name |
|---------------|
| Akarsh        |
| Anjali        |
| Rohan         |
| Simran        |

> Category values are case-sensitive in PostgreSQL. The data stores `Fitness`, so the filter must use `'Fitness'`.

## Key Takeaways

- Use **INNER JOIN** when you only want rows that match in both tables.
- Use **LEFT JOIN** to keep every row from the left table, such as products that were never ordered.
- Use **HAVING** (not WHERE) to filter on aggregated values like `SUM()`.
- Use **DISTINCT** to remove duplicate values from a result.
