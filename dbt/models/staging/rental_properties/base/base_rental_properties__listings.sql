with source as (

  select * from {{ ref('LISTINGS') }}

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
    split(
        replace(
            replace(
                replace(
                    replace(amenities,'"','')
                    , '\n'
                    ,''
                )
                , '['
                , ''
            )
            , ']'
            , ''
        )
        , ','
    ) as amenities_list,
    cast(price as float) as listing_price,
    number_of_reviews,
    first_review,
    last_review,
    review_scores_rating

  from source
  where id is not null

)

select * from renamed