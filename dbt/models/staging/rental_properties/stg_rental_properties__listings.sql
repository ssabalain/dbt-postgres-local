with listings as (

  select * from {{ ref('base_rental_properties__listings') }}

)

select * from listings