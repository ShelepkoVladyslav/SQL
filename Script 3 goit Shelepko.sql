	with face_goog as (
select ad_date, concat ('face', 'book') as media_source, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily
	union
select ad_date, concat ('goo', 'gle') as media_source, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily )
select ad_date, media_source,
	sum(spend) as spend_,
	sum(impressions) as impressions_,
	sum (clicks) as clicks_,
	sum(leads) as leads,
	round(avg(value), 2) as value_
from face_goog
group by ad_date, media_source



