{{ config(materialized = 'view') }}

with amenities_changes as (

  select * from {{ ref('stg_rental_properties__amenities_changes') }}

),

latest_amenity_update_by_listing as (

  select
    listing_id,

    max(amenities_changed_date) as latest_amenities_update

  from amenities_changes
  group by 1

),

amenities_by_listing as (

  select
    listing_id,
    amenities_changed_date,
    trim(cast(value as string)) as amenity

  from amenities_changes
  left join lateral flatten(input => amenities_list)

),

amenity_by_listing_by_date_cross_combinations as (

  select
    amenities_changes.listing_id,
    amenities_changes.amenities_changed_date,
    amenities_by_listing.amenity

  from amenities_changes
  cross join amenities_by_listing
  where amenities_changes.listing_id = amenities_by_listing.listing_id
    and amenities_changes.amenities_changed_date >= amenities_by_listing.amenities_changed_date
  group by 1,2,3

),

amenity_by_listing_by_date_group_change as (

  select
    amenity_by_listing_by_date_cross_combinations.listing_id,
    amenity_by_listing_by_date_cross_combinations.amenities_changed_date,
    amenity_by_listing_by_date_cross_combinations.amenity,

    case
      when amenity_by_listing_by_date_cross_combinations.amenity = coalesce(amenities_by_listing.amenity,'x') then 0
      else 1
    end as group_change_flag

  from amenity_by_listing_by_date_cross_combinations
  left join amenities_by_listing using(listing_id,amenities_changed_date,amenity)

),

amenity_by_listing_by_date_groups as (

  select
    listing_id,
    amenities_changed_date,
    amenity,

    sum(group_change_flag) over(
      partition by listing_id, amenity
      order by amenities_changed_date
      rows between unbounded preceding and current row
    ) as group_id

  from amenity_by_listing_by_date_group_change

),

amenity_by_listing_groups as (

  select
    listing_id,
    amenity,
    group_id,
    min(amenities_changed_date) as min_amenity_change_date,
    max(amenities_changed_date) as max_amenity_change_date

  from amenity_by_listing_by_date_groups
  group by 1,2,3

)

select
  listing_id,
  amenity,
  replace(lower(amenity),' ','_') as amenity_sc,
  min_amenity_change_date as amenity_available_since,

  case
    when max_amenity_change_date = latest_amenity_update_by_listing.latest_amenities_update then '2099-10-31'
    else max_amenity_change_date
  end as amenity_available_until

from amenity_by_listing_groups
left join latest_amenity_update_by_listing using (listing_id)