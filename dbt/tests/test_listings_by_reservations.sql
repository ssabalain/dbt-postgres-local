{{ config(
  severity = 'warn',
  meta = {
        "description":
          "Checks that there are no more than 1 listing per reservation_id"
    }
  
) }}

with listing_bookings as (

  select * from {{ ref('stg_rental_properties__listing_bookings') }}

)

select
  reservation_id,
  count(distinct listing_id) as num_of_listings_by_booking

from listing_bookings
where reservation_id is not null
group by 1
having count(distinct listing_id) > 1