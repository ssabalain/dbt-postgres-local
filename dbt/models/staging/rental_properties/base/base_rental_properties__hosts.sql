with source as (

  select * from {{ ref('listings') }}

),

renamed as (

  select
    host_id,
    host_name,
    host_since,
    host_location,
    string_to_array(regexp_replace(host_verifications, '[\"\[\]]', '', 'g'),',') as host_verifications_list

  from source
  group by 1,2,3,4,5

)

select * from renamed