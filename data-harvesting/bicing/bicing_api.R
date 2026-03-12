library(scrapex)
library(httr2)
library(dplyr)
library(readr)

bicing <- api_bicing()

real_time_bicing <- function(bicing_api) {
  rt_bicing <- paste0(bicing_api$api_web, "/api/v1/real_time_bicycles")
  
  resp_output <- 
    rt_bicing %>%
    request() %>% 
    req_perform()
  
  all_stations <-
    resp_output %>%
    resp_body_json()
  
  all_stations_df <- 
    all_stations %>%
    lapply(data.frame) %>%
    bind_rows()
  
  all_stations_df
}

save_bicing_data <- function(bicing_api) {
  # Perform a request to the bicing API and get the data frame back
  bicing_results <- real_time_bicing(bicing_api)
  
  # Specify the local path where the file will be saved
  local_csv <- "/Users/ameliabshuler/Desktop/data_programming_notes/data-harvesting/bicing/bicing_history.csv"
  
  # Extract the directory where the local file is saved
  main_dir <- dirname(local_csv)
  
  # If the directory does *not* exist, create it, recursively creating each folder  
  if (!dir.exists(main_dir)) {
    dir.create(main_dir, recursive = TRUE)
  }
  
  # If the file does not exist, save the current bicing response  
  if (!file.exists(local_csv)) {
    write_csv(bicing_results, local_csv)
  } else {
    # If the file does exist, the *append* the result to the already existing CSV file
    write_csv(bicing_results, local_csv, append = TRUE)
  }
}

save_bicing_data(bicing)