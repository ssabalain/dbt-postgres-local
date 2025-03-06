with calendar as (

  select * from {{ ref('base_rental_properties__listing_bookings') }}

)

select * from calendar