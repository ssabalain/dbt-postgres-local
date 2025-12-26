with source as (

  select * from {{ ref('LISTINGS') }}

),

renamed as (

  select
    host_id,
    host_name,
    host_since,
    host_location,
    --to_array(regexp_replace(host_verifications, '[\"\[\]]', '', 'g'),',') as host_verifications_list

  from source
  group by 1,2,3,4

)

select * from renamed