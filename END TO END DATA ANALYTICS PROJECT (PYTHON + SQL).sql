--Find top 10 revenue generating products
select top 10 product_id,sum(selling_price) as sales from orders_etl  group by product_id order by sales desc


--Find top 5 highest selling products in each region
with ref as (
select region,product_id,sum(selling_price) as sales, 
ROW_NUMBER() over(partition by region order by sum(selling_price) desc) as rnk
from orders_etl  group by region,product_id)
select * from ref where rnk<6

--Find month over month growth comparisio for 2022 and 2023 sales
with ref as(
select sum(sales) as s, 
format(order_date,'MMM') as m, --Month name
month(order_date) as mn,  --Month number
format(order_date,'yyyy') as y --Year seperation
from orders_etl group by format(order_date,'MMM'),format(order_date,'yyyy'),month(order_date)
)
select m as Month,
round(sum(Case when y='2022' then s else 0 end),0) as '2022',
round(sum(Case when y='2023' then s else 0 end),0) as '2023'
from ref group by m,mn order by month(mn)


--Find month with highest sales for each category
with cte as (
select category,format(order_date, 'MMM') as mo,month(order_date) as mn,sum(sales) as sales,
Row_Number() over(Partition by category order by sum(sales) desc) as rnk
from orders_etl
group by category,format(order_date, 'MMM') ,month(order_date) 
)
select category,mo,sales from cte where rnk=12