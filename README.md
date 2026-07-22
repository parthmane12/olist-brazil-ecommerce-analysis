# Olist Brazil E-Commerce Analysis

> An end-to-end Data Analytics project analyzing the Olist Brazilian E-commerce dataset using **Python, MySQL, and Power BI**. The project transforms raw transactional data into actionable business insights through data cleaning, SQL-based exploratory analysis, and an interactive business intelligence dashboard.

---

# Executive Summary

This project presents an end-to-end data analytics solution built on the Olist Brazilian E-commerce dataset. The objective was to transform raw transactional data into actionable business insights by designing a complete analytics pipeline—from data cleaning and exploration to interactive business intelligence reporting.

The workflow began with cleaning and preprocessing the raw Kaggle dataset using Python, where duplicate records were removed, data types were standardized, datasets were merged, analytical columns were created, and the cleaned datasets were exported for further analysis.

The cleaned data was then imported into MySQL, where Exploratory Data Analysis (EDA) and SQL-based business questions were performed to uncover sales trends, customer behavior, delivery performance, product performance, and regional insights.

Finally, the processed datasets were modeled in Power BI using a star-schema inspired model. Custom DAX measures, KPIs, and interactive visualizations were developed to create a multi-page executive dashboard covering revenue trends, funnel analysis, delivery performance, customer & product insights, and geographic analysis.

The resulting dashboard enables stakeholders to monitor business performance, identify bottlenecks in the order lifecycle, evaluate delivery efficiency, and make data-driven business decisions.

---

# Dashboard

## Pages

- Executive Overview
- Funnel Analysis
- Delivery Performance
- Customer & Product Insights
- Geographic Analysis

---

# Project Deliverables

This repository contains the complete project deliverables developed throughout the analytics workflow.

| Deliverable | Description |
|-------------|-------------|
| 📓 Jupyter Notebook | Data cleaning and preprocessing using Python (Pandas). |
| 🗄️ SQL Script | Exploratory Data Analysis and business question solving using MySQL. |
| 📊 Power BI Dashboard | Interactive multi-page dashboard with KPIs and business insights. |
| 📄 Project Report | Detailed documentation of the project methodology, findings, and recommendations. |
| 📽️ Presentation Deck | Executive presentation summarizing objectives, methodology, dashboard walkthrough, and key business insights. |

---

# Dataset

**Source:** Kaggle – Olist Brazilian E-Commerce Dataset

### Original Dataset

- 9 CSV files
- 100K+ Orders
- Customer Information
- Seller Information
- Product Information
- Payments
- Reviews
- Order Items
- Geolocation
- Product Category Translation

After preprocessing and merging, the project uses **7 cleaned datasets** for analysis.

---

# Tech Stack

## Data Cleaning

- Python
- Pandas

## Database

- MySQL

## Business Intelligence

- Power BI
- Power Query
- DAX

## Version Control

- Git
- GitHub

---

# Project Workflow

```text
                     Kaggle Dataset
                    (9 Raw CSV Files)
                           │
                           ▼
              Python (Jupyter Notebook)
                           │
        Data Cleaning & Preprocessing
      • Duplicate Removal
      • Datetime Conversion
      • Dataset Merging
      • Feature Engineering
      • CSV Export
                           │
                           ▼
                       MySQL
                           │
       Exploratory Data Analysis (EDA)
      • Business Questions
      • Sales Analysis
      • Customer Analysis
      • Delivery Analysis
                           │
                           ▼
                      Power BI
                           │
      Data Modeling • DAX • Dashboard
                           │
                           ▼
          Interactive Business Dashboard
                           │
          ┌────────────────┴───────────────┐
          ▼                                ▼
 Project Report (.docx)          Presentation Deck (.pptx)
          │                                │
          └──────────────► Business Communication
```


---

# Data Cleaning

The raw dataset was cleaned using **Pandas** in Jupyter Notebook.

Cleaning steps included:

- Removed duplicate records
- Standardized column names
- Converted date columns to datetime format
- Created analytical columns
- Merged related datasets
- Exported cleaned CSV files for SQL and Power BI

---

# SQL Analysis

The cleaned datasets were imported into MySQL to perform Exploratory Data Analysis (EDA).

Business questions answered include:

- Monthly revenue trends
- Top-performing product categories
- Highest revenue-generating states
- Best-performing sellers
- Customer purchasing behavior
- Delivery performance analysis
- Payment analysis
- Review score distribution
- Revenue contribution by state
- Geographic sales analysis

---

# Power BI Data Model

The dashboard follows a star-schema inspired model consisting of fact and dimension tables.

### Fact Tables

- Orders
- Order Items

### Dimension Tables

- Customers
- Products
- Sellers
- Payments
- Reviews
- Date Table

