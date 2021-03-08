df_raw <- tibble::tribble(
  ~off_loc, ~pt_loc,     ~pt_lat,    ~off_lat,     ~pt_long,    ~off_long,
  "A",     "G", 100.0754822,  121.271083,  4.472089953,    -7.188632,
  "B",     "H",   75.191326, 75.93845266,  -144.387785, -143.2288569,
  "C",     "I", 122.6513448,  135.043791, -40.45611048,    21.242563,
  "D",     "J", 124.1355333,  134.511284, -46.07156181,    40.937417,
  "E",     "K", 124.1355333,  134.484374, -46.07156181,     40.78472,
  "F",     "L", 124.0102891,  137.962195, -46.01594293,    22.905889
)

col_names <- c("loc", "lat", "long")
off <- select(df_raw, starts_with("off")) %>% setNames(col_names)
pt <- select(df_raw, starts_with("pt")) %>% setNames(col_names)
bind_rows(off, pt)



breast_raw <- 
  list.files(path = here("data"),
             pattern = "\\d{4}-breast-vias-raw\\.xls", 
             full.names = TRUE
  ) %>%
  sapply(readxl::read_excel, simplify = FALSE) %>% 
  bind_rows() %>% filter(`Result ID` == "VS20-00147")

# Preserve columns to label cases
id_cols <- 
  breast_raw %>% mutate(row = row.names())
  select(c(`Date Collected`, `Result ID`, Age, Pathologist, `Repeat Case`)) %>% 
  mutate(row = rownames())

id_cols <- breast_raw[, c(1:5)] %>% 
  transmutate(row = rownames())

# Drop id_cols from data set
data_cols <- breast_raw[, -c(1:5)]

# Define column names
col_names <- c("Block", "Site", "Cancer_Type", "Tumor Type", 
               "Tumor Grade", "Tissue Decal", "ER IHC", "ER %", "PR IHC", 
               "PR %", "Her2 IHC", "Her2 ICH Result", "Ki-67%", "Her2 ISH", 
               "Her2 ISH Ratio", "Her2 Avg", "Chromosome 17 Avg", "Her2 Fish", 
               "ER Onco", "PR Onco", "Her2 Onco", "Recurrance", 
               "Her2 IHC Result")

# Select data from each block
b1 <- select(breast_raw, ends_with("_1")) %>% setNames(col_names)
b2 <- select(breast_raw, ends_with("_2")) %>% setNames(col_names)
b3 <- select(breast_raw, ends_with("_3")) %>% setNames(col_names)
b4 <- select(breast_raw, ends_with("_4")) %>% setNames(col_names)

# Combine ID columns with data columns
one <- cbind(col_names, b1)

bind_rows(b1, b2, b3, b4)
