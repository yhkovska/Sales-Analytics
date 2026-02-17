# E-commerce Sales & Engagement Analytics (BigQuery SQL)

## Overview

This repository contains a collection of SQL case studies built on an e-commerce dataset in Google BigQuery.

The projects demonstrate structured analytical thinking — from focused metric calculations (window functions, aggregations) to building a comprehensive BI-ready dataset combining multiple business domains.

The case studies are organized from foundational analysis to a full analytical dataset used for dashboarding.

---

## Project Structure

### 01 — Email Monthly Share (Window Functions)

Calculation of:
- Monthly share of emails per account
- First and last sent date per account per month

Focus:
- Window functions (COUNT, MIN, MAX)
- DATE_TRUNC & date transformations
- Partition-based calculations

Demonstrates analytical window logic and aggregation control.

---

### 02 — Revenue & Account Metrics by Continent

Performance breakdown including:
- Total revenue
- Revenue split by device (mobile / desktop)
- Revenue share from total
- Account count
- Verified users
- Session count

Focus:
- CTE structuring
- Conditional aggregation (CASE WHEN)
- Multi-table joins
- Window-based percentage calculation

Demonstrates multi-source metric consolidation.

---

### 03 — Engagement Rate by Device

Calculation of session engagement share by device type.

Focus:
- UNNEST for nested data
- Conditional aggregation
- Ratio and percentage formatting

Demonstrates working with event-level structured data.

---

## ⭐ 04 — Main Case: Unified Account & Email Performance Dataset

Comprehensive analytical dataset combining:

- Account creation metrics
- Email performance (sent / open / visit)
- Country-level totals
- Top-10 country ranking
- Segmentation by:
  - Date
  - Country
  - Send interval
  - Verification status
  - Subscription status

Technical focus:
- Layered CTE architecture
- UNION ALL for metric separation
- Window functions (DENSE_RANK)
- Partition-based totals
- Dimensional modeling logic
- BI-ready dataset preparation

This dataset was used to build a Looker Studio dashboard:

https://lookerstudio.google.com/reporting/87d38168-1b95-4b38-923a-3937dbef6eb4

---

## Skills Demonstrated

- Advanced SQL (BigQuery)
- Window functions
- Multi-level aggregation
- Revenue share calculations
- Ranking logic
- Data modeling for BI tools
- Dataset preparation for dashboarding
- Business metric interpretation

---

## Tools

- Google BigQuery
- SQL
- Looker Studio
