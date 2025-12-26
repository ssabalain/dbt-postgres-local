with source as (

  select * from {{ ref('AMENITIES_CHANGELOG') }}

),

renamed as (

  select
    {{ dbt_utils.generate_surrogate_key([
        'listing_id',
        'change_at'
    ]) }} as amenities_change_id,

    listing_id,
    cast(change_at as date) as amenities_changed_date,

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
  ) as amenities_list

  from source

)

select * from renamed