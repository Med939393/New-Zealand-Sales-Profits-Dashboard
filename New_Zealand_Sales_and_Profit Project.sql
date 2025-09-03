SELECT * FROM sales;

select Order_ID, count(*) from sales group by 1 having count(*) > 1 ; 

with cte as (select * , row_number () over (partition  by Order_ID order by Order_Date ) as rn from sales )

select * from cte where  rn > 1  ; 

select Region , TRIM(Region) from sales  where TRIM(Region) > Region; 

select * from sales ; 

with cte as 
(select Order_Date,substring(Order_ID,4,LENGTH(Order_ID)) as order_id, Product,Category,Region,Sales,Profit,

sum(Sales) as total_sales , sum(Profit) as total_profits 

 from sales  group  by 1,2,3,4,5,6,7 order by 1 ) , cte1 as (
 
 select Order_Date, order_id,Product,Category,Region,Sales,Profit,total_sales,
 
 SUM(total_sales) over (order by Order_Date ) as moving_total_sales ,total_profits,
 sum(total_profits) over (order by Order_Date) as moving_total_profits ,
 
 lag(total_sales) over (order by Order_Date ) as previous_total_sales ,
 lag(total_profits)  over (order by Order_Date) as previous_total_profits,
 
 total_sales  - lag(total_sales) over (order by Order_Date ) as diff_sales  ,
 total_profits -  lag(total_profits)  over (order by Order_Date) as diff_profits
 from cte )
 select Order_Date, order_id,Product,Category,Region,Sales,Profit,total_sales,
moving_total_sales ,total_profits,moving_total_profits ,previous_total_sales ,previous_total_profits,diff_sales  ,diff_profits,

case when diff_sales > 0 then 'Increase'
     when diff_sales < 0 then 'Descrease'
	 else 'No change'
 end as sales_segmentation,
 
 case when diff_profits > 0 then 'Increase'
     when diff_profits < 0 then 'Descrease'
	 else 'No change'
 end as profits_segmentation
 
from cte1 ; 



