with j_ads_basic_daily as (
select ad_date, adset_name, campaign_name, url_parameters, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily fabd 
join facebook_campaign fc on fc.campaign_id = fabd.campaign_id
join facebook_adset fa on fa.adset_id = fabd.adset_id
union 
select ad_date, adset_name, campaign_name, url_parameters, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily gabd
)
select 
ad_date,
campaign_name,
lower(substring(url_parameters, 'utm_campaign=([\W\w]+)')) as utm_campaign,
case lower(substring(url_parameters, 'utm_campaign=([\W\w]+)')) 
	when 'nan' then null
	else lower(substring(url_parameters, 'utm_campaign=([\W\w]+)')) 
end utm_campaign_nan,
sum(spend) as sum_spend,
sum(impressions) as sum_impressions,
sum(clicks) as sum_clicks,
avg(value) as avg_value,
	case 
	when sum (impressions) > 0 then round(sum (clicks) / sum (impressions) :: decimal, 3)
		end ctr,
	case 
	when sum(clicks) > 0 then sum(spend) / sum(clicks)
		end cpc,
	case 
	when sum(clicks) > 0 then sum(spend) / sum(clicks) * 100
		end cpm,
	case 
	when sum(spend) > 0 then round((avg(value) - sum(spend)) / sum(spend), 3)
		end romi
from j_ads_basic_daily
group by ad_date, campaign_name, url_parameters
