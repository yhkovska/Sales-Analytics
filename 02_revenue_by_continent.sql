/*
Project: Revenue & Account Metrics by Continent
Description:
Aggregate revenue, device split and account metrics by continent.

Environment: BigQuery
*/

WITH revenue_data AS (
    SELECT
        sp.continent,
        SUM(p.price) AS revenue,
        SUM(CASE WHEN sp.device = 'mobile' THEN p.price ELSE 0 END) AS revenue_mobile,
        SUM(CASE WHEN sp.device = 'desktop' THEN p.price ELSE 0 END) AS revenue_desktop
    FROM `DA.order` AS o
    JOIN `DA.product` AS p
        ON o.item_id = p.item_id
    JOIN `DA.session_params` AS sp
        ON sp.ga_session_id = o.ga_session_id
    GROUP BY sp.continent
),

account_data AS (
    SELECT
        sp.continent,
        COUNT(DISTINCT acs.account_id) AS account_count,
        COUNT(DISTINCT sp.ga_session_id) AS session_count
    FROM `DA.session_params` AS sp
    LEFT JOIN `DA.account_session` AS acs
        ON sp.ga_session_id = acs.ga_session_id
    GROUP BY sp.continent
),

verified_data AS (
    SELECT
        sp.continent,
        COUNT(DISTINCT CASE WHEN acc.is_verified = 1 THEN acc.id END) AS verified_account
    FROM `DA.account` AS acc
    JOIN `DA.account_session` AS acs
        ON acc.id = acs.account_id
    JOIN `DA.session_params` AS sp
        ON sp.ga_session_id = acs.ga_session_id
    GROUP BY sp.continent
)

SELECT
    a.continent,
    r.revenue,
    r.revenue_mobile,
    r.revenue_desktop,
    r.revenue / SUM(r.revenue) OVER () * 100 AS revenue_share_total,
    a.account_count,
    v.verified_account,
    a.session_count
FROM account_data AS a
LEFT JOIN revenue_data AS r
    ON a.continent = r.continent
LEFT JOIN verified_data AS v
    ON a.continent = v.continent
ORDER BY r.revenue DESC;
