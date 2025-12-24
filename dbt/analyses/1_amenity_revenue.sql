with fct_listing_bookings as (

  select * from dbt_dev_marts.fct_listing_bookings

),

dim_listing_booking as (

  select * from dbt_dev_marts.dim_listing_bookings

),

monthly_revenue_by_ac as (

  select
    date_trunc('month',booking_date) as booking_month,
    sum(case when has_air_conditioning = 1 then revenue else 0 end) as ac_revenue,
    sum(case when has_air_conditioning = 0 then revenue else 0 end) as no_ac_revenue,
    sum(revenue) as total_revenue

  from fct_listing_bookings
  left join dim_listing_booking using (listing_booking_id)
  group by 1

)

select
  *,

  (ac_revenue/total_revenue) * 100 as ac_revenue_perc,
  (no_ac_revenue/total_revenue) * 100 as no_ac_revenue_perc

from monthly_revenue_by_ac
order by 1