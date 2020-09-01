# Sourcinf Libraries and data
source("Wrangling_and_Cleaning/Data Cleaning Script.R")



Conmebol_model<- Conmebol %>% 
  select(-id, -name, -position) 



# Data Split
set.seed(415)

# Split data into training and testing data sets. 
conmebol_split <- initial_split(Conmebol_model, prop = .8, strata = best_position)
conmebol_train <- training(conmebol_split) 
conmebol_test <- testing(conmebol_split)


# Creating bootstraps of training data to perform re-sampling and tuning methods
conmebol_boot <- bootstraps(conmebol_train, 
                            strata = best_position)



conmebol_rec <- recipe(value ~ ., data = conmebol_train) %>%
  step_mutate(overall_outliers_hi = case_when(overall > 90 ~ 1, 
                                              TRUE ~ 0)) %>%
  step_mutate(overall_outliers_lo = case_when(overall < 65 ~ 1, 
                                              TRUE ~ 0)) %>%
  step_corr(all_numeric(), -all_outcomes()) %>%
  step_other(best_position, threshold = 0.05) %>%
  step_dummy(all_nominal(), -all_outcomes()) %>%
  step_knnimpute(value, neighbors = 5) %>%
  step_normalize(all_predictors(), -all_outcomes())  %>%
  step_zv(all_predictors()) 


simple_lin_mod_spec <- linear_reg() %>%
  set_mode('regression') %>%
  set_engine('lm') 


linear_wf <- workflow() %>% 
  add_recipe(conmebol_rec) %>% 
  add_model(simple_lin_mod_spec)


simple_model <- fit(linear_wf, Conmebol_model)


saveRDS(simple_model, 'simple_model.rds')


#### Random Forest Model


set.seed(415)

rf_mod_spec <- rand_forest(
  trees = 500,
  mtry = 20,
  min_n = 2
) %>%
  set_mode('regression') %>%
  set_engine('ranger', importance = 'permutation')

rf_wf <- workflow() %>% 
  add_recipe(conmebol_rec) %>% 
  add_model(rf_mod_spec) 

final_rf_model <- last_fit(rf_wf, conmebol_split)

saveRDS(final_rf_model, 'final_rf_model.rds')


