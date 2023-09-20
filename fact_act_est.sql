
--- create a new table contains both actuals and forecast

create table fact_act_est
(
SELECT 
	s.date as date,
    s.fiscal_year as fiscal_year,
    s.product_code as product_code,
    s.customer_code as customer_code,
    s.sold_quantity as sold_quantity,
	f.forecast_quantity as forecast_quantity
FROM fact_sales_monthly s
left join fact_forecast_monthly f 
using (date, customer_code, product_code)

union

SELECT 
	f.date as date,
    f.fiscal_year as fiscal_year,
    f.product_code as product_code,
    f.customer_code as customer_code,
    s.sold_quantity as sold_quantity,
	f.forecast_quantity as forecast_quantity
FROM fact_forecast_monthly f
left join fact_sales_monthly s
using (date, customer_code, product_code)
);

SELECT * FROM gdb0041.fact_act_est;


update gdb0041.fact_act_est 
set sold_quantity = 0
where sold_quantity is null;

update gdb0041.fact_act_est 
set forecast_quantity = 0
where forecast_quantity is null;

-- findout the Net Error and Absolute Net error ---
with cte1 as (
select 
	s.customer_code,
    sum((forecast_quantity - sold_quantity)) as net_err,
    sum((forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as net_err_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_net_err,
    sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as abs_err_pct
from fact_act_est s 
where s.fiscal_year = 2021
group by s.customer_code
)
select 
	e.*,
    c.customer,
    c.market,
    if(abs_err_pct > 100, 0, (100-abs_err_pct)) as forecast_accuracy
from cte1 e 
join dim_customer c 
using(customer_code)
order by forecast_accuracy desc;

--- create temporary tables - only works for this session --
create temporary table cte1
select 
	s.customer_code,
    sum((forecast_quantity - sold_quantity)) as net_err,
    sum((forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as net_err_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_net_err,
    sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity) as abs_err_pct
from fact_act_est s 
where s.fiscal_year = 2021
group by s.customer_code;