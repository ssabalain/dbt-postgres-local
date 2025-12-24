with listing_bookings as (

  select * from {{ ref('stg_rental_properties__listing_bookings') }}

),

auxiliary_dates_fields as (

  select
    listing_booking_id,
    listing_id,
    booking_date,
    minimum_nights,
    maximum_nights,

    lead(booking_date) over(
      partition by listing_id
      order by booking_date
    ) as next_booking_date,

    lag(booking_date) over(
      partition by listing_id
      order by booking_date
    ) as previous_booking_date

  from listing_bookings
  where is_available

),

dates_chained_flags as (

  select
    *,

    case
      when booking_date + 1 = next_booking_date then true
      else false
    end as chained_to_next,

    case
      when booking_date - 1 = previous_booking_date then true
      else false
    end as chained_to_previous

  from auxiliary_dates_fields

),

dates_classification as (

  select
    *,

    case
      when chained_to_next and chained_to_previous then 'body'
      when chained_to_next and not chained_to_previous then 'start'
      when not chained_to_next and chained_to_previous then 'end'
      else 'isolated'
    end as classification

  from dates_chained_flags

),

slot_number_assignation as (

  select
    *,

    case
      when classification != 'isolated' then
        sum(
          case when classification = 'start' then 1 else 0 end
        )
        over (
          partition by listing_id
          order by booking_date asc
          rows between unbounded preceding and current row
        )
      else null
    end as slot_number

  from dates_classification

),

total_days_in_slot as (

  select
    *,

    count(*) over(
      partition by listing_id, slot_number
    ) as total_days_in_slot,

    row_number() over(
      partition by listing_id, slot_number
      order by booking_date desc
    ) as slot_days_remaining

  from slot_number_assignation

),

maximum_booking_available as (

  select
    *,

    case
      when slot_days_remaining > maximum_nights then maximum_nights
      when slot_days_remaining between minimum_nights and maximum_nights then slot_days_remaining
      else null
    end as largest_booking_possible_on_date

  from total_days_in_slot

)

select
  listing_booking_id,
  largest_booking_possible_on_date

from maximum_booking_available