with hosts as (

  select * from {{ ref('base_rental_properties__hosts') }}

)

select * from hosts