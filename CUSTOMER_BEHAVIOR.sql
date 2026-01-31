Create Database customer_behavior;

Select * from customers limit 30;

Select gender,sum(purchase_amount) as revenue from customers group by gender;

Select customer_id,purchase_amount from customers where discount_applied ="Yes" and purchase_amount>=(Select Avg(purchase_amount) from customers);

Select item_purchased,Avg(review_rating) as "Average Product Rating" from customers group by item_purchased order by avg(review_rating) Desc limit 5;

Select shipping_type,AVG(purchase_amount) from customers where shipping_type in ('Standard','Express') group by shipping_type;

Select subscription_status, Count(customer_id) as total_customers,Avg(purchase_amount) as avgspend, sum(purchase_amount) as total_revenue from customers group by subscription_status order by total_revenue,avgspend desc;

Select item_purchased,Sum(CASE WHEN discount_applied="Yes" THEN 1 ELSE 0 END)/count(*) *100 as discount_rate from customers group by item_purchased order by discount_rate desc limit 5; 

with customer_type as (
select customer_id, previous_purchases,
CASE 
   WHEN previous_purchases=1 THEN 'NEW'
   WHEN previous_purchases Between 2 and 10 THEN 'Returning'
   ELSE 'Loyal'
   END as customer_segment
from customers 
) 
select customer_segment,count(*) as "Number of Customers" from customer_type group by customer_segment;

with item_count as(
  select category,item_purchased, count(customer_id) as total_orders,
  ROW_NUMBER() over(Partition by category order by count(customer_id)DESC) as item_rank
  from customers
  group by category,item_purchased
)

select item_rank,category,item_purchased,total_orders from item_count where item_rank<=3;

Select subscription_status , count(customer_id) as repeat_buyers from customers where previous_purchases>5 group by subscription_status;

Select age_group,sum(purchase_amount) as total_revenue from customers group by age_group order by total_revenue DESC;