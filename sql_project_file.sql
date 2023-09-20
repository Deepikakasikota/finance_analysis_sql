
-- give the report of croma in india market for FY 2021 contains the following columns ---
-- Month
-- product name
-- varient
-- sold quantity
-- gross price per item
-- gross price total

-- findout the customer code of croma for india --
select * from dim_customer where customer like "%croma%" and market = "India";

-- select the transactions for fiscal year 2021 --
select 
	s.date, s.product_code, p.product, p.variant, 
	s.sold_quantity, g.gross_price,
	ROUND(g.gross_price*s.sold_quantity,2) as gross_price_total 
from fact_sales_monthly s
	join dim_product p on 
	s.product_code = p.product_code
	join fact_gross_price g on
	g.product_code = s.product_code and g.fiscal_year = get_fiscal_year(s.date)
where 	
	customer_code=90002002 and 
	get_fiscal_year(date) = 2021 and
	get_fiscal_quarter(date) = "Q3"
order by  date asc;

/* Aggeregate monthly gross sales report for croma in India --
	1. Month
    2. Total gross sales to croma india in this month  */
    
select 
	s.date, round(sum(g.gross_price*s.sold_quantity),2) as fact_sales_monthly
from 
	fact_sales_monthly s 
	join fact_gross_price g on
	g.product_code = s.product_code and
	g.fiscal_year = get_fiscal_year(s.date)
where 
	customer_code = 90002002 
group by s.date
order by s.date asc;

/* ------------------------------ Exercise --------------------------------------
Generate a yearly report for Croma India where there are two columns
	1. Fiscal Year
	2. Total Gross Sales amount In that year from Croma */
    
select 
	year(s.date) as fiscal_year, 
    round(sum(g.gross_price*s.sold_quantity),2) as yearly_sales
from 
    fact_sales_monthly s
    join fact_gross_price g 
    on g.product_code = s.product_code and
    g.fiscal_year = get_fiscal_year(s.date)
where 
	customer_code = 90002002 
group by fiscal_year
order by fiscal_year;

select * from dim_customer where customer like "%amazon%" and market = "India";
-- 90002016,90002008

/* create a stored procedure can determine the market badgeon the following logic --
 if "tottal sold quantity" > "5 million" that market is considered as "Gold" else it is "Silver".
 
	Inputs :
		1. market
        2. fiscal_year
	Output :
		Market Badge             */
        
select 
	c.market, sum(s.sold_quantity) as total_qty
from fact_sales_monthly s 
	join dim_customer c  on
    c.customer_code = s.customer_code	
where 
	get_fiscal_year(s.date) = 2021 and c.market = "India"
    group by c.market;
    
---- we have to write 
--- 	top markets
--- 	top products
--- 	top customers

---- get net sales 

--- first we have to get the pre invoice sales
with cte1 as (
select 
	s.date, s.product_code, p.product, p.variant, 
	s.sold_quantity, g.gross_price as gross_price_per_item,
    round(sum(g.gross_price*s.sold_quantity),2) as gross_price_total,
    pre.pre_invoice_discount_pct
from 
	fact_sales_monthly s 
	join dim_product p
		on s.product_code = p.product_code
    join fact_gross_price as g 
		on g.product_code = s.product_code and
	    g.fiscal_year = s.fiscal_year
    join fact_pre_invoice_deductions pre
		on pre.customer_code = s.customer_code and 
		pre.fiscal_year = s.fiscal_year
where 
    s.fiscal_year = 2021
    group by s.date
)
select 
	*, (gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales
 from cte1;
 
 --- use created view to generate the same result as net invoice sales --
 
 select *, (gross_price_total - gross_price_total*pre_invoice_discount_pct) as net_invoice_sales
 from sales_pre_invoice_discount;
 
 --- post_invoice discount --
 
 select 
	*, (1-pre_invoice_discount_pct) as gross_price_total,
    (y.discounts_pct+y.other_deductions_pct) as post_invoice_discount_pct
from sales_pre_invoice_discount x
join fact_post_invoice_deductions y
on x.date = y.date and
x.product_code = y.product_code and
x.customer_code = y.customer_code;

--- we have created a view for post invoice sales to findout the net sales
select
	*, 
    (1-post_invoice_discount_pct)*net_invoice_sales as net_sales
from sales_postinv_discount;

---- generate top markets ---
select
	market,
    round(sum(net_sales)/1000000,2) as net_sales_mln
from gdb0041.net_sales
where fiscal_year = 2021
group by market
order by net_sales_mln desc
limit 5;