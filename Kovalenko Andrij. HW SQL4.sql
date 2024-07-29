with facebook_google as (
select fabd.ad_date, 
fc.campaign_name, fa.adset_name,
fabd.spend, fabd.impressions, fabd.reach, fabd.clicks, fabd.leads, fabd.value, fabd.url_parameters,
'facebook'as media_sourse
from facebook_ads_basic_daily fabd 
left join facebook_campaign fc 
on  fabd.campaign_id = fc.campaign_id 
left join facebook_adset fa 
on fabd.adset_id = fa.adset_id
union all
select 
gabd.ad_date, gabd.campaign_name, gabd.adset_name,
gabd.spend, gabd.impressions, gabd.reach, gabd.clicks, gabd.leads, gabd.value, gabd.url_parameters,
'google'as media_sourse
from google_ads_basic_daily gabd
)
select * from facebook_google;

with facebook_google as (
select fabd.ad_date,  
fc.campaign_name, fa.adset_name,
'facebook' as media_sourse,
sum (spend) as total_spend,
sum (impressions) as total_impressions,
sum (clicks) as total_clicks,
sum (value) as Total_value
from facebook_ads_basic_daily fabd
left join facebook_campaign fc 
on  fabd.campaign_id = fc.campaign_id 
left join facebook_adset fa 
on fabd.adset_id = fa.adset_id
group by ad_date, campaign_name, adset_name
)
select * from facebook_google
union all
select  gabd.ad_date, gabd.campaign_name, gabd.adset_name,
'google' as media_sourse,
sum (spend) as total_spend,
sum (impressions) as total_impressions,
sum (clicks) as total_clicks,
sum (value) as Total_value
from google_ads_basic_daily gabd
group by ad_date, campaign_name, adset_name;