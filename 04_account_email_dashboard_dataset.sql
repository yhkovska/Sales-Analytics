/*
Project: Unified Account & Email Performance Dataset
Description:
Build a BI-ready dataset combining account creation and email performance metrics.
Includes country-level totals and ranking logic (Top 10 markets).

Environment: BigQuery
*/

WITH account_data AS (
    SELECT
        s.date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed,
        COUNT(DISTINCT a.id) AS account_cnt
    FROM `DA.account` AS a
    JOIN `DA.account_session` AS acs
        ON a.id = acs.account_id
    JOIN `DA.session` AS s
        ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` AS sp
        ON s.ga_session_id = sp.ga_session_id
    GROUP BY
        s.date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed
),

email_data AS (
    SELECT
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM `DA.email_sent` AS es
    JOIN `DA.account` AS a
        ON es.id_account = a.id
    JOIN `DA.account_session` AS acs
        ON es.id_account = acs.account_id
    JOIN `DA.session` AS s
        ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` AS sp
        ON acs.ga_session_id = sp.ga_session_id
    LEFT JOIN `DA.email_open` AS eo
        ON es.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` AS ev
        ON es.id_message = ev.id_message
    GROUP BY
        date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed
),

combined_data AS (
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg
    FROM account_data

    UNION ALL

    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        0 AS account_cnt,
        sent_msg,
        open_msg,
        visit_msg
    FROM email_data
),

aggregated AS (
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        SUM(account_cnt) AS account_cnt,
        SUM(sent_msg) AS sent_msg,
        SUM(open_msg) AS open_msg,
        SUM(visit_msg) AS visit_msg
    FROM combined_data
    GROUP BY
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed
),

country_totals AS (
    SELECT
        *,
        SUM(account_cnt) OVER (PARTITION BY country) AS total_country_account_cnt,
        SUM(sent_msg) OVER (PARTITION BY country) AS total_country_sent_cnt
    FROM aggregated
),

ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY total_country_account_cnt DESC
        ) AS rank_total_country_account_cnt,
        DENSE_RANK() OVER (
            ORDER BY total_country_sent_cnt DESC
        ) AS rank_total_country_sent_cnt
    FROM country_totals
)

SELECT
    date,
    country,
    send_interval,
    is_verified,
    is_unsubscribed,
    account_cnt,
    sent_msg,
    open_msg,
    visit_msg,
    total_country_account_cnt,
    total_country_sent_cnt,
    rank_total_country_account_cnt,
    rank_total_country_sent_cnt
FROM ranked
WHERE rank_total_country_account_cnt <= 10
   OR rank_total_country_sent_cnt <= 10
ORDER BY
    rank_total_country_account_cnt,
    rank_total_country_sent_cnt,
    country,
    date;
