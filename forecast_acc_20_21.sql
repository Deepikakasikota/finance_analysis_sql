call gdb0041.get_forecast_accuracy(2020);

select  cte1.abs_err_pct from cte1;

/* -- write the query for the following
The supply chain business manager wants to see which customers’ forecast accuracy 
has dropped from 2020 to 2021. Provide a complete report with these columns: 
customer_code, customer_name, market, forecast_accuracy_2020, forecast_accuracy_2021 */

drop table if exists forecast_accuracy_2021;
create temporary table forecast_accuracy_2021
with cte1 as (
select 
	s.customer_code as customer_code,
    c.customer as customer_name,
    c.market as market,
    sum(s.sold_quantity) as total_sold_quantity,
    sum(s.forecast_quantity) as total_forecast_quantity,
    sum((forecast_quantity - sold_quantity)) as net_err,
   round(sum((forecast_quantity - sold_quantity))*100/sum(forecast_quantity),2) as net_err_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_net_err,
    round(sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity),2) as abs_err_pct
from fact_act_est s 
join dim_customer c 
on c.customer_code = s.customer_code
where s.fiscal_year = 2021
group by customer_code
)
select 
	*,
    if(abs_err_pct > 100, 0, (100.0 - abs_err_pct)) as forecast_accuracy
from cte1 
order by forecast_accuracy desc;

drop table if exists forecast_accuracy_2020;
create temporary table forecast_accuracy_2020
with cte1 as (
select 
	s.customer_code as customer_code,
    c.customer as customer_name,
    c.market as market,
    sum(s.sold_quantity) as total_sold_quantity,
    sum(s.forecast_quantity) as total_forecast_quantity,
    sum((forecast_quantity - sold_quantity)) as net_err,
   round(sum((forecast_quantity - sold_quantity))*100/sum(forecast_quantity),2) as net_err_pct,
    sum(abs(forecast_quantity - sold_quantity)) as abs_net_err,
    round(sum(abs(forecast_quantity - sold_quantity))*100/sum(forecast_quantity),2) as abs_err_pct
from fact_act_est s 
join dim_customer c 
on c.customer_code = s.customer_code
where s.fiscal_year = 2020
group by customer_code
)
select 
	*,
    if(abs_err_pct > 100, 0, (100.0 - abs_err_pct)) as forecast_accuracy
from cte1 
order by forecast_accuracy desc;

--- join two temporary tables --
select 
	f_20.customer_code,
    f_20.customer_name,
    f_20.market,
    f_20.forecast_accuracy as forecast_acc_20,
    f_21.forecast_accuracy as forecast_acc_21
from forecast_accuracy_2020 as f_20
join forecast_accuracy_2021 as f_21
on f_20.customer_code = f_21.customer_code 
where f_21.forecast_accuracy < f_20.forecast_accuracy
order by forecast_acc_20 desc;
