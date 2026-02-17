# E-commerce Sales & Engagement Analytics (BigQuery SQL)

## Overview

This repository contains a collection of SQL case studies built on an e-commerce dataset in BigQuery.

The projects demonstrate structured analytical thinking — from focused metric calculations to building a dashboard-ready dataset combining multiple business domains.

The case studies are organized from foundational analysis to a comprehensive final analytical dataset.

---

## Project Structure

### 1️⃣ Email Activity Share (Window Functions Practice)

Calculation of:
- Monthly email share per account
- First and last send date per month

Focus:
- Window functions
- Partitioning
- Date transformations

This case demonstrates control over analytical window logic and aggregation levels.

---

### 2️⃣ Revenue & Accounts by Continent (CTE & Aggregation)

Breakdown including:
- Revenue
- Revenue by device
- Revenue share from total
- Account count
- Verified users
- Session count

Focus:
- CTE structuring
- Conditional aggregation
- Multi-source joins
- Window-based percentage calculation

This case demonstrates ability to combine multiple entities into one analytical layer.

---

### 3️⃣ Engagement Rate by Device (Nested Data Handling)

Calculation of:
- Share of engaged sessions by device

Focus:
- UNNEST
- Conditional logic
- Ratio calculation

This case demonstrates working with nested structures and event-level data.

---

## ⭐ 4️⃣ Main Case: Unified Account & Email Performance Dataset

Comprehensive dataset combining:

- Account creation metrics
- Email performance (sent / open / visit)
- Country-level totals
- Top-10 country ranking
- Segmentation by:
  - Country
  - Send interval
  - Verification status
  - Subscription status
  - Date

Technical focus:
- Multiple CTE layers
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
- Analytical window functions
- Multi-level aggregation
- Revenue share & ranking logic
- Data modeling for reporting
- Structuring queries for BI tools
- Business metric interpretation

---

## Tools

- Google BigQuery
- SQL
- Looker Studio
