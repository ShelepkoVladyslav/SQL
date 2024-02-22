-- JOINING, UNIONING AND AGGREGATING GOOGLE AND FACEBOOK DATA ON LEVEL OF THE CAMPAIGNS
-- WITH DIFFERENCE OF CTR,CPM,ROMI TO THE PREVIOUS MONTH

-- We have four different tables: 1 relates to google's campaigns and other 3 to facebook's campaigns
-- 1-Step Joining and unioning tables related to the facebook and google into one table
-- 2-Step Extraction the piece of utm_campaign from url_parameters
-- 3-Step Aggregation of spends of campaigns, impressions, clicks and average conversion rate
-- 4-Step Aggregation of CPC,CPM,CTR,ROMI 
-- 5-Step Result of CTR,CPM,ROMI in percentages to the previous month using window function LAG
-- RESULT: We have data of google and facebook campaigns in the solid dataset that contains 
--         metrics about spends of campaigns, impressions, clicks and average conversion rate
--         that are grouped by utm_campaign name with CPC,CPM,CTR,ROMI for each campaign and 
--         results of CTR,CPM,ROMI in percentages to the previous month


with j_ads_basic_daily as (
select ad_date, adset_name, campaign_name, url_parameters, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily fabd 
join facebook_campaign fc on fc.campaign_id = fabd.campaign_id
join facebook_adset fa on fa.adset_id = fabd.adset_id
union 
select ad_date, adset_name, campaign_name, url_parameters, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily gabd
), 
j2_ads_basic_daily as(
select 
extract('month' from ad_date) as ad_month,
lower(substring(url_parameters, 'utm_campaign=([\W\w]+)')) as utm_campaign,
sum(spend) as sum_spend,
sum(impressions) as sum_impressions,
sum(clicks) as sum_clicks,
round(avg(value), 4) as avg_value,
round(sum (clicks) / sum (impressions) :: decimal, 4) as ctr,
sum(spend) / sum(clicks) as cpc,
sum(spend) / sum(clicks) * 100 as cpm,
round((avg(value) - sum(spend)) / sum(spend), 4) as romi
from j_ads_basic_daily
where impressions > 0 and clicks > 0 and spend > 0
group by  extract('month' from ad_date), lower(substring(url_parameters, 'utm_campaign=([\W\w]+)'))
)
select 
ad_month,
utm_campaign,
sum_spend,
sum_impressions,
sum_clicks,
avg_value,
ctr,
round((ctr - (lag(ctr, 1) over (partition by utm_campaign order by ad_month))) / (lag(ctr, 1) over (partition by utm_campaign order by ad_month)) :: decimal * 100, 4)  as lag_ctr_percent,
cpc,
cpm,
round((cpm - (lag(cpm, 1) over (partition by utm_campaign order by ad_month))) / (lag(cpm, 1) over (partition by utm_campaign order by ad_month)) :: decimal * 100, 4)  as lag_cpm_percent,
romi,
round((romi - (lag(romi, 1) over (partition by utm_campaign order by ad_month))) / (lag(romi, 1) over (partition by utm_campaign order by ad_month)) :: decimal * 100, 4)  as lag_romi_percent
from j2_ads_basic_daily
where romi <> 0 and ctr <> 0
order by utm_campaign, ad_month

