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
