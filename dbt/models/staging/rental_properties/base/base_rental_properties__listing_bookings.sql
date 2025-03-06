with source as (

  select * from {{ ref('calendar') }}

),

renamed as (

  select
    {{ dbt_utils.generate_surrogate_key([
        'listing_id',
        'date'
    ]) }} as listing_booking_id,

    listing_id,
    reservation_id,
    minimum_nights,
    maximum_nights,

    cast(date as date) as booking_date,
    cast(price as float) as price_per_night,

    case
      when available = 'f' then false
      when available = 't' then true
    end as is_available

  from source

)

select * from renamed