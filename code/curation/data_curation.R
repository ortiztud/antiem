# Data curation for ANTiEm study
# Author: Javier Ortiz-Tudela (Goethe Universitaet)
# October 2021 

data_curation <- function(main_dir, c_sub, age_group){

  ## ----------------------  Set up  ----------------------------
  # Load libraries
  library(dplyr);#library(readxl)
  sub_code <- paste("sub-", sprintf("%02d", c_sub), sep="")
  
  ## ----------------------  Load data ----------------------------
  # Where is the data?
  raw_dir <- paste(main_dir, "Pilot_RevisedFinal/Data_raw_pilot", sep="/")
  out_dir <- paste(main_dir, "pilot_data",  sep="/")
  
  # List data files
  file_pattern <- paste(c_sub, "_ANTIEM.*csv", sep = "")
  filename  <- list.files(path= raw_dir, pattern= file_pattern, full.names=T)
  
  # Read data from file
  raw <- read.csv(filename)
  
  ## ----------------------  Separate phases ----------------------------
  # Let's filter rows and cols.
  enc_data <- raw %>% 
    filter(!is.na(TrialsSelection.thisTrialN)) %>% 
    mutate(trial_n = TrialsSelection.thisTrialN +1) %>% 
    select(c(X1.Participant, TargetImage, Tone, ValidityCue, Congruency, 
             StimuliResp.RT.in.ms, StimuliResp.corr))
  
  # Let's filter rows and cols.
  ret_data <- raw %>% 
    filter(fixation_mem.started != " ") %>% 
    mutate(trial_n = retrieval_trials.thisTrialN +1) %>% 
    select(c(X1.Participant, TargetImage, Tone, ValidityCue, Congruency, 
             old_or_new, key_resp_id.keys, key_resp_id.corr, key_resp_id.rt, 
             key_resp_conf.keys))

  # Rename some variables for easier handling
  colnames(enc_data)[colnames(enc_data)=="X1.Participant"] <- "participant"
  colnames(enc_data)[colnames(enc_data)=="StimuliResp.RT.in.ms"] <- "anti_rt"
  colnames(enc_data)[colnames(enc_data)=="StimuliResp.corr"] <- "anti_acc"
  colnames(ret_data)[colnames(ret_data)=="X1.Participant"] <- "participant"
  colnames(ret_data)[colnames(ret_data)=="key_resp_id.corr"] <- "recog_acc"
  colnames(ret_data)[colnames(ret_data)=="key_resp_id.rt"] <- "recog_rt"
  colnames(ret_data)[colnames(ret_data)=="key_resp_id.keys"] <- "recog_resp"
  colnames(ret_data)[colnames(ret_data)=="key_resp_conf.keys"] <- "conf_resp"
  
  ## ----------------------  Merge phases ----------------------------
  merged_data <- merge(enc_data, ret_data, by = "TargetImage", all.y = T, suffixes = c("_enc", "_ret"))
  
  # Check that the merging worked out fine
  check_df <- merged_data %>% 
    filter(old_or_new == 1) %>% 
    summarise(check_tone = mean(Tone_enc == Tone_ret) ,
              check_val = mean(ValidityCue_enc == ValidityCue_ret),
              check_cong = mean(Congruency_enc == Congruency_ret))
  
  # If everything is clear, clean up a little to remove duplicates
  if (check_df$check_tone==1 & check_df$check_val == 1 & check_df$check_cong == 1){
    
    merged_data <- merged_data %>% 
      select(-c(ends_with("ret")))
  }

  # Rename some columns
  colnames(merged_data)[colnames(merged_data)=="Tone_enc"] <- "tone"
  colnames(merged_data)[colnames(merged_data)=="ValidityCue_enc"] <- "validity"
  colnames(merged_data)[colnames(merged_data)=="Congruency_enc"] <- "congruency"
  colnames(merged_data)[colnames(merged_data)=="participant_enc"] <- "participant"

  # Add participant number for new trials
  merged_data$participant <- c_sub
  
  # Output name
  out_name <- paste(sub_code, '_task-antiem_beh.csv', sep="")
  
  # Write
  write.csv(merged_data, paste(out_dir, out_name, sep="/"), row.names = FALSE)
  
}
