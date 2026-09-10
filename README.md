# # E-commerce Sales & Logistics Performance Dashboard

## Overview 

This project analyzes approximately 100K orders from the Olist Brazilian E-Commerce dataset to understand the commercial and operational drivers of e-commerce performance. 

The analysis focuses on three areas: 

- revenue and product performance 
- customer repeat behavior 
- delivery performance and customer satisfaction 

The final output is a Tableau dashboard supported by SQL-based data extraction and Python-based cleaning, transformation, and exploratory analysis. Check out the public dashboard [here](https://public.tableau.com/views/OlistE-CommercePerformanceDashboard_17890159015860/Dashboard2?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link). 

## Business Question 
The research question that we tackle in this research is: which customer seg
ments, product categories, and regimes drive repeat revenue, and how does delivery performance affect customer satisfaction? 

### Key Questions 

1. Which product categories and geographic regions generate the most revenue? 
2. How much revenue comes from repeat customers? 
3. Which customer segments have the highest average order value? 
4. Are late deliveries associated with lower review scores? 
5. Which categories or regions experience disproportionately high freight costs or delivery delays? 

## Data 
The project uses the Brazilian E-Commerce Public Dataset by Olist, containing approximately 100K anonymized orders between 2016 and 2018. 

The dataset includes information on: 
- customers
- orders 
- products 
- sellers
- payments
- freight
- delivery dates
- customer reviews
- geographic location

## Tools and Methods 

- SQL: data extraction, joins, aggregation, cohort and KPI calculations 
- Python: data cleaning, transformation, feature engineering, validation, and exploratory analysis 
- Pandas: tabular data manipulation 
- Matplotlib: exploratory visualisation 
- Power BI: interactive business dashboard 
- Git/Github: version control and project documentation 

## Core KPIs 

- Total Revenue 
- Total Orders 
- Average Order Value 
- Repeat Customer Rate
- Repeat Customer Revenue 
- Average Delivery Time 
- Late Delivery Time 
- Average Review Score
- Freight Cost as % of Order Value 

## Pipeline 

Data Extraction: DuckDB for SQL queries, joining multiple relational tables (orders, customers, reviews, products) and aggregating initial metrics directly.

Transformation & Statistical Analysis: Leveraged Pandas to clean data, engineer new features (e.g., State-Category combinations), and apply statistical methods—specifically using the 99th percentile (Quantile) to dynamically identify logistics outliers in heavily right-skewed data.

Visualization & Deployment: Exported the statistically filtered data to CSV and imported it into Power BI to build an interactive, user-facing dashboard with drill-down capabilities via geographic and categorical slicers.

## Key Findings 

Satisfaction is Tied to Logistics: There is a stark correlation between delivery performance and customer sentiment; late deliveries cause average review scores to plummet by nearly two full stars (out of 5).

The Volume Bottleneck: São Paulo generates massive revenue but also experiences the highest absolute volume of late deliveries, highlighting a critical need for local last-mile delivery optimization.

The Margin Bleed: Statistical outlier detection revealed that remote northern and northeastern states (e.g., Maranhão, Paraíba) experience extreme freight costs, frequently exceeding 100+ BRL for bulky categories like furniture, which heavily erodes profit margins.


