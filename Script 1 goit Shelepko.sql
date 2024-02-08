select ad_date, spend, clicks, spend / clicks as CPS
from facebook_ads_basic_daily 
where clicks > 0
order by ad_date DESC
