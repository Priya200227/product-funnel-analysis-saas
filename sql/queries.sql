-- FUNNEL CONVERSION QUERY
with funnel as (
		select
		count(distinct case when event_name = 'visit' then user_id end) as visitors,
		count(distinct case when event_name = 'signup' then user_id end) as signups,
		count(distinct case when event_name = 'trial_start' then user_id end) as trials,
		count(distinct case when event_name = 'subscription' then user_id end) as paid
		from events
)
select visitors,
	   signups,
	   trials,
	   paid,
round(signups * 100.0 / visitors,2) as visit_to_signup_rate,
round(trials * 100.0 / signups,2) as signup_to_trial_rate,
round(paid * 100.0 / trials,2) as trial_to_paid_rate
from funnel;


-- SIGNUP CONVERSION BY TRAFFIC SOURCE
select u.traffic_source,
	   count(distinct case when e.event_name = 'visit' then e.user_id end) as visitors,
	   count(distinct case when e.event_name = 'signup' then e.user_id end) as signups,
	   round(
				count(distinct case when e.event_name = 'signup' then e.user_id end)
				* 100.0 /
				count(distinct case when e.event_name = 'visit' then e.user_id end)
			,2) as visit_to_signup_rate
from events e
join users u
on e.user_id = u.user_id
group by u.traffic_source
order by visit_to_signup_rate desc;


-- CONVERSION BY DEVICE TYPE
select u.device_type,
		count(distinct case when e.event_name = 'visit' then e.user_id end) as visitors,
		count(distinct case when e.event_name = 'signup' then e.user_id end) as signups,
		round(
				count(distinct case when e.event_name = 'signup' then e.user_id end)
				* 100.0 /
				count(distinct case when e.event_name = 'visit' then e.user_id end)
			,2) as visit_to_signup_rate
from events e
join users u
on e.user_id = u.user_id
group by u.device_type
order by visit_to_signup_rate desc;


-- MONTHLY FUNNEL TRENDS
select date_format(event_time,'%Y-%m') as monthly,
	   count(distinct case when event_name = 'visit' then user_id end) as visitors,
	   count(distinct case when event_name = 'signup' then user_id end) as signups,
	   count(distinct case when event_name = 'trial_start' then user_id end) as trials,
       count(distinct case when event_name = 'subscription' then user_id end) as paid
from events
group by monthly
order by monthly;