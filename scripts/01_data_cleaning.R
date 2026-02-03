# ============================================================================
# 01_data_cleaning.R
# Clean and Prepare the CARDIAC Dataset
# ============================================================================
# Author: Qiao Sen Chen
# Date: 2026-02-05
# Purpose: Clean raw data and create analysis-ready dataset
#
# Input:  data/raw/cardiac_raw_data.rds
# Output: data/processed/cardiac_clean.rds
#         data/processed/cardiac_clean.csv
#         docs/data_cleaning_log.csv
#
# Note: This script should be run from the project root directory
# ============================================================================

# Load required packages
library(tidyverse)

# Define paths
RAW_DATA_DIR <- "data/raw"
PROCESSED_DATA_DIR <- "data/processed"
DOCS_DIR <- "docs"

# Create directories if they don't exist
if (!dir.exists(PROCESSED_DATA_DIR)) {
  dir.create(PROCESSED_DATA_DIR, recursive = TRUE)
}
if (!dir.exists(DOCS_DIR)) {
  dir.create(DOCS_DIR, recursive = TRUE)
}

# ============================================================================
# 1. Load Raw Data
# ============================================================================
cat("Loading raw data...\n")

cardiac_raw <- readRDS(file.path(RAW_DATA_DIR, "cardiac_raw_data.rds"))

cat("  Loaded", nrow(cardiac_raw), "observations\n\n")

# ============================================================================
# 2. Data Cleaning
# ============================================================================
cat("Cleaning data...\n")

# Initialize cleaning log
cleaning_log <- tibble(
  step = integer(),
  action = character(),
  n_affected = integer(),
  notes = character()
)

n_start <- nrow(cardiac_raw)

# Step 1: Remove duplicate IDs
cardiac_clean <- cardiac_raw %>%
  distinct(patient_id, .keep_all = TRUE)

n_dup <- n_start - nrow(cardiac_clean)
cleaning_log <- cleaning_log %>%
  add_row(step = 1, action = "Removed duplicate patient IDs",
          n_affected = n_dup, notes = "Kept first occurrence")
cat("  Step 1: Removed", n_dup, "duplicate IDs\n")

# Step 2: Standardize sex variable
cardiac_clean <- cardiac_clean %>%
  mutate(
    sex = case_when(
      sex %in% c("Male", "M", "1") ~ "Male",
      sex %in% c("Female", "F", "2") ~ "Female",
      TRUE ~ NA_character_
    )
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 2, action = "Standardized sex variable",
          n_affected = 0, notes = "Recoded M/F/1/2 to Male/Female")
cat("  Step 2: Standardized sex coding\n")

# Step 3: Standardize smoking status
cardiac_clean <- cardiac_clean %>%
  mutate(
    smoking_status = case_when(
      tolower(smoking_status) == "never" ~ "Never",
      tolower(smoking_status) == "former" ~ "Former",
      tolower(smoking_status) == "current" ~ "Current",
      smoking_status == "Unknown" ~ NA_character_,
      TRUE ~ NA_character_
    )
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 3, action = "Standardized smoking status",
          n_affected = 0, notes = "Harmonized case, Unknown → NA")
cat("  Step 3: Standardized smoking status\n")

# Step 4: Standardize physical activity
cardiac_clean <- cardiac_clean %>%
  mutate(
    physical_activity = case_when(
      tolower(physical_activity) == "low" ~ "Low",
      tolower(physical_activity) == "moderate" ~ "Moderate",
      tolower(physical_activity) == "high" ~ "High",
      TRUE ~ NA_character_
    )
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 4, action = "Standardized physical activity",
          n_affected = 0, notes = "Harmonized case differences")
cat("  Step 4: Standardized physical activity\n")

# Step 5: Standardize binary medical history variables
cardiac_clean <- cardiac_clean %>%
  mutate(
    diabetes = case_when(
      diabetes %in% c("1", "Yes") ~ 1,
      diabetes %in% c("0", "No") ~ 0,
      TRUE ~ NA_real_
    ),
    hypertension = case_when(
      hypertension %in% c("1", "Yes") ~ 1,
      hypertension %in% c("0", "No") ~ 0,
      TRUE ~ NA_real_
    )
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 5, action = "Standardized diabetes/hypertension coding",
          n_affected = 0, notes = "Converted Yes/No to 1/0")
