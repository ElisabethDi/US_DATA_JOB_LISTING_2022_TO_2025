# US_DATA_JOB_LISTING_2022_TO_2025 (SQL & Python)

**In-depth analysis of U.S. job listings for data-related roles from Nov 2022 to Apr 2025 using SQL and Python.**

---

##  Table of Contents
- [Overview](#overview)
- [Data Source](#data-source)
- [Key Analytical Views & Visuals](#key-analytical-views--visuals)
- [Tools & Technologies](#tools--technologies)
- [Getting Started](#-getting-started)
- [Project Structure](#project-structure)
- [License](#license)

---

## Overview
This project analyzes U.S. job postings for data-focused roles — such as **Data Analyst, Business Analyst, Financial Analyst, Healthcare Analyst, Marketing Analyst, Operations Research Analyst, Human Resource Analyst, and Clinical Data Analyst** — spanning **November 2022 to April 2025**.  

Using **MySQL (CTEs & Views)** and **Python visualizations**, the project uncovers:
- Year-over-year **salary trends**
- **Skill demand shifts** in the job market
- Insights into **above/below median salaries** by role

---

## Data Source
- **Source**: Kaggle public dataset  
- **Creator**: Luke Barousse  
- **Dataset**: [lukebarousse/data-analyst-job-postings-google-search](https://www.kaggle.com/datasets/lukebarousse/data-analyst-job-postings-google-search)  
- **File**: `gsearch_jobs.csv` (~62,000 rows spanning 2022–2025)

**Preprocessing Workflow:**
1. Downloaded CSV and opened in **Visual Studio Code**.  
2. Cleaned and transformed with **pandas/NumPy**.  
3. Saved outputs:  
   - Cleaned CSV (ready for MySQL/Excel)  
   - Pickled DataFrame (`df_clean.pkl`)  
4. Loaded into **MySQL database**.  
5. Built **tables, STAR schema, CTEs, views, and stored procedures** for analysis.  

---

## Key Analytical Views & Visuals

### Salary Trends
- `median_salary_2022_cte.sql` … 2025 → **Line chart** of analyst median salaries.  
- `vw_yearly_salary_trend_company (2022–2025)` → **Line chart** of company-level salary changes (% growth/decline).  
- `vw_website_yearly_salary_trend (2022–2025)` → **Line charts** of salary trends by job site (Business Analyst, Data Engineer, Data Scientist).  

### Salary Comparisons
- `vw_above_below_median (2022–2025)` → **Stacked bar chart** of job postings *Below / At / Above* median.  
- `vw_above_below_median (2022–2025)` → **Box plots** showing salary distribution by role with median markers.  

### Skills Analysis
- `vw_skill_stats_median_salary_pct_rank_2023 … 2025` → **Lollipop chart** of top & bottom 5 skills by percentile rank.  
- `vw_skill_stats_mean_median_spread (2022–2025)` → **Bubble chart** comparing mean vs. median salary spread (top 20 skills).  
- `vw_skill_stats_pct_cume_dist (2022–2025)` → **Bar chart** distinguishing *core vs. niche skills* (e.g., SQL/Python vs. MongoDB).  
- `yearly_vs_median_analyst_2022.sql … 2025` → **Vertical bar chart** of top 5 in-demand skills per analyst role.  
- `analyst_mean_median_stats_2023 … 2025` → **Butterfly charts** showing mean–median salary spread by role/skill.  

---

## Tools & Technologies

- **SQL**
  - MySQL: Database schemas, table creation, complex queries, CTEs, views, stored procedures.  

- **Python**
  - Data Manipulation:  
    - `pandas` — cleaning, transformation, analysis  
    - `numpy` — numerical operations, handling missing data  
  - Data Visualization:  
    - `matplotlib` — static/interactive charts  
    - `seaborn` — statistical graphics  
    - `plotly` — interactive web-based visualizations  
  - Utilities:  
    - `os`, `pathlib` — file management  
    - `dotenv` — load environment variables  
    - `SQLAlchemy` (`create_engine`, `text`) — database connectivity  

---

## Getting Started

Set up the project locally in just a few steps:

1. Clone the repo:
 
git clone https://github.com/ElisabethDi/US_DATA_JOB_LISTING_2022_TO_2025.git
cd US_DATA_JOB_LISTING_2022_TO_2025

2. Environment set up:

Using pip:
     pip install -r requirements.txt


Using conda:
    conda env create -f environment.yml
    conda activate us-data-jobs
    
---

## Tools & Technologies
- **SQL**: MySQL — tables, CTEs, views, stored procedures.  
- **Python**:  
  - Data manipulation: `pandas`, `numpy`  
  - Visualization: `matplotlib`, `seaborn`, `plotly`  
  - Utilities: `os`, `pathlib`, `dotenv`, `SQLAlchemy`  

---

Project Structure

US_DATA_JOB_LISTING_2022_TO_2025/
├── sql/ # Tables, CTEs, Views, Stored Procedures
├── visuals/ # Python scripts for charts and visuals
├── requirements.txt # Pip dependencies
├── environment.yml # Conda environment (optional)
├── .env # Environment variables (keep private)
├── .gitignore # Files/folders to ignore in Git
└── README.md # Project documentation

---
 License

This project is open source and available under the MIT License.

