with source as (

  select * from {{ ref('CALENDAR') }}

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

, ranked_calendar as (

  select
    *,

    row_number() over(
      partition by listing_booking_id
      order by reservation_id asc
    ) as dedup_ranking

  from renamed

)

select * from ranked_calendar
where dedup_ranking = 1