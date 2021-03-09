library(tidyverse)

breast_raw <- 
  list.files(path = here::here("data"),
             pattern = "\\d{4}-breast-vias-raw\\.csv", 
             full.names = TRUE
  ) %>%
  sapply(readr::read_csv, simplify = FALSE) %>% 
  bind_rows() # %>% filter(`Result ID` == "VS20-00147" | 
                           # `Result ID` =="OS20-26222")

# Preserve columns to label cases
# id_cols <- 
#   breast_raw %>% 
#   select(c(`Date Collected`, `Result ID`, Age, Pathologist, `Repeat Case`)) %>% 
#   mutate(row = rownames(breast_raw))

id_cols <- breast_raw[, c(1:5)] %>% 
  setNames(c("Collected_Date", "Result_ID", "Age", "Pathologist", "Repeat"))

# Drop id_cols from data set
data_cols <- breast_raw[, -c(1:5)] 

# Define column names
col_names <- c("Block_ID", "Site", "Cancer_Type", "Tumor_Type", 
               "Grade", "Tissue_Decal", "ER_IHC", "ER_Percent", "PR_IHC", 
               "PR_Percent", "Her2_IHC", "Her2_IHC_Result", "Ki67_Percent", 
               "Her2_ISH", "Her2_ISH_Ratio", "Her2_avg", "CHR17_avg", "Her2_FISH", 
               "ER_Onco", "PR_Onco", "Her2_Onco", "Recurrance_Score")

# Select data from each block
b1 <- bind_cols(id_cols, 
                select(breast_raw, ends_with("_1")) %>% setNames(col_names))
b2 <- bind_cols(id_cols, 
                select(breast_raw, ends_with("_2")) %>% setNames(col_names))
b3 <- bind_cols(id_cols, 
                select(breast_raw, ends_with("_3")) %>% setNames(col_names))
b4 <- bind_cols(id_cols, 
                select(breast_raw, ends_with("_4")) %>% setNames(col_names))

# Combine ID columns with data columns
df_test <- bind_rows(b1, b2, b3, b4) %>% 
  # filter(!is.na(Block_ID)) %>% 
  arrange(`Result_ID`)
