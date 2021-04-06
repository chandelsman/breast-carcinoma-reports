# CAP Her2 survey questions

### What is the annual percentage of 2+ and 3+ IHC for her2 neu in your laboratory?
her2_carcinomas <- 
  breast_cln %>% 
  filter(!is.na(Her2_IHC_Result)) %>% 
  group_by(Her2_IHC_Result) %>% 
  summarise(n = n()) %>% 
  mutate(pct = n / sum(n) * 100, total = sum(n))

two_plus_n <- 
  her2_carcinomas %>% 
  filter(Her2_IHC_Result == "2+") %>% 
  select(n)

two_plus_pct <- 
  her2_carcinomas %>% 
  filter(Her2_IHC_Result == "2+") %>% 
  select(pct)

three_plus_n <- 
  her2_carcinomas %>% 
  filter(Her2_IHC_Result == "3+") %>% 
  select(n)

three_plus_pct <- 
  her2_carcinomas %>% 
  filter(Her2_IHC_Result == "3+") %>% 
  select(pct) 
  
her2_count <- her2_carcinomas$total


# Of Her2 IHC 2+ carcinomas, what is the percentage of ISH positive cases. 
# (we will need to remove the SOCO cases from this calculation since we do not 
# do their ISH studies)

# All cases where Her2 IHC was 2+
breast_cln %>% 
  filter(!str_detect(Result_ID, "BS|GS|SO|BC|GC|SN"),
         Her2_IHC_Result == "2+") %>% 
  group_by(Her2_ISH_class) %>% 
  summarise(n = n()) %>% 
  mutate(pct = n / sum(n) * 100, total = sum(n))

# Remove cases without an ISH result
breast_cln %>% 
  filter(!str_detect(Result_ID, "BS|GS|SO|BC|GC|SN"),
         Her2_IHC_Result == "2+" &
           !is.na(Her2_ISH_class)) %>% 
  group_by(Her2_ISH_class) %>% 
  summarise(n = n()) %>% 
  mutate(pct = n / sum(n) * 100, total = sum(n))
