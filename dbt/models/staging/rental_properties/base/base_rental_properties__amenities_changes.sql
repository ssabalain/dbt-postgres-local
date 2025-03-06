with source as (

  select * from {{ ref('amenities_changelog') }}

),

renamed as (

  select
    {{ dbt_utils.generate_surrogate_key([
        'listing_id',
        'change_at'
    ]) }} as amenities_change_id,

    listing_id,
    cast(change_at as date) as amenities_changed_date,
    string_to_array(amenities,',') as amenities_list

  from source

)

select * from renamed