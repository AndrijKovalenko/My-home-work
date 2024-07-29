select ad_date, spend, clicks, spend/clicks as sc
from facebook_ads_basic_daily fabd 
where clicks > '0'
order by ad_date desc;

select ad_date, campaign_id, 
sum(spend) as total_spend,
sum (impressions)as total_impressions, 
sum (clicks) as total_clicks,
sum(value) as total_value 
from facebook_ads_basic_daily  
where clicks > '0'and impressions > '0'
group by ad_date, campaign_id; 

select ad_date, campaign_id,
SUM (spend::float)/sum(clicks::float) as CPC,
(SUM (spend::float)/sum(impressions::float))*1000 as CPM,
(sum (clicks::numeric)/sum(impressions::numeric))*100 as CTR,
(sum (value::float) - sum(spend::float))/sum(spend::float)*100 as ROMI
from facebook_ads_basic_daily fabd 
where spend > '0'and clicks > '0'
group by ad_date, campaign_id;

