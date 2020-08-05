# Data Load 

pacman::p_load(readr, tidyverse, plotly, tidymodels, mice, kableExtra, stringr, DescTools, scales, doParallel)

Conmebol_raw <- read_csv("conmebol.csv") %>%
  select(-X1, -rating) 

# Data Cleaning

#Lets convert value into a number and clean the names of the players

Conmebol <- Conmebol_raw %>%
  mutate(value2 = str_sub(value,-1,-1),
         value = parse_number(value),
         value = case_when(value2 == "M" ~ value * 1000000,
                           value2 == "K" ~ value * 1000,
                           TRUE ~ 0)) %>% 
  na_if(.,0)