Relationships were optimized to enable efficient filtering and accurate KPI calculations.

---

# DAX Measures

More than **35 DAX measures** were created to calculate key business metrics.

Some major measures include:

- Total Revenue
- Total Orders
- Average Order Value
- Average Delivery Days
- Average Review Score
- Conversion Rate
- On-Time Delivery %
- Late Delivery %
- Revenue at Risk
- Cancellation Rate
- Revenue Month-over-Month %
- Stage Drop-off %
- Top Ordering State
- Top Ordering City

---

# Dashboard Features

- Interactive slicers
- KPI cards
- Navigation buttons
- Page navigator
- Interactive maps
- Dynamic filtering
- Multi-page dashboard
- Executive reporting layout

---

# Dashboard Pages
## Home Page
<p align="center">
  <img src="dashboard/images/home.jpg" width="100%">
</p>
Provides Page navigation and short insight of each page

---

## Executive Overview
<p align="center">
  <img src="dashboard/images/executive_overview.jpg" width="100%">
</p>
Provides an overview of overall business performance through KPIs, monthly revenue trends, order volume, and product category contribution.

---

## Funnel Analysis
<p align="center">
  <img src="dashboard/images/funnel_analysis.jpg" width="100%">
</p>
Tracks customer progression from order placement to review completion while identifying stage-wise drop-offs and revenue leakage.

---

## Delivery Performance
<p align="center">
  <img src="dashboard/images/delivery_performance.jpg" width="100%">
</p>
Analyzes delivery efficiency using delivery days, on-time delivery percentage, cancellation rate, freight cost, and regional delivery performance.

---

## Customer & Product Insights
<p align="center">
  <img src="dashboard/images/customer_and_product_insights.jpg" width="100%">
</p>
Highlights top-performing products, sellers, product categories, customer reviews, and purchasing behavior.

---

## Geographic Analysis
<p align="center">
  <img src="dashboard/images/geographic_analysis.jpg" width="100%">
</p>
Visualizes revenue distribution, order concentration, delivery performance, and customer distribution across Brazilian states and cities.

---

# Key Insights

- Generated over **$13.5M** in revenue.
- Achieved approximately **97% order conversion** from placement to delivery.
- Maintained an average customer review score above **4.0**.
- São Paulo emerged as the highest revenue-generating state.
- Health & Beauty was the highest revenue-generating product category.
- Maintained approximately **95% on-time delivery**.
- Funnel analysis identified the largest revenue loss during the approval-to-shipping stage.

---

# Documentation

The repository includes additional documentation prepared for project presentation and reporting.

- **Project Report** – Explains the project objectives, methodology, data preparation, SQL analysis, dashboard development, key findings, and conclusions.
- **Presentation Deck** – Executive summary of the project designed for stakeholder presentations, highlighting business problems, analytical approach, dashboard walkthrough, and actionable insights.

---

# Project Methodology

## 1. Data Collection

Downloaded the Olist Brazilian E-commerce dataset from Kaggle containing multiple relational tables describing customers, orders, products, sellers, reviews, and payments.

---

## 2. Data Cleaning (Python)

The raw data was cleaned and transformed using Pandas. Data types were standardized, duplicate records were removed, datasets were merged where necessary, analytical columns were created, and the processed datasets were exported as clean CSV files.

---

## 3. Exploratory Data Analysis (MySQL)

The cleaned datasets were imported into MySQL, where SQL queries were written to analyze sales trends, customer behavior, delivery performance, regional sales, and product performance before dashboard development.

---

## 4. Data Modeling (Power BI)

The cleaned datasets were imported into Power BI and modeled using fact and dimension tables. A dedicated Date Table was created to enable efficient time-based analysis.

---

## 5. DAX Development

Over **35 DAX measures** were developed to calculate business KPIs including revenue, delivery performance, conversion rate, average order value, stage drop-offs, and month-over-month growth.

---

## 6. Dashboard Development

An interactive five-page dashboard was designed using KPI cards, navigation buttons, slicers, maps, and dynamic visualizations, allowing users to analyze business performance from multiple perspectives.

---

## 7. Documentation
Complete report an presentation of the project designed for stakeholder presentations, highlighting business problems, analytical approach, dashboard walkthrough, and actionable insights.

---

# Skills Demonstrated

- Data Cleaning
- Data Wrangling
- Exploratory Data Analysis (EDA)
- SQL Querying
- Data Modeling
- DAX
- Power BI
- Business Intelligence
- Data Visualization
- KPI Development
- Dashboard Design
- Analytical Thinking

---

# Future Improvements

- Deploy dashboard using Power BI Service
- Build real-time SQL integration
- Customer segmentation (RFM Analysis)
- Sales forecasting
- Machine learning-based demand prediction
- Incremental data refresh
- Azure integration
