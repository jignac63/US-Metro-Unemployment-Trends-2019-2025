# 📊 US Metro Unemployment Trends (2019–2025)

## 🔹 Overview
This project analyzes metro-level unemployment rates across U.S. regions from 2019 to 2025. The objective was to transform raw wide-format labor data into a structured analytical model and build an interactive Power BI dashboard to track labor market recovery and regional disparities.

---

## 🛠 Tools Used
- Oracle SQL (ETL & Data Modeling)
- Power BI (Dashboard & Visualization)
- Time-Series Analysis

---

## 🔄 Data Engineering Process
- Converted wide monthly columns into time-series format using SQL UNPIVOT
- Created structured fact table for efficient analytics
- Cleaned and standardized unemployment rate values
- Prepared dataset for BI consumption

---

## 📊 Dashboard Preview

📥 **Download Full Dashboard (PDF)**  
https://github.com/jignac63/US-Metro-Unemployment-Trends-2019-2025/blob/main/Week_2_Unemployment%20%20Analysis.pdf

<img width="1057" height="585" alt="image" src="https://github.com/user-attachments/assets/b4fff6fd-3668-48bd-b67d-4c4389f22445" />




---

## 🔎 Key Analysis
- U.S. metro unemployment trend (2019–2025)
- COVID-19 unemployment spike (2020)
- Post-pandemic recovery pattern
- Top 10 highest unemployment metros (latest month)
- National unemployment KPI tracking

---

## 💡 Executive Summary
The dashboard highlights the sharp unemployment surge during 2020, followed by gradual normalization through 2022–2025. While national averages stabilized, certain metro regions continue to exhibit elevated unemployment levels, indicating persistent regional labor disparities.

This solution enables:
- Monitoring macro labor trends
- Identifying high-risk metro areas
- Supporting data-driven regional planning decisions

---

## 📂 Project Structure

```
├── sql/
│   └── unemployment_etl.sql
├── dashboard/
│   └── unemployment_dashboard.pdf
└── README.md
```