cat("  Step 5: Standardized medical history coding\n")

# Step 6: Handle impossible values (set to NA)
n_age_invalid <- sum(cardiac_clean$age < 0 | cardiac_clean$age > 120, na.rm = TRUE)
n_sbp_invalid <- sum(cardiac_clean$sbp < 60 | cardiac_clean$sbp > 300, na.rm = TRUE)
n_bmi_invalid <- sum(cardiac_clean$bmi < 10 | cardiac_clean$bmi > 60, na.rm = TRUE)

cardiac_clean <- cardiac_clean %>%
  mutate(
    age = if_else(age < 0 | age > 120, NA_real_, as.numeric(age)),
    sbp = if_else(sbp < 60 | sbp > 300, NA_integer_, sbp),
    dbp = if_else(dbp < 30 | dbp > 200, NA_integer_, dbp),
    bmi = if_else(bmi < 10 | bmi > 60, NA_real_, bmi)
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 6, action = "Set impossible values to NA",
          n_affected = n_age_invalid + n_sbp_invalid + n_bmi_invalid,
          notes = "age/sbp/bmi out of plausible range")
cat("  Step 6: Set", n_age_invalid + n_sbp_invalid + n_bmi_invalid,
    "impossible values to NA\n")

# Step 7: Handle future dates
n_future <- sum(cardiac_clean$enrollment_date > as.Date("2020-12-31"), na.rm = TRUE)
cardiac_clean <- cardiac_clean %>%
  mutate(
    enrollment_date = if_else(enrollment_date > as.Date("2020-12-31"),
                              NA_Date_, enrollment_date)
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 7, action = "Set future dates to NA",
          n_affected = n_future, notes = "Dates after 2020-12-31")
cat("  Step 7: Set", n_future, "future dates to NA\n")

# Step 8: Convert categoricals to factors
cardiac_clean <- cardiac_clean %>%
  mutate(
    sex = factor(sex, levels = c("Male", "Female")),
    smoking_status = factor(smoking_status, levels = c("Never", "Former", "Current")),
    physical_activity = factor(physical_activity, levels = c("Low", "Moderate", "High")),
    education = case_when(
      education == "Unknown" ~ NA_character_,
      TRUE ~ education
    ),
    education = factor(education, levels = c("Primary", "Secondary", "University"))
  )
cleaning_log <- cleaning_log %>%
  add_row(step = 8, action = "Converted to factor variables",
          n_affected = 0, notes = "Set proper factor levels for categoricals")
cat("  Step 8: Converted to factor variables\n")

# ============================================================================
# 3. Save Outputs
# ============================================================================
cat("\nSaving outputs...\n")

# Save cleaned data
saveRDS(cardiac_clean, file.path(PROCESSED_DATA_DIR, "cardiac_clean.rds"))
write_csv(cardiac_clean, file.path(PROCESSED_DATA_DIR, "cardiac_clean.csv"))
cat("  Saved cleaned data to", PROCESSED_DATA_DIR, "\n")

# Save cleaning log
write_csv(cleaning_log, file.path(DOCS_DIR, "data_cleaning_log.csv"))
cat("  Saved cleaning log to", DOCS_DIR, "\n")

# ============================================================================
# 4. Summary
# ============================================================================
cat("\n=== CLEANING SUMMARY ===\n")
cat("Starting N:", n_start, "\n")
cat("Final N:", nrow(cardiac_clean), "\n")
cat("Observations removed:", n_start - nrow(cardiac_clean), "\n\n")

cat("Missing data summary:\n")
cardiac_clean %>%
  summarise(across(everything(), ~sum(is.na(.)))) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "n_missing") %>%
  filter(n_missing > 0) %>%
  mutate(pct_missing = round(n_missing / nrow(cardiac_clean) * 100, 1)) %>%
  arrange(desc(n_missing)) %>%
  print(n = Inf)

cat("\nDone!\n")
