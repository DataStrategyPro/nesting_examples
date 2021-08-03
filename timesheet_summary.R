library(tidyverse)

timesheets <- read_csv("data/timesheets.csv")

timesheets %>% 
  arrange(empid,start_date) %>% 
  nest(-empid) %>% 
  mutate(data = data %>% map(
    ~mutate(.,
      n_days = start_date - lag(start_date),
      first_date = ifelse(is.na(n_days) | n_days > 1,as.character(start_date) ,NA)
      ) %>% 
    fill(first_date) %>% 
    mutate(first_date = as.Date(first_date)) %>% 
    group_by(first_date) %>% 
    summarise(last_date = max(end_date)) %>% 
    mutate(n = row_number())
  )) %>% 
  unnest()
  
