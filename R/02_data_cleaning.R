# Clean HNRP 2026 data

library(tidyverse)
library(readr)
library(janitor)
library(stringr)

processed_dir <- "data/processed"

message("Reading imported HNRP files...")

overall_sp_uoa <- read_csv(
  file.path(processed_dir, "overall_sp_uoa_imported.csv"),
  show_col_types = FALSE
)

idps <- read_csv(
  file.path(processed_dir, "idps_imported.csv"),
  show_col_types = FALSE
)

wand <- read_csv(
  file.path(processed_dir, "wand_imported.csv"),
  show_col_types = FALSE
)

clean_uoa_rows <- function(df) {
  df %>%
    filter(
      !is.na(adm1_en),
      !is.na(adm1_pcode),
      str_detect(adm1_pcode, "^UA\\d{2}$")
    ) %>%
    mutate(
      adm1_en = str_squish(adm1_en),
      adm1_pcode = str_squish(adm1_pcode),
      across(
        matches("_joint$"),
        ~ suppressWarnings(readr::parse_number(as.character(.x)))
      )
    )
}

safe_max <- function(x) {
  if (all(is.na(x))) {
    NA_real_
  } else {
    max(x, na.rm = TRUE)
  }
}

message("Cleaning rows and converting numeric columns...")

overall_clean <- clean_uoa_rows(overall_sp_uoa) %>%
  mutate(
    people_affected_row = rowSums(
      across(matches("^overall_aff_sp\\d+_joint$")),
      na.rm = TRUE
    ),
    people_in_need_row = rowSums(
      across(matches("^overall_pin_sp\\d+_joint$")),
      na.rm = TRUE
    ),
    planned_reach_row = rowSums(
      across(matches("^overall_target_sp\\d+_joint$")),
      na.rm = TRUE
    )
  )

idps_clean <- clean_uoa_rows(idps) %>%
  mutate(
    idp_in_need_row = rowSums(
      across(matches("^idp_pin_sp\\d+_joint$")),
      na.rm = TRUE
    ),
    idp_planned_reach_row = rowSums(
      across(matches("^idp_target_sp\\d+_joint$")),
      na.rm = TRUE
    )
  )

wand_clean <- clean_uoa_rows(wand) %>%
  mutate(
    non_displaced_in_need_row = rowSums(
      across(matches("^ndp_pin_sp\\d+_joint$")),
      na.rm = TRUE
    ),
    non_displaced_planned_reach_row = rowSums(
      across(matches("^ndp_target_sp\\d+_joint$")),
      na.rm = TRUE
    )
  )

message("Aggregating data to oblast level...")

overall_oblast <- overall_clean %>%
  group_by(adm1_en, adm1_pcode) %>%
  summarise(
    population_total = sum(overall_all_total_joint, na.rm = TRUE),
    people_affected = sum(people_affected_row, na.rm = TRUE),
    people_in_need = sum(people_in_need_row, na.rm = TRUE),
    planned_reach = sum(planned_reach_row, na.rm = TRUE),
    severity_max = safe_max(overall_sev_total_joint),
    .groups = "drop"
  ) %>%
  mutate(
    response_coverage = if_else(
      people_in_need > 0,
      planned_reach / people_in_need,
      NA_real_
    )
  )

idps_oblast <- idps_clean %>%
  group_by(adm1_en, adm1_pcode) %>%
  summarise(
    idp_total = sum(idp_all_total_joint, na.rm = TRUE),
    idp_in_need = sum(idp_in_need_row, na.rm = TRUE),
    idp_planned_reach = sum(idp_planned_reach_row, na.rm = TRUE),
    idp_severity_max = safe_max(idp_sev_total_joint),
    .groups = "drop"
  )

wand_oblast <- wand_clean %>%
  group_by(adm1_en, adm1_pcode) %>%
  summarise(
    non_displaced_total = sum(ndp_all_total_joint, na.rm = TRUE),
    non_displaced_in_need = sum(non_displaced_in_need_row, na.rm = TRUE),
    non_displaced_planned_reach = sum(non_displaced_planned_reach_row, na.rm = TRUE),
    non_displaced_severity_max = safe_max(ndp_sev_total_joint),
    .groups = "drop"
  )

humanitarian_needs_clean <- overall_oblast %>%
  left_join(idps_oblast, by = c("adm1_en", "adm1_pcode")) %>%
  left_join(wand_oblast, by = c("adm1_en", "adm1_pcode")) %>%
  arrange(desc(people_in_need))

message("Saving cleaned datasets...")

write_csv(
  overall_oblast,
  file.path(processed_dir, "overall_oblast_clean.csv")
)

write_csv(
  idps_oblast,
  file.path(processed_dir, "idps_oblast_clean.csv")
)

write_csv(
  wand_oblast,
  file.path(processed_dir, "wand_oblast_clean.csv")
)

write_csv(
  humanitarian_needs_clean,
  file.path(processed_dir, "humanitarian_needs_clean.csv")
)

message("Done. Cleaned dataset saved to data/processed/humanitarian_needs_clean.csv")

print(
  humanitarian_needs_clean %>%
    select(
      adm1_en,
      people_in_need,
      planned_reach,
      response_coverage,
      severity_max
    ) %>%
    arrange(desc(people_in_need)),
  n = 30
)