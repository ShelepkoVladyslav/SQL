CREATE OR replace FUNCTION pg_temp.decode_url_part(p varchar) RETURNS varchar AS $$ 
SELECT
	convert_from(  
	CAST(E'\\x'|| string_agg(
	CASE WHEN length(r.m[1]) = 1 THEN encode (convert_to(r.m[1], 'SQL_ASCII'), 'hex')
	ELSE substring(r.m[1] FROM 2 FOR 2) END, '') AS bytea)
	, 'UTF8'
	)
	FROM regexp_matches($1,  '%[0-9a-f][0-9a-f]|.', 'gi') AS r(m);
$$ LANGUAGE SQL IMMUTABLE STRICT;
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
end utm_campaign_not_nan,
decode_url_part(substring(url_parameters, 'utm_campaign=([\W\w]+)')) as utm_campaign_decode,
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
