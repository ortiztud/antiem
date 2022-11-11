# Aggregate data for ANTiEM study
# Author: Javier Ortiz-Tudela (Goethe Universitaet)
# Novemeber 2022

agg_data <- function(main_dir, which_subs){
  
  ## ----------------------  Set up  ----------------------------
  
  # Load libraries
  library(dplyr);
  
    ## ----------------------  Load data -----------------------------
  # Where is the data?
  data_dir <- paste(main_dir, "pilot_data", sep="/")
  
  # How many participants?
  n_sub <- length(which_subs)
  
  # Pre-allocate
  merged_data <- data.frame(matrix(ncol = 0, nrow = 0))

  # Loop through participants
  for(c_sub in which_subs){
    
    # Get subject code
    sub_code <- paste("sub-", sprintf("%02d", c_sub), sep="")
    
    # Load encoding data
    filename <- paste(sub_code, "_task-antiem_beh.csv", sep = "")
    
    # Read data from file
    sub_data <- read.csv(paste(data_dir, filename, sep="/"))
    
    # Store data
    merged_data <- rbind(merged_data, sub_data)
    
  }
  
  ## ----------------------  Save aggregated data -------------------------
  # Output names
  out_name <- 'group_task-antiem_beh.csv'

  # Write
  write.csv(merged_data, paste(data_dir, out_name, sep="/"), row.names = FALSE)
  
}
