# 🏥 Hospital Operations & Healthcare Analytics — End-to-End BI Solution

![SQL Server](https://img.shields.io/badge/SQL_Server-2025-cc2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Semantic_Model-f2c811?style=flat&logo=power-bi&logoColor=black)
![T-SQL](https://img.shields.io/badge/Language-T--SQL_%2F_DAX-00758f?style=flat)
![Status](https://img.shields.io/badge/Status-Complete-success)

An enterprise-grade, end-to-end healthcare analytics and hospital operations solution. This project bridges relational database engineering in **SQL Server 2025**, a governed semantic model in **Power BI**, and an executive 3-page dark-themed dashboard covering hospital performance, financial leakage, pharmacy expenditure, and clinical patient flow.

🔗 **[View Live Power BI Report] (https://app.powerbi.com/links/gQvWpq9UvF?ctid=1158e2d5-dc24-41ad-abce-62841076dbde&pbi_source=linkShare)**

---

## 📸 Dashboard Preview
| Executive Overview | Pharmacy & Financial Deep Dive | Clinical & Patient Flow |
| :---: | :---: | :---: |
| ![Page 1](screenshots/page-1-overview.png) | ![Page 2](screenshots/page-2-pharmacy.png) | ![Page 3](screenshots/page-3-clinical.png) |

---

## 📑 Table of Contents
1. [Project Overview & Key Metrics](#1-project-overview--key-metrics)
2. [Business Problem & Value Statement](#2-business-problem--value-statement)
3. [Architecture & Tech Stack](#3-architecture--tech-stack)
4. [Data Pipeline & SQL Engineering](#4-data-pipeline--sql-engineering)
5. [Power BI Semantic Model](#5-power-bi-semantic-model)
6. [Dashboard Breakdown (3 Pages)](#6-dashboard-breakdown-3-pages)
7. [DAX Formula Catalog](#7-dax-formula-catalog)
8. [Key Business Insights & Strategic Recommendations](#8-key-business-insights--strategic-recommendations)
9. [Repository Structure & How to Reproduce](#9-repository-structure--how-to-reproduce)

---

## 1. Project Overview & Key Metrics
This project models a multi-department hospital using five core relational tables spanning **5,000 patients, 13,214 encounters, 26,715 pharmacy prescriptions, 13,214 clinical records, and 13,214 billing transactions** (Jan 2023 – Feb 2026). 

The data is ingested, cleaned, and indexed in **SQL Server 2025**, exposed through two performance-optimized analytical views (`vw_hospital_summary` and `vw_pharmacy_cost`), and consumed in **Power BI Import Mode** via a clean star-schema design.

### 🌟 Headline Metrics (Filters Cleared):
* **Gross Billed Revenue:** $246M
* **Total Pharmacy Spend:** $18.3M
* **Claim Rejection Rate:** 12.6%
* **Outstanding Patient Balance:** $26.0M
* **30-Day Readmission Rate:** 33.0%
* **Average Length of Stay (ALOS):** 5.76 Days
* **Total ICU Admissions:** 538

---

## 2. Business Problem & Value Statement
Hospital leadership must simultaneously balance clinical quality, capacity constraints, and revenue-cycle health. This solution consolidates siloed operational data to address 5 critical pillars:
* **Clinical Flow & ALOS:** Isolate resource-heavy departments (ICU, Emergency) to optimize discharge planning.
* **Readmission Reduction:** Rank disease categories and department-urgency cells to target transitional-care programs.
* **ICU Capacity Management:** Monitor inpatient ICU utilization to drive intelligent bed allocation and staffing.
* **Pharmacy Expenditure Tracking:** Quantify drug spend by therapeutic class, department, and high-risk medication flags.
* **Revenue-Cycle Integrity:** Measure claim rejection rates, isolate denial root-causes, and size outstanding patient balances.

---

## 3. Architecture & Tech Stack

```mermaid
flowchart LR
    A[Kaggle CSVs<br/>5 Source Files] -->|BULK INSERT| B[(SQL Server 2025<br/>Hospital_Management_System)]
    B --> C[PK/FK Constraints +<br/>Non-Clustered Indexes]
    C --> D[vw_hospital_summary<br/>vw_pharmacy_cost]
    D -->|Import Mode| E[Power BI Semantic Model<br/>Calendar + _Measures]
    B -->|Import Mode| E
    E --> F[3-Page Executive Dashboard]
    F --> G[Power BI Service<br/>Published Report]
