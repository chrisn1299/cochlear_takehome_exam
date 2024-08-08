-- data cleaning

-- VOLUME: create a table that reformats fiscal_period and aggregate 
-- so that final PK = (fiscal_date, part_number)
create or replace table `cochlear-technical-challenge.manufacturing.aggregated_volume` as 
with volume_fiscal_period_adj as (
  select 
    fiscal_year,
    fiscal_period,
    fiscal_week,
    date(fiscal_date) as fiscal_date,
    part_number, 
    completed_qty,
    case when return_qty  < 0 then return_qty*-1 else return_qty end as return_qty,
    case when scrap_qty < 0 then scrap_qty*-1 else scrap_qty end as scrap_qty,
    PARSE_DATE('%b-%y', fiscal_period) AS fiscal_period_start_date
  from `cochlear-technical-challenge.manufacturing.stg_volume`
)
select 
  fiscal_year,
  fiscal_period_start_date,
  fiscal_week,
  fiscal_date,
  part_number, 
  sum(completed_qty) as day_part_total_completed_qty,
  sum(return_qty) as day_part_total_return_qty ,
  sum(scrap_qty) as day_part_total_scrap_qty,
from volume_fiscal_period_adj
group by 
  fiscal_year,
  fiscal_period_start_date,
  fiscal_week,
  fiscal_date,
  part_number
;
-- check that each record is unique
select 
count(*),
count(distinct concat(fiscal_date, part_number)) as haha_
from `cochlear-technical-challenge.manufacturing.aggregated_volume`
;

-- HOURS
-- aggregate so that PK = (fiscal_date, part_number, team)
-- change fiscal period name to fiscal_period_start_date
-- standardize team name
-- fix negative hours_charged
create or replace table `cochlear-technical-challenge.manufacturing.aggregated_hours` as 
with volume_fiscal_period_adj as (
  select 
    fiscal_year,
    date(fiscal_period) as fiscal_period_start_date,
    fiscal_week,
    date(fiscal_date) as fiscal_date,
    replace(team, '-', '_') as team_id,
    part_number, 
    case when hours_charged < 0 then 0 else hours_charged end as hours_charged
  from `cochlear-technical-challenge.manufacturing.stg_hours`
)
select 
  fiscal_year,
  fiscal_period_start_date,
  fiscal_week,
  fiscal_date,
  team_id,
  part_number, 
  sum(hours_charged) as day_part_team_total_hours_charged
from volume_fiscal_period_adj
group by 
  fiscal_year,
  fiscal_period_start_date,
  fiscal_week,
  fiscal_date,
  part_number,
  team_id
;
select count(*), count(distinct concat(fiscal_date, part_number, team_id)) as haha_
from `cochlear-technical-challenge.manufacturing.aggregated_hours` 
;

-- create a final table
-- fiscal year, week, period, date, team_id, part_number, total_day_part number (completed, return, scrap qty)
-- left join hours with volume since our stakeholders are managers
create or replace table `cochlear-technical-challenge.manufacturing.final_table` as 
select 
ah.fiscal_year,
ah.fiscal_period_start_date,
ah.fiscal_week, 
ah.fiscal_date,
ah.team_id,
ah.part_number, 
ah.day_part_team_total_hours_charged,
av.day_part_total_completed_qty,
av.day_part_total_return_qty,
av.day_part_total_scrap_qty
from `cochlear-technical-challenge.manufacturing.aggregated_hours` ah 
left join `cochlear-technical-challenge.manufacturing.aggregated_volume` av 
on ah.part_number = av.part_number
and ah.fiscal_date = av.fiscal_date
;
select count(*) from `cochlear-technical-challenge.manufacturing.final_table`
;


-- delete all finished tables once done
drop table `cochlear-technical-challenge.manufacturing.stg_hours`;
drop table `cochlear-technical-challenge.manufacturing.stg_volume`;
drop table `cochlear-technical-challenge.manufacturing.aggregated_volume`;
drop table `cochlear-technical-challenge.manufacturing.aggregated_hours`;