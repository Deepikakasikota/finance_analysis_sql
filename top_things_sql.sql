---- generate top markets ---
select 
	market,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb0041.net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln desc
limit 5;

---- generate top customers and their net sales percentage ---
with cte1 as (
select 
	customer,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb0041.net_sales n
join dim_customer c
on c.customer_code = n.customer_code
where fiscal_year = 2021
group by customer)
select 
	customer, 
    net_sales_mln*100/sum(net_sales_mln) over() as net_sales_pct
    from cte1
order by net_sales_mln desc
;

---- generate top products ---
select 
	product,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb0041.net_sales
where fiscal_year = 2021
group by product
order by net_sales_mln desc
limit 5;

--- findout the net sales percentage by regions --
with cte1 as (
select 
	c.customer,
    c.region,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb0041.net_sales n
join dim_customer c
on c.customer_code = n.customer_code
where fiscal_year = 2021
group by c.customer, c.region
)
select *,
	net_sales_mln*100/sum(net_sales_mln) over(partition by region) as pct_over_region
from cte1
order by region, net_sales_mln desc;

-- print top n products with their sold quantity --
with cte1 as (
select 
	p.product,
    p.division,
    sum(sold_quantity) as total_qty
from fact_sales_monthly s 
join dim_product p 
on s.product_code = p.product_code
where fiscal_year = 2021
group by p.product
),
cte2 as (
select *, 
	dense_rank() over(partition by division order by total_qty desc) as dnk
 from cte1)
select * from cte2 where dnk <= 3;

-- Retrivet the Top 2 markets in every region by their gross_sales_amount for FY - 2021 --
with cte1 as (
select
	c.market,
    c.region,
    round(sum(gross_price_total)/1000000,2) as gross_sales_mln
from gdb0041.gross_sales s 
join dim_customer c 
on c.customer_code = s.customer_code
where fiscal_year = 2021
group by market
order by gross_sales_mln desc
),
cte2 as (
select 
	* ,
    dense_rank() over(partition by region order by gross_sales_mln desc) rnk
from cte1)
select * from cte2 where rnk<=2;