-- JOINING AND UNIONING GOOGLE AND FACEBOOK TABLES

-- We have four different tables: 1 relates to google's campaigns and other 3 to facebook's campaigns
-- 1-Step Joining tables related to the facebook into one table
-- 2-Step Unioning the facebook data and google data
-- 3-Step Calculating spends of campaigns, impressions, clicks and average conversion rate
-- RESULT: We have data of google and facebook campaigns in the solid dataset that contains 
--         metrics about spends of campaigns, impressions, clicks and average conversion rate

with fb_joined as (
select ad_date, campaign_name, adset_name, spend, impressions, reach, clicks, leads, value 
from facebook_ads_basic_daily fabd
join facebook_campaign fc on fabd.campaign_id =  fc.campaign_id 
join facebook_adset fa on fabd.adset_id = fa.adset_id),
fb_goog_joined as (
select ad_date, campaign_name, adset_name, 'google' as source, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily
union 
select ad_date, campaign_name, adset_name, 'facebook' as source, spend, impressions, reach, clicks, leads, value
from fb_joined)
select ad_date, source, campaign_name, adset_name,
sum(spend) as _spend_,
sum(impressions) as _impressions_,
sum(clicks) as _clicks_,
avg(value) as avg_conversion_rate
from fb_goog_joined
group by ad_date, source, campaign_name, adset_name
