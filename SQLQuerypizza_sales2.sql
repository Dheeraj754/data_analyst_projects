create database pizza_sales
use pizza_sales

-- retrieve the total no of order placed
select count(order_id)as order_placed from [dbo].[orders]

--calculate the total revenue generated from pizza sales.
select round(sum([dbo].[order_details].quantity * [dbo].[pizzas].price),2) as total_revenue
from [dbo].[order_details] join [dbo].[pizzas] 
on [dbo].[pizzas].pizza_id =[dbo].[order_details].pizza_id

--identify the higest price pizza 
select top 1 [dbo].[pizza_types].name as name ,[dbo].[pizzas].price as highest_Pizza_price
from [dbo].[pizza_types] join [dbo].[pizzas]
on [dbo].[pizzas].[pizza_type_id]=[dbo].[pizza_types].[pizza_type_id]
order by [dbo].[pizzas].price desc 

--identify the most common pizza size ordered
select top 1 [dbo].[pizzas].size,count([dbo].[order_details].order_details_id)as order_count from
[dbo].[pizzas] join [dbo].[order_details] 
on [dbo].[pizzas].pizza_id=[dbo].[order_details].pizza_id
group by [dbo].[pizzas].size order by order_count desc 

--list the top 5 most ordered pizza size types along with their quantities.
select top 5 [dbo].[pizza_types].name,sum([dbo].[order_details].quantity)as quantity from
[dbo].[pizza_types] join [dbo].[pizzas] 
on [dbo].[pizza_types].pizza_type_id=[dbo].[pizzas].pizza_type_id
join [dbo].[order_details] on [dbo].[order_details].pizza_id=[dbo].[pizzas].pizza_id
group by [dbo].[pizza_types].name order by quantity desc 


--join necessary tables to find the total quantity of each pizza category ordered
select  [dbo].[pizza_types].category,sum([dbo].[order_details].quantity) as quantity from
        [dbo].[pizza_types] join [dbo].[pizzas]
on [dbo].[pizza_types].pizza_type_id=[dbo].[pizzas].pizza_type_id
join [dbo].[order_details] on [dbo].[order_details].pizza_id=[dbo].[pizzas].pizza_id
group by [dbo].[pizza_types].category order by quantity desc

--detemine the distribution of orders by hours of the day.
select datepart(hh,time)as hour, count(order_id)as order_by_hours from  [dbo].[orders]
group by datepart(hh,time) order by hour asc

--join relevant tables to find the category wise distribution of pizzas.
select  count([dbo].[pizza_types].name)as count ,[dbo].[pizza_types].category as category from [dbo].[pizza_types]
group by category 

--group the orders by date and calculate the avg no of pizza ordered per day.
select avg(sum(order_details.quantity) from 
(select [dbo].[orders].date ,sum(order_details.quantity) from [dbo].[orders]
join [dbo].[order_details] on [dbo].[orders].order_id = [dbo].[order_details].order_id
group by [dbo].[orders].date));

--determine the top 3 most ordered pizza types based on revenue 

select top 3 [dbo].[pizza_types].name, sum([dbo].[order_details].quantity *[dbo].[pizzas].price) as revenue from [dbo].[pizza_types]
join [dbo].[pizzas]  on  [dbo].[pizzas].pizza_type_id= [dbo].[pizza_types].pizza_type_id
join [dbo].[order_details] on [dbo].[order_details].pizza_id= [dbo].[pizzas].pizza_id
group by [dbo].[pizza_types].name order by revenue desc
 
 --calculate the percentage contribution of each pizza type to total revenue.

 select [dbo].[pizza_types].category, sum ([dbo].[order_details].quantity *[dbo].[pizzas].price )/(select round(sum([dbo].[order_details].quantity * [dbo].[pizzas].price),2) as total_revenue
from [dbo].[order_details] join [dbo].[pizzas] 
on [dbo].[pizzas].pizza_id =[dbo].[order_details].pizza_id)*100
 from [dbo].[pizza_types] join [dbo].[pizzas] on [dbo].[pizzas].pizza_type_id=[dbo].[pizza_types].pizza_type_id
 join [dbo].[order_details] on [dbo].[order_details].pizza_id= [dbo].[pizzas].pizza_id
 group by [dbo].[pizza_types].category

 --analyze the cumulative revenue generated overtime 
select [dbo].[orders].date,sum(revenue) over(order by [dbo].[orders].date) as cum_revenue 
from
(select [dbo].[orders].date,sum([dbo].[order_details].quantity *[dbo].[pizzas].price) as revenue from [dbo].[order_details]
join [dbo].[pizzas] on [dbo].[order_details].pizza_id= pizzas.pizza_id
join [dbo].[orders] on [dbo].[orders].order_id= [dbo].[order_details].order_id
group by [dbo].[orders].date )