with listing_bookings as (

  select * from {{ ref('stg_rental_properties__listing_bookings') }}

)

select
  listing_booking_id,
  booking_date,
  is_available,
  price_per_night,

  case
    when not is_available then price_per_night
    else 0
  end as revenue

from listing_bookings