# Workshop: The First Steps After Receiving a Dataset

**Author:** Qiao Sen Chen, PhD Student, MEB, Karolinska Institutet
**Date:** February 5, 2026
**Duration:** 3 hours (13:00-16:00)

## Overview

This workshop guides participants through the essential first steps after receiving a dataset for epidemiological research. Topics include defining outcomes/exposures/covariates, drafting a statistical analysis plan, data cleaning and quality control, exploratory data analysis, handling missing data, and preparing an analysis-ready dataset.

The workshop uses R for demonstrations and exercises, but the workflow and logic apply equally well to other languages.

## Project Structure

```
├── README.md                      # This file
├── workshop_tutorial.Rmd          # Main tutorial (R Markdown)
│
├── data/
│   ├── raw/                       # Raw data (never modified)
│   │   ├── cardiac_raw_data.csv
│   │   └── cardiac_raw_data.rds
│   └── processed/                 # Cleaned, analysis-ready data
│       ├── cardiac_clean.csv
│       └── cardiac_clean.rds
│
├── scripts/
│   ├── 00_generate_data.R         # Generate simulated dataset
│   └── 01_data_cleaning.R         # Standalone cleaning script
│
├── docs/
│   ├── INSTRUCTOR_GUIDE.md        # Teaching notes and tips
│   ├── data_dictionary.md         # Variable definitions
│   └── data_cleaning_log.csv      # Documentation of cleaning steps
│
└── output/
    ├── figures/                   # Generated figures
    └── tables/                    # Generated tables
```

## Getting Started

### Prerequisites

Install the required R packages:

```r
install.packages(c(
  "tidyverse",      # Data manipulation and visualization
  "skimr",          # Comprehensive data summaries
  "DataExplorer",   # Automated EDA
  "naniar",         # Missing data visualization
  "mice",           # Multiple imputation
  "gtsummary",      # Publication-ready tables
  "tableone",       # Baseline characteristics table
  "patchwork"       # Combine ggplots
))
```

### Quick Start

1. **Generate the simulated dataset:**
   ```r
   source("scripts/00_generate_data.R")
   ```

2. **Open the tutorial:**
   Open `workshop_tutorial.Rmd` in RStudio and knit to HTML.

3. **Or run the standalone cleaning script:**
   ```r
   source("scripts/01_data_cleaning.R")
   ```

## Workshop Schedule

| Time        | Topic                                    |
|-------------|------------------------------------------|
| 13:00-13:10 | Introduction & Setup                     |
| 13:10-13:35 | Defining Outcomes/Exposures/Covariates   |
| 13:35-14:00 | Drafting a Statistical Analysis Plan     |
| 14:00-14:10 | **Break**                                |
| 14:10-14:45 | Data Cleaning and Quality Control        |
| 14:45-15:15 | Exploratory Data Analysis                |
| 15:15-15:25 | **Break**                                |
| 15:25-15:50 | Missing Data, Recoding & Final Prep      |
| 15:50-16:00 | Q&A and Wrap-up                          |

## Dataset: The CARDIAC Study

A simulated prospective cohort study examining risk factors for cardiovascular disease (CVD) events.

- **Population:** 2,000 adults aged 40-80 years
- **Follow-up:** Up to 10 years
- **Primary Outcome:** First cardiovascular event (MI, stroke, or CVD death)

The raw dataset intentionally contains common data quality issues for teaching purposes:
- Duplicate patient IDs
- Impossible values (age, blood pressure, BMI)
- Inconsistent categorical coding
- Future dates
- Missing data

## Data Management Principles

This project follows best practices for reproducible research:

1. **Raw data is sacred** - Never modify files in `data/raw/`
2. **Document everything** - Cleaning steps are logged in `docs/`
3. **Separate concerns** - Scripts are numbered and focused
4. **Reproducibility** - Set seeds for random processes
5. **Clear structure** - Logical folder organization

## License

This material is provided for educational purposes.

## Contact

Qiao Sen Chen
Department of Medical Epidemiology and Biostatistics
Karolinska Institutet
Email: qiaosen.chen@ki.se
