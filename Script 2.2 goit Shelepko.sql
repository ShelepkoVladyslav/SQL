select campaign_id,
sum(value) as value_,
sum(spend) as spend_,
(sum(value) - sum(spend)) / sum(spend) :: decimal as romi
from facebook_ads_basic_daily
group by campaign_id
having sum(spend) > 500000
order by romi desc
