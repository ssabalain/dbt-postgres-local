with source as (

  select * from {{ ref('calendar') }}

),

renamed as (

  select
    {{ dbt_utils.generate_surrogate_key([
        'listing_id',
        'date'
    ]) }} as listing_bookings_id,

    listing_id,
    cast(date as date) as calendar_date,

    case
      when available = 'f' then false
      when available = 't' then true
    end as is_available,

    reservation_id,
    cast(price as float) as price_per_night,
    minimum_nights,
    maximum_nights

  from source

)

select * from renamed