with facebook_google3 as (with facebook_google2 as (with facebook_google1 as(
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
from facebook_google1)
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
group by ad_date, utm_campaign)
select date_trunc ('month', ad_date) as ad_month, utm_campaign,
total_spend, total_impressions, total_clicks, total_value,
CTR, CPC, CPM, ROMI
from facebook_google3;

with facebook_google4 as (
with facebook_google3 as (with facebook_google2 as (with facebook_google1 as(
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
from facebook_google1)
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
group by ad_date, utm_campaign)
select date_trunc ('month', ad_date) as ad_month, utm_campaign,
total_spend, total_impressions, total_clicks, total_value,
CTR, CPC, CPM, ROMI
from facebook_google3
)
select ad_month, utm_campaign, total_spend, total_impressions, total_clicks, total_value,
 CPC, CTR, lag (CTR,1) over (partition by utm_campaign order by ad_month) previous_CTR, CPM, lag (CPM,1) over (partition by utm_campaign order by ad_month) previous_CPM, ROMI, lag (ROMI,1) over (partition by utm_campaign order by ad_month) previous_ROMI
from facebook_google4;

with facebook_google5 as (
with facebook_google4 as (
with facebook_google3 as (with facebook_google2 as (with facebook_google1 as(
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
from facebook_google1)
select ad_date,
utm_campaign,
sum (spend) as total_spend,
sum (impressions) as total_impressions,
sum (clicks) as total_clicks,
sum (value) as total_value,
 case when sum(clicks) > 0 then sum (spend::float)/sum (clicks::float) else 0 end as CPC,
 case when sum(impressions) > 0 then sum (clicks::float)/sum (impressions::float)*100 else 0 end as CTR,
 case when sum(impressions) > 0 then sum (spend::float)/sum (impressions::float)*1000 else 0 end as CPM,
 case when sum(spend) > 0 then sum (value::float) - sum(spend::float)/sum (spend::float)*100 else 0 end as ROMI
from facebook_google2 
group by ad_date, utm_campaign)
select date_trunc ('month', ad_date) as ad_month, utm_campaign,
total_spend, total_impressions, total_clicks, total_value,
CTR, CPC, CPM, ROMI
from facebook_google3
)
select ad_month, utm_campaign, total_spend, total_impressions, total_clicks, total_value,
 CPC, CTR, lag (CTR,1) over (partition by utm_campaign order by ad_month) previous_CTR, CPM, lag (CPM,1) over (partition by utm_campaign order by ad_month) previous_CPM, ROMI, lag (ROMI,1) over (partition by utm_campaign order by ad_month) previous_ROMI
from facebook_google4
)
select ad_month, utm_campaign, total_spend, total_impressions, total_clicks, total_value,
 CPM, CTR, ROMI,
 case when CPM > 0 then (CPM-previous_CPM)/CPM else 0 end as CPM_percent_diff,
 case when CTR > 0 then (CTR-previous_CTR)/CTR else 0 end as CTR_percent_diff,
 case when ROMI > 0 then (ROMI-previous_ROMI)/ROMI else 0 end as ROMI_percent_diff
 from facebook_google5;