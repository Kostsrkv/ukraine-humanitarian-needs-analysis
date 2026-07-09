# Visualise HNRP 2026 oblast-level indicators

required_packages <- c("tidyverse", "readr", "scales", "ggrepel")

missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Missing packages: ",
    paste(missing_packages, collapse = ", "),
    ". Install them before running this script."
  )
}

library(tidyverse)
library(readr)
library(scales)
library(ggrepel)

processed_dir <- "data/processed"
charts_dir <- "outputs/charts"

dir.create(charts_dir, recursive = TRUE, showWarnings = FALSE)

humanitarian_needs <- read_csv(
  file.path(processed_dir, "humanitarian_needs_clean.csv"),
  show_col_types = FALSE
)

format_people <- function(x) {
  case_when(
    abs(x) >= 1e6 ~ paste0(round(x / 1e6, 2), "M"),
    abs(x) >= 1e3 ~ paste0(round(x / 1e3, 0), "K"),
    TRUE ~ as.character(round(x, 0))
  )
}

caption_note <- paste(
  "Source: HNRP 2026 / HDX JIAF dataset.",
  "Note: Planned reach is a planning target, not actual assistance delivered."
)

top_needs <- humanitarian_needs %>%
  arrange(desc(people_in_need)) %>%
  slice_head(n = 10) %>%
  mutate(
    adm1_en = fct_reorder(adm1_en, people_in_need)
  )

# 1. Top oblasts by estimated people in need

people_in_need_plot <- top_needs %>%
  ggplot(
    aes(
      x = adm1_en,
      y = people_in_need
    )
  ) +
  geom_col(fill = "grey35") +
  geom_text(
    aes(label = format_people(people_in_need)),
    hjust = -0.15,
    size = 3.5
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = comma,
    expand = expansion(mult = c(0, 0.12))
  ) +
  labs(
    title = "Estimated people in need by oblast, HNRP 2026",
    subtitle = "Top 10 oblasts by estimated humanitarian need",
    x = NULL,
    y = "People in need",
    caption = "Source: HNRP 2026 / HDX JIAF dataset."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave(
  filename = file.path(charts_dir, "top_people_in_need.png"),
  plot = people_in_need_plot,
  width = 10,
  height = 6,
  dpi = 300
)

# 2. People in need vs planned reach

coverage_comparison_data <- top_needs %>%
  select(adm1_en, people_in_need, planned_reach) %>%
  pivot_longer(
    cols = c(people_in_need, planned_reach),
    names_to = "indicator",
    values_to = "value"
  ) %>%
  mutate(
    indicator = recode(
      indicator,
      people_in_need = "Estimated people in need",
      planned_reach = "Planned reach"
    ),
    indicator = factor(
      indicator,
      levels = c("Estimated people in need", "Planned reach")
    )
  )

coverage_comparison_plot <- coverage_comparison_data %>%
  ggplot(
    aes(
      x = adm1_en,
      y = value,
      fill = indicator
    )
  ) +
  geom_col(
    position = position_dodge(width = 0.75),
    width = 0.65
  ) +
  geom_text(
    aes(label = format_people(value)),
    position = position_dodge(width = 0.75),
    hjust = -0.15,
    size = 3.1
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = comma,
    expand = expansion(mult = c(0, 0.18))
  ) +
  scale_fill_manual(
    values = c(
      "Estimated people in need" = "grey35",
      "Planned reach" = "grey70"
    )
  ) +
  labs(
    title = "Estimated people in need and planned reach, HNRP 2026",
    subtitle = "Top 10 oblasts by estimated humanitarian need",
    x = NULL,
    y = "People",
    fill = NULL,
    caption = caption_note
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "bottom"
  )

ggsave(
  filename = file.path(charts_dir, "people_in_need_vs_planned_reach.png"),
  plot = coverage_comparison_plot,
  width = 10,
  height = 6,
  dpi = 300
)

# 3. Planned response coverage by oblast

response_coverage_plot <- humanitarian_needs %>%
  filter(!is.na(response_coverage), people_in_need > 0) %>%
  arrange(response_coverage) %>%
  mutate(
    adm1_en = fct_reorder(adm1_en, response_coverage)
  ) %>%
  ggplot(
    aes(
      x = adm1_en,
      y = response_coverage
    )
  ) +
  geom_col(fill = "grey35") +
  geom_text(
    aes(label = percent(response_coverage, accuracy = 1)),
    hjust = -0.15,
    size = 3.2
  ) +
  coord_flip() +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, NA),
    expand = expansion(mult = c(0, 0.12))
  ) +
  labs(
    title = "Planned response coverage by oblast, HNRP 2026",
    subtitle = "Planned reach as a share of estimated people in need",
    x = NULL,
    y = "Response coverage",
    caption = caption_note
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave(
  filename = file.path(charts_dir, "response_coverage_by_oblast.png"),
  plot = response_coverage_plot,
  width = 10,
  height = 8,
  dpi = 300
)

# 4. Humanitarian needs and planned response coverage

key_oblasts <- c(
  "Kharkivska",
  "Dnipropetrovska",
  "Zaporizka",
  "Sumska",
  "Donetska",
  "Mykolaivska",
  "Kyiv",
  "Khersonska"
)

scatter_data <- humanitarian_needs %>%
  filter(!is.na(response_coverage), people_in_need > 0)

scatter_labels <- scatter_data %>%
  filter(adm1_en %in% key_oblasts)

needs_coverage_plot <- scatter_data %>%
  ggplot(
    aes(
      x = people_in_need,
      y = response_coverage,
      size = severity_max
    )
  ) +
  geom_point(
    alpha = 0.75,
    colour = "grey25"
  ) +
  geom_text_repel(
    data = scatter_labels,
    aes(label = adm1_en),
    size = 3.2,
    max.overlaps = Inf,
    box.padding = 0.4,
    point.padding = 0.3,
    min.segment.length = 0
  ) +
  scale_x_continuous(
    labels = comma,
    expand = expansion(mult = c(0.03, 0.10))
  ) +
  scale_y_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, 1),
    expand = expansion(mult = c(0.03, 0.06))
  ) +
  scale_size_continuous(
    breaks = c(3, 4, 5),
    range = c(2.5, 7)
  ) +
  labs(
    title = "Humanitarian needs and planned response coverage, HNRP 2026",
    subtitle = "Each point represents one oblast; selected high-need oblasts are labelled",
    x = "Estimated people in need",
    y = "Response coverage",
    size = "Max severity",
    caption = caption_note
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "right"
  )

ggsave(
  filename = file.path(charts_dir, "needs_vs_response_coverage.png"),
  plot = needs_coverage_plot,
  width = 11,
  height = 7,
  dpi = 300
)

message("Polished charts saved to outputs/charts")