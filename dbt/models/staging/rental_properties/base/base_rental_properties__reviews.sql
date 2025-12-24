with source as (

  select * from {{ ref('GENERATED_REVIEWS') }}

),

renamed as (

  select
    id as review_id,
    listing_id,
    cast(review_date as date) as review_date,
    cast(review_score as int) as review_score

  from source

)

select * from renamed