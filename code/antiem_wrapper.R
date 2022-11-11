## Wrapper for ANTiEM analysis
# We will blahblahblah
# Author: Javier Ortiz-Tudela (Goethe Universitaet)
# November 2022

## ---------------------- Set up  ----------------------------
# Where is the data and where do you want to generate the output?
root_dir <- '/Users/javierortiz/Library/CloudStorage/GoogleDrive-fjavierot@gmail.com/Mi unidad/colab_projects/Memory_Attention_Javi_Fer/'

# Where are the scripts?
scripts_dir <- "/Users/javierortiz/github_repos/antiem/code/"

# Participants
which_subs=c(1,3,4,5,28)

# Where is the data?
main_dir <- paste(root_dir, sep = "/")

## ---------------------- Curate data ----------------------------
# Load function
source(paste(scripts_dir, 'curation/data_curation.R', sep=""))

# Loop through participants
for(c_sub in which_subs){
  # Curate raw files
  data_curation(main_dir, c_sub, age_group)
}

## ---------------------- Aggregate data (within groups) ------------
source(paste(scripts_dir, 'curation/agg_data.R', sep=""))
agg_data(main_dir, which_subs)
