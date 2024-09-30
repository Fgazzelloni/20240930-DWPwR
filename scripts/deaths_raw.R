# Load extra data for `deaths` due to `Cardiovascular Diseases` from the [IHME website](https://www.healthdata.org/), read the files in the data/data folder:
  
# - first list the files
# - read the files
# - build one dataset with all the files

library(tidyverse)

list.files("data/ihme_data")
 
files <- list.files("data/ihme_data", 
                    full.names = TRUE)
files
 
data_list <- lapply(files, read.csv, sep = ",")
 
cardio_deaths_raw <- do.call(rbind, data_list)
# cardio_deaths %>%View()
 
cardio_deaths_raw %>% dim()

# cardio_deaths %>% count(Location) %>% View()

cardio_deaths <- cardio_deaths_raw %>%
  janitor::clean_names() %>%
  filter(location %in% c("High SDI", "High-middle SDI",
                         "Low SDI", "Low-middle SDI", 
                         "Middle SDI")) %>% 
  mutate(sex = ifelse(sex == "Female", 1, 2),
         gender = factor(sex, 
                         levels = c(1,2),
                         labels = c("female", "male")),
         age = gsub(" years","", age)) %>% 
  select(location, year, age, gender, value) 

# cardio_deaths %>%  View()

# save cardio_deaths as csv

write_csv(cardio_deaths, "data/cardio_deaths.csv")
