with reviews as (

  select * from {{ ref('base_rental_properties__reviews') }}

)

select * from reviews