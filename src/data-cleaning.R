# Clean breast carcinoma data for annual CAP reporting

# Load libraries
library(tidyverse)
library(here)
library(readxl)

# Import data
breast_raw <- 
  list.files(path = here("data"),
             pattern = "\\d{4}-breast-vias-raw\\.xls", 
             full.names = TRUE
  ) %>%
  sapply(readxl::read_excel, simplify = FALSE) %>% 
  bind_rows() %>% filter(`Result ID` == "VS20-00147")
  mutate(across(everything(), as.character)) %>% 

# Pivot data to long format
breast_long <- 
  breast_raw %>% 
  pivot_longer(!c(`Date Collected`, 
                  `Result ID`,
                  Age, Pathologist, `Repeat Case`), 
               names_to = "field",
               values_to = "value")

breast_names <- 
  breast_long %>% 
  mutate(
    field = str_replace(field, "_\\d", ""))

breast_clean <- 
  breast_names %>% 
  mutate(row = row_number()) %>% 
  pivot_wider(names_from = "field", 
              values_from = "value")
