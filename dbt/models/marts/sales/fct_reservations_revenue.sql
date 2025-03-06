with reservations as (

  select * from {{ ref('int_reservations') }}

)

select
  listing_reservation_id,
  average_price_per_night,
  total_nights,
  total_revenue

from reservations