/*
Project: Email Monthly Share
Description:
Calculate monthly email share per account,
including first and last sent date.

Environment: BigQuery
*/

WITH email_base AS (
    SELECT
        DATE_TRUNC(DATE_ADD(s.date, INTERVAL es.sent_date DAY), MONTH) AS sent_month,
        es.id_account,
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS sent_date,
        es.id_message
    FROM `DA.email_sent` AS es
    JOIN `DA.account_session` AS acs
        ON es.id_account = acs.account_id
    JOIN `DA.session` AS s
        ON acs.ga_session_id = s.ga_session_id
),

aggregated AS (
    SELECT
        sent_month,
        id_account,
        COUNT(id_message) OVER (
            PARTITION BY id_account, sent_month
        ) AS account_month_msg,
        COUNT(id_message) OVER (
            PARTITION BY sent_month
        ) AS total_month_msg,
        MIN(sent_date) OVER (
            PARTITION BY id_account, sent_month
        ) AS first_sent_date,
        MAX(sent_date) OVER (
            PARTITION BY id_account, sent_month
        ) AS last_sent_date
    FROM email_base
)

SELECT DISTINCT
    sent_month,
    id_account,
    account_month_msg / total_month_msg * 100 AS sent_msg_percent_from_this_month,
    first_sent_date,
    last_sent_date
FROM aggregated
ORDER BY sent_month, id_account;
