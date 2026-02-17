/*
Project: Engagement Rate by Device
Description:
Calculate share of engaged sessions by device type.

Environment: BigQuery
*/

WITH engagement_data AS (
    SELECT
        sp.device,
        SUM(
            CASE WHEN ep.value.string_value = '1' THEN 1 ELSE 0 END
        ) AS engaged_sessions,
        COUNT(*) AS total_sessions
    FROM `DA.event_params` AS p,
         UNNEST(p.event_params) AS ep
    JOIN `DA.session_params` AS sp
        ON p.ga_session_id = sp.ga_session_id
    WHERE ep.key = 'session_engaged'
        AND ep.value.string_value IS NOT NULL
    GROUP BY sp.device
)

SELECT
    device,
    ROUND(engaged_sessions * 100 / total_sessions, 2) AS engagement_rate_percent
FROM engagement_data
ORDER BY engagement_rate_percent DESC;
