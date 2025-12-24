with fct_listing_bookings as (

  select * from dbt_dev_marts.fct_listing_bookings

),

dim_listing_booking as (

  select * from dbt_dev_marts.dim_listing_bookings

),

dim_listings as (

  select * from dbt_dev_marts.dim_listings

),

prices_to_columns as (

  select
    listing_id,
    neighborhood,
    max(price_per_night) filter (where booking_date = '2021-07-12') as price_2021_07_12,
    max(price_per_night) filter (where booking_date = '2022-07-11') as price_2022_07_11

  from fct_listing_bookings
  left join dim_listing_booking using (listing_booking_id)
  left join dim_listings using (listing_id)
  where booking_date in ('2021-07-12','2022-07-11')
  group by 1,2

),

price_evolution_by_listing as (

  select
    *,

    (price_2022_07_11 - price_2021_07_12) as price_variation,
    ((price_2022_07_11 - price_2021_07_12)/price_2021_07_12)*100 as price_variation_perc

  from prices_to_columns

)

select
  neighborhood,
  avg(price_variation) as average_price_variation,
  avg(price_variation_perc) as average_price_variation_perc

from price_evolution_by_listing
group by 1