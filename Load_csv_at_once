# install.packages(c("tidyverse", "fs"))
library(tidyverse)
library(fs)

data_dir <- "data_dir"

fs::dir_ls(data_dir)

csv_files <- fs::dir_ls(data_dir, regexp = "\\.csv$")

total_csv <- csv_files %>%
  map_dfr(read_csv)

total_csv < -data_dir %>% 
  fs::dir_ls(regexp = "\\.csv$") %>% 
  map_dfr(read_csv, .id = "source") 
  
  
## reference
## https://mrchypark.github.io/post/%EB%B2%88%EC%97%AD-%ED%8F%B4%EB%8D%94%EC%95%88%EC%9D%98-csv-%ED%8C%8C%EC%9D%BC%EB%93%A4%EC%9D%84-purrr-%EC%99%80-readr-%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%B4%EC%84%9C-%ED%95%9C%EB%B0%A9%EC%97%90-%EB%B6%88%EB%9F%AC%EC%98%A4%EA%B8%B0/
