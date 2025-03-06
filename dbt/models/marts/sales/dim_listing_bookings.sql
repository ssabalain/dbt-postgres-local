with listing_bookings as (

  select * from {{ ref('stg_rental_properties__listing_bookings') }}

),

largest_booking_possible as (

  select * from {{ ref('int_largest_booking_possible_by_listing_booking') }}

),

amenities as (

  select * from {{ ref('int_amenities_by_listing_booking') }}

)

select
  listing_bookings.listing_booking_id,
  listing_bookings.listing_id,
  listing_bookings.reservation_id,
  listing_bookings.minimum_nights,
  listing_bookings.maximum_nights,

  largest_booking_possible.largest_booking_possible_on_date,

  {{ dbt_utils.star(
      from=ref('int_amenities_by_listing_booking'),
      except=['listing_booking_id']
  ) }}

from listing_bookings
left join largest_booking_possible using (listing_booking_id)
left join amenities using (listing_booking_id)