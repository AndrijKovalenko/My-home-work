
with facebook_google as(
select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily fabd
union all
select  ad_date, url_parameters, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily gabd) 
select 
ad_date, 
case when lower (substring (url_parameters, 'utm_campaign=([^\&]+)')) = 'nan' then null 
else lower (substring (url_parameters,'utm_campaign=([^\&]+)')) end as utm_campaign,
coalesce (spend, 0) as spend,
coalesce (impressions, 0) as impressions,
coalesce (reach, 0) as reach,
coalesce (clicks, 0) as clicks,
coalesce (leads, 0) as leads,
coalesce (value, 0) as value
from facebook_google;




with facebook_google2 as (with facebook_google as(
select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value
from facebook_ads_basic_daily fabd
union all
select  ad_date, url_parameters, spend, impressions, reach, clicks, leads, value
from google_ads_basic_daily gabd) 
select 
ad_date,
case when lower (substring (url_parameters, 'utm_campaign=([^\&]+)')) = 'nan' then null 
else lower (substring (url_parameters,'utm_campaign=([^\&]+)')) end as utm_campaign,
coalesce (spend, 0) as spend,
coalesce (impressions, 0) as impressions,
coalesce (reach, 0) as reach,
coalesce (clicks, 0) as clicks,
coalesce (leads, 0) as leads,
coalesce (value, 0) as value
from facebook_google)
select ad_date,
utm_campaign,
sum (spend) as total_spend,
sum (impressions) as total_impressions,
sum (clicks) as total_clicks,
sum (value) as total_value,
 case when sum(clicks) > 0 then sum (spend)/sum (clicks) else 0 end as CPC,
 case when sum(impressions) > 0 then sum (clicks)/sum (impressions)*100 else 0 end as CTR,
 case when sum(impressions) > 0 then sum (spend)/sum (impressions)*1000 else 0 end as CPM,
 case when sum(spend) > 0 then sum (value) - sum(spend)/sum (spend)*100 else 0 end as ROMI
from facebook_google2 
group by ad_date, utm_campaign;