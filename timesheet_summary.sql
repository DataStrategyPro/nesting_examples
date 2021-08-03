/*
t1. Count the number of days (n_days) between the current and previous record for each employee
t2. Find the first date in the series (n_days is null or n_days > 1)
t3. Create grouping column 
t4. Grab first start date from the group
t5. Grab max end date for teach group
 6. Add row number per group
*/
with t1 as (
select *, 
start_date - lag(start_date) over(partition by empid order by start_date) as n_days
from timesheets
), 
t2 as (
select *, 
case when (n_days is null or n_days > 1) then start_Date else null end as is_first_date
from t1
),t3 as 
(
select *,
count(is_first_date) over(order by empid,start_date) as grp
from t2
), t4 as (
select *,
first_value(start_date) over (partition by grp order by empid, start_date) as first_date
from t3
), t5 as (
select empid, first_date, max(end_date) as last_date
from t4
group by empid, first_date
)
select *,
row_number() over (partition by empid) as n
from t5
