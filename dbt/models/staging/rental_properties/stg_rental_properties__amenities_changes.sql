with amenities_changes as (

  select * from {{ ref('base_rental_properties__amenities_changes') }}

)

select * from amenities_changes