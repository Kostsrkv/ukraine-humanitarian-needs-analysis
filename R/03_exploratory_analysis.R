# Exploratory analysis of HNRP 2026 oblast-level data

library(tidyverse)
library(readr)
library(scales)

processed_dir <- "data/processed"
tables_dir <- "outputs/tables"
dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)

humanitarian_needs <- read_csv(
  file.path(processed_dir, "humanitarian_needs_clean.csv"),
  show_col_types = FALSE
)

glimpse(humanitarian_needs)

summary_stats <- humanitarian_needs %>%
  summarise(
    oblasts = n(),
    total_people_in_need = sum(people_in_need, na.rm = TRUE),
    total_planned_reach = sum(planned_reach, na.rm = TRUE),
    average_response_coverage = mean(response_coverage, na.rm = TRUE),
    median_response_coverage = median(response_coverage, na.rm = TRUE),
    max_severity = max(severity_max, na.rm = TRUE)
  )

top_people_in_need <- humanitarian_needs %>%
  select(
    adm1_en,
    people_in_need,
    planned_reach,
    response_coverage,
    severity_max
  ) %>%
  arrange(desc(people_in_need)) %>%
  slice_head(n = 10)

lowest_response_coverage <- humanitarian_needs %>%
  filter(
    !is.na(response_coverage),
    people_in_need > 0
  ) %>%
  select(
    adm1_en,
    people_in_need,
    planned_reach,
    response_coverage,
    severity_max
  ) %>%
  arrange(response_coverage) %>%
  slice_head(n = 10)

highest_severity <- humanitarian_needs %>%
  select(
    adm1_en,
    people_in_need,
    planned_reach,
    response_coverage,
    severity_max
  ) %>%
  arrange(desc(severity_max), desc(people_in_need))

summary_by_severity <- humanitarian_needs %>%
  group_by(severity_max) %>%
  summarise(
    oblasts = n(),
    people_in_need = sum(people_in_need, na.rm = TRUE),
    planned_reach = sum(planned_reach, na.rm = TRUE),
    average_response_coverage = mean(response_coverage, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(severity_max))

write_csv(
  summary_stats,
  file.path(tables_dir, "summary_stats.csv")
)

write_csv(
  top_people_in_need,
  file.path(tables_dir, "top_people_in_need.csv")
)

write_csv(
  lowest_response_coverage,
  file.path(tables_dir, "lowest_response_coverage.csv")
)

write_csv(
  highest_severity,
  file.path(tables_dir, "highest_severity.csv")
)

write_csv(
  summary_by_severity,
  file.path(tables_dir, "summary_by_severity.csv")
)

print(summary_stats)
print(top_people_in_need)
print(lowest_response_coverage)
print(summary_by_severity)
