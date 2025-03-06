with listing_bookings as (

  select * from {{ ref('stg_rental_properties__listing_bookings') }}

),

reservations as (

  select
    {{ dbt_utils.generate_surrogate_key([
        'reservation_id',
        'listing_id'
    ]) }} as listing_reservation_id,

    reservation_id,
    listing_id,

    min(calendar_date) as reservation_start_date,
    max(calendar_date) + 1 as reservation_end_date,
    count(*) as total_nights,
    sum(price_per_night) as total_revenue,
    avg(price_per_night) as average_price_per_night

  from listing_bookings
  where reservation_id is not null
  group by 1,2,3

)

select * from reservations