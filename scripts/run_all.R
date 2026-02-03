# run_all.R
# Master pipeline script — sources all steps in order and renders the tutorial.
# Usage: source("scripts/run_all.R")

cat("=== Starting pipeline ===\n\n")

# Step 1: Generate simulated data
cat(">> Step 1: Generating raw data...\n")
source("scripts/00_generate_data.R")

# Step 2: Clean data
cat("\n>> Step 2: Cleaning data...\n")
source("scripts/01_data_cleaning.R")

# Step 3: Render tutorial
cat("\n>> Step 3: Rendering workshop tutorial...\n")
rmarkdown::render("workshop_tutorial.Rmd", quiet = TRUE)

# Summary
cat("\n=== Pipeline complete ===\n")
cat("Generated outputs:\n")
outputs <- c(
  "data/raw/cardiac_raw_data.csv",
  "data/raw/cardiac_raw_data.rds",
  "data/processed/cardiac_clean.csv",
  "data/processed/cardiac_clean.rds",
  "docs/data_cleaning_log.csv",
  "workshop_tutorial.html"
)
for (f in outputs) {
  status <- if (file.exists(f)) "OK" else "MISSING"
  cat(sprintf("  [%s] %s\n", status, f))
}
