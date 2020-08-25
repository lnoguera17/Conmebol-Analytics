if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(tidymodels)) install.packages("tidymodels", repos = "http://cran.us.r-project.org")
if(!require(mice)) install.packages("mice", repos = "http://cran.us.r-project.org")
if(!require(kableExtra)) install.packages("kableExtra", repos = "http://cran.us.r-project.org")
if(!require(stringr)) install.packages("stringr", repos = "http://cran.us.r-project.org")
if(!require(DescTools)) install.packages("DescTools", repos = "http://cran.us.r-project.org")
if(!require(scales)) install.packages("scales", repos = "http://cran.us.r-project.org")
if(!require(doParallel)) install.packages("doParallel", repos = "http://cran.us.r-project.org")


# Load Libraries
library(tidyverse)
library(tidymodels)
library(mice)
library(stringr)
library(DescTools)
library(scales)
library(doParallel)


# Data Load 
Conmebol_raw <- read_csv("Scrape_and_Raw_Data/conmebol.csv") %>%
  select(-X1, -rating) 

# Data Cleaning

#Lets convert value into a number and clean the names of the players
Conmebol_num <- Conmebol_raw %>%
  mutate(value2 = str_sub(value,-1,-1),
         value = parse_number(value),
         value = case_when(value2 == "M" ~ value * 1000000,
                           value2 == "K" ~ value * 1000,
                           TRUE ~ 0),
         position = case_when(best_position %in% c("ST","RW","LW","CF") ~ "ATT",
                              best_position %in% c("RB","RWB","LWB","CB","LB") ~ "DEF",
                              best_position == "GK" ~ "GK",
                              TRUE ~ "MID"))

# Final data to use for the model
Conmebol <- Conmebol_num %>% 
  na_if(.,0) %>% 
  separate(height, c("Foot", "Inches")) %>%
  mutate(height = as.double(str_c(Foot, '.', Inches))) %>% 
  select(-Foot, -Inches, -value2)


