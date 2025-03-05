with source as (

  select * from {{ ref('listings') }}

),

renamed as (

  select
    id as listing_id,
    name as listing_name,
    host_id,
    neighborhood,
    property_type,
    room_type,
    accommodates,
    bathrooms_text,
    bedrooms,
    beds,
    string_to_array(regexp_replace(amenities, '[\"\[\]]', '', 'g'),',') as amenities_list,
    cast(price as float) as listing_price,
    number_of_reviews,
    first_review,
    last_review,
    review_scores_rating

  from source

)

select * from renamed