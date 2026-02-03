# ============================================================================
# 00_generate_data.R
# Generate Simulated CARDIAC Dataset for Workshop
# ============================================================================
# Author: Qiao Sen Chen
# Date: 2026-02-05
# Purpose: Create a realistic epidemiological dataset with intentional data
#          quality issues for teaching data cleaning and preparation
#
# Output: data/raw/cardiac_raw_data.csv
#         data/raw/cardiac_raw_data.rds
#
# Note: This script should be run from the project root directory
# ============================================================================

# Load required packages
library(tidyverse)

# Define paths (relative to project root)
RAW_DATA_DIR <- "data/raw"

# Create directory if it doesn't exist
if (!dir.exists(RAW_DATA_DIR)) {
  dir.create(RAW_DATA_DIR, recursive = TRUE)
}

# Set seed for reproducibility
set.seed(2026)

# Sample size
n <- 2000

cat("Generating simulated CARDIAC dataset (n =", n, ")...\n\n")

# Generate the simulated CARDIAC dataset
cardiac_raw <- tibble(
  # Identifiers
  patient_id = paste0("P", sprintf("%04d", 1:n)),

  # Demographics
  age = round(rnorm(n, mean = 58, sd = 10)),
  sex = sample(c("Male", "Female", "M", "F", "1", "2", NA), n,
               replace = TRUE, prob = c(0.30, 0.30, 0.10, 0.10, 0.08, 0.08, 0.04)),
  education = sample(c("Primary", "Secondary", "University", "Unknown", NA), n,
                     replace = TRUE, prob = c(0.15, 0.40, 0.35, 0.05, 0.05)),

  # Clinical measurements (with some issues)
  sbp = round(rnorm(n, mean = 135, sd = 20)),       # Systolic BP
  dbp = round(rnorm(n, mean = 82, sd = 12)),        # Diastolic BP
  bmi = round(rnorm(n, mean = 27, sd = 5), 1),
  cholesterol_total = round(rnorm(n, mean = 5.5, sd = 1.2), 1),
  hdl = round(rnorm(n, mean = 1.4, sd = 0.4), 1),
  ldl = round(rnorm(n, mean = 3.4, sd = 1.0), 1),
  glucose_fasting = round(rnorm(n, mean = 5.8, sd = 1.5), 1),

  # Lifestyle factors
  smoking_status = sample(c("Never", "Former", "Current", "never",
                           "former", "current", "Unknown", NA), n,
                         replace = TRUE, prob = c(0.25, 0.20, 0.15, 0.10,
                                                  0.08, 0.07, 0.05, 0.10)),
  alcohol_units_week = round(pmax(0, rnorm(n, mean = 8, sd = 8))),
  physical_activity = sample(c("Low", "Moderate", "High", "low",
                               "moderate", "high", NA), n,
                            replace = TRUE, prob = c(0.15, 0.20, 0.15,
                                                     0.15, 0.15, 0.10, 0.10)),

  # Medical history (0/1 coding with some inconsistencies)
  diabetes = sample(c(0, 1, "Yes", "No", NA), n,
                   replace = TRUE, prob = c(0.40, 0.20, 0.15, 0.15, 0.10)),
  hypertension = sample(c(0, 1, "Yes", "No", NA), n,
                       replace = TRUE, prob = c(0.30, 0.30, 0.15, 0.15, 0.10)),
  family_history_cvd = sample(c(0, 1, NA), n,
                              replace = TRUE, prob = c(0.50, 0.35, 0.15)),

  # Medications
  statin_use = sample(c(0, 1, NA), n, replace = TRUE, prob = c(0.60, 0.30, 0.10)),
  antihypertensive_use = sample(c(0, 1, NA), n,
                                replace = TRUE, prob = c(0.55, 0.35, 0.10)),

  # Dates
  enrollment_date = as.Date("2010-01-01") + sample(0:1825, n, replace = TRUE),

  # Outcome
  cvd_event = sample(c(0, 1), n, replace = TRUE, prob = c(0.85, 0.15)),

  # Follow-up time (years)
  follow_up_years = round(runif(n, min = 0.5, max = 10), 2)
)

# Add some realistic data quality issues
cardiac_raw <- cardiac_raw %>%
  mutate(
    # Some impossible values - each row needs its own condition
    age = case_when(
      row_number() == 15 ~ 150,
      row_number() == 234 ~ -5,
      row_number() == 567 ~ 999,
      TRUE ~ age
    ),
    sbp = case_when(
      row_number() == 89 ~ 350L,
      row_number() == 456 ~ 40L,
      TRUE ~ sbp
    ),
    bmi = case_when(
      row_number() == 123 ~ 5,
      row_number() == 789 ~ 75,
      TRUE ~ bmi
    ),
    # Some dates in the future
    enrollment_date = case_when(
      row_number() == 100 ~ as.Date("2030-01-01"),
      row_number() == 200 ~ as.Date("2028-06-15"),
      TRUE ~ enrollment_date
    ),
    # Duplicate IDs
    patient_id = case_when(
      row_number() == 500 ~ "P0001",
      row_number() == 1000 ~ "P0002",
      TRUE ~ patient_id
    )
  )

# Save the raw dataset
write_csv(cardiac_raw, file.path(RAW_DATA_DIR, "cardiac_raw_data.csv"))
saveRDS(cardiac_raw, file.path(RAW_DATA_DIR, "cardiac_raw_data.rds"))

# ============================================================================
# DATA QUALITY ISSUES SUMMARY (for instructor reference)
# ============================================================================
cat("\n=== DATA QUALITY ISSUES SUMMARY ===\n")
cat("=== (Intentionally planted for teaching) ===\n\n")

cat("1. DUPLICATE IDs:\n")
cat("   - Row 500 has same ID as row 1 (P0001)\n")
cat("   - Row 1000 has same ID as row 2 (P0002)\n\n")

cat("2. IMPOSSIBLE VALUES:\n")
cat("   - Age: rows 15 (150), 234 (-5), 567 (999)\n")
cat("   - SBP: rows 89 (350), 456 (40)\n")
cat("   - BMI: rows 123 (5), 789 (75)\n\n")

cat("3. FUTURE DATES:\n")
cat("   - Row 100: 2030-01-01\n")
cat("   - Row 200: 2028-06-15\n\n")

cat("4. INCONSISTENT CODING:\n")
cat("   - sex: 'Male', 'Female', 'M', 'F', '1', '2'\n")
cat("   - smoking_status: 'Never', 'never', 'Former', 'former', etc.\n")
cat("   - physical_activity: 'Low', 'low', 'Moderate', 'moderate', etc.\n")
cat("   - diabetes/hypertension: 0, 1, 'Yes', 'No'\n\n")

cat("5. MISSING DATA (~5-15% in various variables)\n\n")

cat("Dataset saved to:\n")
cat("  -", file.path(RAW_DATA_DIR, "cardiac_raw_data.csv"), "\n")
cat("  -", file.path(RAW_DATA_DIR, "cardiac_raw_data.rds"), "\n")
cat("\nDone!\n")
