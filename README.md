# 📊 MySQL Data Analytics Project
A comprehensive collection of MySQL scripts for data exploration, analytics, and reporting. These scripts cover various analyses such as database exploration, measures and metrics, time-based trends, cumulative analytics, segmentation, and more.  
本專案收錄了一系列完整的 MySQL 腳本，專為資料探索、進階分析與商業報表設計。內容涵蓋了資料庫結構探索、核心指標計算、時間序列趨勢分析、累計指標計算以及客戶分群等多種實用分析情境。

This repository contains MySQL queries designed to help data analysts and BI professionals quickly explore, segment, and analyze data within a relational database. Each script focuses on a specific analytical theme and demonstrates best practices for MySQL queries.  
這個 Repository 包含精心設計的 MySQL 查詢語法，旨在幫助資料分析師與商業智慧專家在關聯式資料庫中，快速進行資料探索、分群與深度分析。每個腳本都專注於特定的分析主題，並展現 MySQL 查詢的業界最佳實踐。

---
## 📂 Repository Structure (專案目錄結構)

The SQL scripts in this repository are structured sequentially to reflect a standard data analysis lifecycle, ranging from initial profiling to advanced business reporting  
本專案的 SQL 腳本依據分析流程由淺入深進行編排，各階段檔案說明如下：

### 🔍 1. Data Exploration Phase (資料探索階段)
* `01_database_exploration.sql` — **Database Profiling**: Explores row counts, table sizes, and missing data schemas across the environment.  
  **資料庫全局探索**：分析資料庫整體資料量、表結構與欄位分佈。
* `02_dimensions_exploration.sql` — **Dimension Exploration**: Profiles categorical attributes like customer segments, regions, and product categories.  
  **維度資料探索**：針對客戶、產品等維度資料進行基礎統計
* `03_date_range_exploration.sql` — **Temporal Range Profiling**: Identifies the timeline boundaries, minimum/maximum dates, and data continuity.  
  **時間範圍探勘**：確認資料的時間跨度、觀測窗口與時間連續性。
* `04_measures_exploration.sql` — **Measures Exploration**: Initial descriptive statistics (SUM, AVG) of core numerical values.  
  **核心度量探索**：對數值型欄位（如金額、數量）進行基礎的加總與平均統計。

### 📈 2. Advanced Analytical Themes (進階商業分析)
* `05_magnitude_analysis.sql` — **Magnitude Analysis**: Investigates scale distributions and high-impact anomalies (e.g., top-tier transactions).  
  **量體規模分析**：找出最大、最小或異常極值的資料分佈（如高價值訂單分析）。
* `06_ranking_analysis.sql` — **Ranking Analysis**: Leverages window functions (`ROW_NUMBER()`, `RANK()`) to perform localized partition rankings.  
  **排名與競賽分析**：使用 Window Functions（如 `ROW_NUMBER()`, `RANK()`）對業務指標進行分組排名。
* `07_change_over_time_analysis.sql` — **Time-Series Analysis**: Tracks period-over-period growth metrics such as MoM (Month-over-Month) and YoY (Year-over-year) trends.  
  **時間序列趨勢分析**：計算同季（YoY）、環比（MoM）成長率以及長期的業務波動趨勢。
* `08_cumulative_analysis.sql` — **Cumulative Analytics**: Implements calculations like running totals and rolling averages over timeline vectors.  
  **累計指標分析**：編寫累計消費金額與移動平均等時間累計指標。
* `09_performance_analysis.sql` — **Performance Evaluation**: Measures operational efficiency against benchmark baselines.  
  **績效表現分析**：評估銷售管道、活動效益，比較實際表現與設定目標。
* `10_data_segmentation.sql` — **Customer/Product Segmentation**: Groups entities using business logic rules (e.g., RFM scoring or frequency categorization).  
  **資料分群與標籤**：依據特定商業規則（如 RFM 模型、消費頻率）對客戶或產品進行分群。
* `11_part_to_whole_analysis.sql` — **Part-to-Whole Contribution**: Determines individual share percentages relative to the grand total.  
  **佔比與貢獻度分析**：計算個別品類或區域佔整體的百分比（貢獻度分佈）。

### 📊 3. Business Reporting Layer (商業報表產出)
* `12_report_customers.sql` — **Customer Insights Report**: A consolidated, production-ready script summarizing lifetime value (LTV), retention, and behavior patterns.  
  **客戶核心報表**：整合客戶留存率、終身價值（LTV）與活躍度的 Production 等級綜合報表。
* `13_report_products.sql` — **Product Performance Report**: An end-to-end report evaluating inventory velocity, revenue contribution, and product lifecycles.  
  **產品核心報表**：涵蓋產品銷售週期、庫存周轉與熱銷排行之決策報表。

---
## 🔗 Data Source & Architecture (資料來源與專案架構)

The database utilized in this project is not built upon randomly generated mock data. Instead, it is directly sourced from my upstream repository, [mysql-data-warehouse-project](https://github.com/Rselayva/mysql-data-warehouse-project.git), which serves as the core Data Warehouse layer.  
本專案所使用的資料庫並非隨機生成的測試資料，而是基於我另一個專案 [mysql-data-warehouse-project](https://github.com/Rselayva/mysql-data-warehouse-project.git) 所建置的 Data Warehouse。

The overall data pipeline architecture is structured as follows
整體的資料管線架構如下：
1. **[Data Warehousing & Cleaning Phase](https://github.com/Rselayva/mysql-data-warehouse-project.git)**: This upstream stage handles raw data ingestion, ETL processing, data cleansing (handling missing and anomalous values), and implementing dimensional modeling to build a robust Star Schema.  
   **[資料倉儲與清洗階段](https://github.com/Rselayva/mysql-data-warehouse-project.git)**：負責原始資料的引入、透過 ETL 進行資料清洗、處理缺失值與異常值，並依據維度建模建立星狀模型。
2. **Business Analytics & Reporting Phase (This Repository)**: This stage directly connects to the cleaned, production-ready data warehouse. It focuses on writing optimized, high-performance MySQL queries to extract meaningful business metrics and actionable insights.  
   **商業分析與報表階段 (本儲存庫)**：直接串接上述清洗完畢的資料庫，專注於編寫高效能的 MySQL 語法，以萃取商業洞察。

---
## 📜 License（授權）

This project is licensed under the [MIT License](LICENSE) and is intended for learning and reference purposes. You are free to use, modify, and share this project, provided that proper attribution to the original author is retained.  
本專案採用 [MIT 授權條款](LICENSE)，供學習與參考使用。你可以自由使用、修改與分享本專案內容，但需保留適當的原始作者標註。

---
## ⭐ About Me（關於我）

Hi, I’m James, a computer programming student with a strong interest in data engineering and data analytics. I enjoy building end-to-end data solutions, from data processing and data warehousing to turning data into meaningful insights for decision-making.  
Hi, 我是 James，一名主修程式設計的學生，對資料工程與資料分析領域有濃厚興趣。我喜歡打造端到端的資料解決方案，從資料處理與資料倉儲，到將資料轉化為有價值的決策資訊。

I am currently focused on improving my skills in SQL, Python, and database systems, and I am actively seeking opportunities as a Junior Data Engineer / Entry-level Data Engineer to gain hands-on industry experience and continue growing professionally.  
目前我專注於提升 SQL、Python 以及資料庫系統相關技能，並積極尋找 Junior Data Engineer / Entry-level Data Engineer 的機會，希望能在實務環境中累積經驗並持續成長。
