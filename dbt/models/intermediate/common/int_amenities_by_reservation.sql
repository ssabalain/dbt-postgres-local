{{ config(materialized = 'table') }}

with reservations as (

  select * from {{ ref('int_reservations') }}

),

amenities_changes as (

  select * from {{ ref('int_amenities_changes') }}

),

amenities_by_reservation as (

  select
    listing_reservation_id,

    amenities_changes.amenity_sc

  from reservations
  left join amenities_changes on reservations.listing_id = amenities_changes.listing_id
    and reservations.reservation_start_date between amenities_changes.amenity_available_since
      and amenities_changes.amenity_available_until

)

select
  listing_reservation_id,

  {{ dbt_utils.pivot(
      'amenity_sc',
      dbt_utils.get_column_values(ref('int_amenities_changes'), 'amenity_sc'),
      prefix='has_'
  ) }}

from amenities_by_reservation
group by 1