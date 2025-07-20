-- Step 1: Create a combined dataset from Facebook and Google Ads
WITH pivot_table AS (

  -- Facebook Ads data with JOINs for campaign and adset names
  WITH facebook_data AS (
    SELECT
      fb.ad_date,
      fc.campaign_name,
      fa.adset_name,
      fb.spend,
      fb.impressions,
      fb.reach,
      fb.clicks,
      fb.leads,
      fb.value,
      'facebook' AS media_source
    FROM facebook_ads_basic_daily fb
    LEFT JOIN facebook_campaign fc ON fb.campaign_id = fc.campaign_id
    LEFT JOIN facebook_adset fa ON fb.adset_id = fa.adset_id
  )

  -- Combine Facebook and Google Ads data into one table
  SELECT * FROM facebook_data

  UNION ALL

  SELECT
    ad_date,
    campaign_name,
    adset_name,
    spend,
    impressions,
    reach,
    clicks,
    leads,
    value,
    'google' AS media_source
  FROM google_ads_basic_daily
)

-- Step 2: Aggregate data by date, campaign, adset, and source
SELECT
  ad_date,
  campaign_name,
  adset_name,
  media_source,
  SUM(clicks) AS total_clicks,
  SUM(impressions) AS total_impressions,
  SUM(spend) AS total_spend,
  SUM(value) AS total_value
FROM pivot_table
GROUP BY ad_date, campaign_name, adset_name, media_source
ORDER BY ad_date;