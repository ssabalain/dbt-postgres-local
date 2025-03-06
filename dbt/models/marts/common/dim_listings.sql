with listings as (

  select * from {{ ref('stg_rental_properties__listings') }}

)

select
  listing_id,
  listing_name,
  host_id,
  neighborhood,
  property_type,
  room_type,
  accommodates,
  bathrooms_text,
  bedrooms,
  beds,
  listing_price,
  number_of_reviews,
  first_review,
  last_review,
  review_scores_rating

from listings