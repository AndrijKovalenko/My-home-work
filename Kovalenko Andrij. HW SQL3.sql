with google_facebook as 
(select ad_date, reach, impressions, clicks,leads, value, 'google' as media_source
from google_ads_basic_daily gabd
)
select * from google_facebook
union all
select ad_date, reach, impressions, clicks, leads, value, 'facebook' as media_source
from facebook_ads_basic_daily fabd;


with google_facebook as 
(select ad_date,'google' as media_source,
sum(spend) as total_spend,
sum (impressions)as total_impressions, 
sum (clicks) as total_clicks,
sum(value) as total_value 
from google_ads_basic_daily gabd
group by ad_date
)
select * from google_facebook
union all
select ad_date, 'facebook' as media_source,
sum(spend) as total_spend,
sum (impressions)as total_impressions, 
sum (clicks) as total_clicks,
sum(value) as total_value 
from facebook_ads_basic_daily fabd
group by ad_date;


