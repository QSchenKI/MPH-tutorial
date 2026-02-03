# Data Dictionary: CARDIAC Study

## Overview

This document describes all variables in the CARDIAC study dataset.

- **Raw data:** `data/raw/cardiac_raw_data.csv`
- **Cleaned data:** `data/processed/cardiac_clean.csv`

## Variable Definitions

### Identifiers

| Variable | Type | Description | Notes |
|----------|------|-------------|-------|
| `patient_id` | Character | Unique patient identifier | Format: P0001-P2000 |

### Demographics

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `age` | Numeric | 40-80 | Age at enrollment (years) |
| `sex` | Factor | Male, Female | Biological sex |
| `education` | Factor | Primary, Secondary, University | Highest education level |

### Clinical Measurements

| Variable | Type | Units | Plausible Range | Description |
|----------|------|-------|-----------------|-------------|
| `sbp` | Integer | mmHg | 60-300 | Systolic blood pressure |
| `dbp` | Integer | mmHg | 30-200 | Diastolic blood pressure |
| `bmi` | Numeric | kg/m² | 10-60 | Body mass index |
| `cholesterol_total` | Numeric | mmol/L | - | Total cholesterol |
| `hdl` | Numeric | mmol/L | - | HDL cholesterol |
| `ldl` | Numeric | mmol/L | - | LDL cholesterol |
| `glucose_fasting` | Numeric | mmol/L | - | Fasting blood glucose |

### Lifestyle Factors

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `smoking_status` | Factor | Never, Former, Current | Smoking history |
| `alcohol_units_week` | Integer | 0+ | Alcohol consumption (units/week) |
| `physical_activity` | Factor | Low, Moderate, High | Self-reported leisure activity |

### Medical History

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `diabetes` | Binary | 0=No, 1=Yes | History of diabetes |
| `hypertension` | Binary | 0=No, 1=Yes | History of hypertension |
| `family_history_cvd` | Binary | 0=No, 1=Yes | Family history of CVD |

### Medications

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `statin_use` | Binary | 0=No, 1=Yes | Currently using statins |
| `antihypertensive_use` | Binary | 0=No, 1=Yes | Currently using antihypertensives |

### Outcome

| Variable | Type | Values | Description |
|----------|------|--------|-------------|
| `cvd_event` | Binary | 0=No, 1=Yes | First CVD event during follow-up |
| `follow_up_years` | Numeric | 0.5-10 | Time from enrollment to event or censoring |

### Dates

| Variable | Type | Format | Description |
|----------|------|--------|-------------|
| `enrollment_date` | Date | YYYY-MM-DD | Date of study enrollment |

## Derived Variables (in processed data)

| Variable | Type | Values | Description | Derivation |
|----------|------|--------|-------------|------------|
| `age_category` | Factor | 40-49, 50-59, 60-69, 70-80 | Age group | Cut age into 10-year bands |
| `bmi_category` | Factor | Underweight, Normal, Overweight, Obese | BMI category | WHO classification |
| `obese` | Binary | 0, 1 | Obesity indicator | BMI ≥ 30 |
| `hypertensive_bp` | Binary | 0, 1 | Hypertensive by BP | SBP ≥ 140 or DBP ≥ 90 |
| `n_risk_factors` | Integer | 0-6 | Risk factor count | Sum of: age≥60, current smoker, diabetes, hypertension, obese, high cholesterol |
| `risk_category` | Factor | Low, Moderate, High | CVD risk category | Based on n_risk_factors |

## Data Quality Notes

### Raw Data Issues (Intentionally Planted)

1. **Duplicate IDs:** Rows 500 and 1000 have duplicate patient_id
2. **Impossible values:**
   - Age: rows 15 (150), 234 (-5), 567 (999)
   - SBP: rows 89 (350), 456 (40)
   - BMI: rows 123 (5), 789 (75)
3. **Future dates:** Rows 100 (2030-01-01), 200 (2028-06-15)
4. **Inconsistent coding:**
   - sex: 'Male', 'Female', 'M', 'F', '1', '2'
   - smoking_status: Mixed case ('Never' vs 'never')
   - diabetes/hypertension: Mixed 0/1 and Yes/No

### Cleaning Applied

See `docs/data_cleaning_log.csv` for full documentation.

## Missing Data Summary

Missing data is present in the following variables (approximate percentages):
- smoking_status: ~10%
- physical_activity: ~10%
- diabetes: ~10%
- hypertension: ~10%
- education: ~5-10%
- family_history_cvd: ~15%
- statin_use: ~10%
- antihypertensive_use: ~10%
- sex: ~4%
