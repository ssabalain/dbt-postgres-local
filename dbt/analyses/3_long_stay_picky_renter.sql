with fct_listing_bookings as (

  select * from dbt_dev_marts.fct_listing_bookings

),

dim_listing_booking as (

  select * from dbt_dev_marts.dim_listing_bookings

)

--A
select
  listing_id,
  max(coalesce(largest_booking_possible_on_date,0)) as largest_booking_possible

from fct_listing_bookings
left join dim_listing_booking using (listing_booking_id)
--Uncomment for solution B
--where dim_listing_booking.has_lockbox = 1
--  and has_first_aid_kit = 1
group by 1
order by 2 desc