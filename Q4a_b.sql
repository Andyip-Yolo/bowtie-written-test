Q4a
with Year_2021 as (
select id,policy_number,submit_date from claim.csv 
where year(submit_date)='2021')

select count(all.id),pdt.product from Year_2021 all
left join policy.csv pdt
on all.policy_number=pdt.policy
group by product

Q4b
with paid as
(
select 
policy_number,
pre_levy_amount
from invoice.csv
where stats = 'paid'
),
user_paid as 
(
select 
count(policy_number) as no_of_policy,
sum(pre_levy_amount) as user_total_amount,
user_id 
from policy.csv user
left join paid
on user.policy_number=paid.policy_number
group by user_id
),
new_return as 
(
select 
case when no_of_policy>=2 then 'Returning' else 'New' end as user_type,
total_amount,
no_of_policy
from user_paid
)

select user_type,
avg(
total_amount / no_of_policy
) as average net premium received
from new_return
group by user_type 
