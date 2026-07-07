# Import HNRP 2026 data

library(tidyverse)
library(janitor)
library(readxl)

raw_dir <- "data/raw"
processed_dir <- "data/processed"

hnrp_file <- file.path(raw_dir, "jiaf_hnrp_ukraine_2026.xlsx")

# Check workbook structure
sheets <- excel_sheets(hnrp_file)
print(sheets)

# Main sheets used for the first stage of the analysis
overall_sp_uoa <- read_excel(
  hnrp_file,
  sheet = "Overall by SP and UoA",
  skip = 6
) %>%
  clean_names()

idps <- read_excel(
  hnrp_file,
  sheet = "IDPs",
  skip = 6
) %>%
  clean_names()

wand <- read_excel(
  hnrp_file,
  sheet = "WAND",
  skip = 6
) %>%
  clean_names()

ref_adm3 <- read_excel(
  hnrp_file,
  sheet = "Ref ADM3",
  skip = 5
) %>%
  clean_names()

# Quick structure check
glimpse(overall_sp_uoa)
glimpse(idps)
glimpse(wand)
glimpse(ref_adm3)

# Missing values overview for the main dataset
missing_overall <- overall_sp_uoa %>%
  summarise(across(everything(), ~ sum(is.na(.)))) %>%
  pivot_longer(
    cols = everything(),
    names_to = "variable",
    values_to = "missing_count"
  ) %>%
  arrange(desc(missing_count))

print(missing_overall)

# Save imported sheets with cleaned column names
write_csv(
  overall_sp_uoa,
  file.path(processed_dir, "overall_sp_uoa_imported.csv")
)

write_csv(
  idps,
  file.path(processed_dir, "idps_imported.csv")
)

write_csv(
  wand,
  file.path(processed_dir, "wand_imported.csv")
)

write_csv(
  ref_adm3,
  file.path(processed_dir, "ref_adm3_imported.csv")
)
