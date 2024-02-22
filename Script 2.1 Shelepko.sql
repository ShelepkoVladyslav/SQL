-- CALCULATING CPC,CPM,CTR,ROMI

-- 1-Step is to find these metrics: sum_spend, impressions, clicks, avg_value
-- 2-Step is aggregation of CPC,CPM,CTR,ROMI basing on metrics 
--        that have been found at first step

-- Query:

select ad_date, adset_id,
sum(spend) as sum_spend,
sum (impressions) as impressions_, 
sum (clicks) as clicks_,
avg(value) as avg_value,
sum (clicks) / sum(spend) :: decimal as CPC,
100 * sum(spend) / sum (impressions)  as CPM,
sum (clicks) / sum (impressions) :: decimal  as CTR,
(avg(value) - sum(spend)) / sum(spend) :: decimal as ROMI
from facebook_ads_basic_daily
where spend > 0 and impressions > 0
group by ad_date, adset_id 

