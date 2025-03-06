with reservations as (

  select * from {{ ref('int_reservations') }}

),

amenities_by_reservation as (

  select * from {{ ref('int_amenities_by_reservation') }}

)

select
  reservations.listing_reservation_id,
  reservations.reservation_id,
  reservations.listing_id,
  reservations.reservation_start_date,
  reservations.reservation_end_date,

  {{ dbt_utils.star(
      from=ref('int_amenities_by_reservation'),
      except=['listing_reservation_id','reservation_id', 'listing_id']
  ) }}


from reservations
left join amenities_by_reservation using (listing_reservation_id)