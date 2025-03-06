{{ config(materialized = 'table') }}

with listing_bookings as (

  select * from {{ ref('stg_rental_properties__listing_bookings') }}

),

amenities_changes as (

  select * from {{ ref('int_amenities_changes') }}

),

amenities_by_listing_booking as (

  select
    listing_booking_id,

    amenities_changes.amenity_sc

  from listing_bookings
  left join amenities_changes on listing_bookings.listing_id = amenities_changes.listing_id
    and listing_bookings.booking_date between amenities_changes.amenity_available_since
      and amenities_changes.amenity_available_until

)

select
  listing_booking_id,

  {{ dbt_utils.pivot(
      'amenity_sc',
      dbt_utils.get_column_values(ref('int_amenities_changes'), 'amenity_sc'),
      prefix='has_'
  ) }}

from amenities_by_listing_booking
group by 1