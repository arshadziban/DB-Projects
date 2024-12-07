Create database ecommerce
Use ecommerce
show Tables;
select * from customers

-- 1. List all unique cities where customers are located.
select distinct customer_city 
from customers;

--  2. Count the number of orders placed in 2017.
select count(order_id)
from orders
where year(order_purchase_timestamp) = 2017 

-- 3. Find the total sales per category.
select upper(products.product_category) category, 
round(sum(payments.payment_value),2) sales
from products join order_items 
on products.product_id = order_items.product_id
join payments 
on payments.order_id = order_items.order_id
group by category

-- 4. Calculate the percentage of orders that were paid in installments.
select
((sum(case when payment_installments >= 1 then 1
else 0 end))/count(*))*100 as percentage_of_orders
from payments

-- 5. Count the number of customers from each state.
select customer_state ,count(customer_id)
from customers group by customer_state

-- 6. Calculate the number of orders per month in 2018.
select monthname(order_purchase_timestamp) months,
count(order_id) order_count
from orders
where year(order_purchase_timestamp) = 2018
group by months

-- 7. Find the average number of products per order, grouped by customer city.
with count_per_order as 
(select orders.order_id, orders.customer_id, count(order_items.order_id) as oc
from orders join order_items
on orders.order_id = order_items.order_id
group by orders.order_id, orders.customer_id)

select customers.customer_city, round(avg(count_per_order.oc),2) average_orders
from customers join count_per_order
on customers.customer_id = count_per_order.customer_id
group by customers.customer_city order by average_orders desc

-- 8. Calculate the percentage of total revenue contributed by each product category.
select upper(products.product_category) category, 
round((sum(payments.payment_value)/(select sum(payment_value) from payments))*100,2) sales_percentage
from products join order_items 
on products.product_id = order_items.product_id
join payments 
on payments.order_id = order_items.order_id
group by category order by sales_percentage desc

-- 9. Identify the correlation between product price and the number of times a product has been purchased.
select products.product_category, 
count(order_items.product_id),
round(avg(order_items.price),2)
from products join order_items
on products.product_id = order_items.product_id
group by products.product_category

-- 10. Identify the top 3 customers who spent the most money in each year.
select years, customer_id, payment, d_rank
from
(select year(orders.order_purchase_timestamp) years,
orders.customer_id,
sum(payments.payment_value) payment,
dense_rank() over(partition by year(orders.order_purchase_timestamp)
order by sum(payments.payment_value) desc) d_rank
from orders join payments 
on payments.order_id = orders.order_id
group by year(orders.order_purchase_timestamp),
orders.customer_id) as a
where d_rank <= 3 ;