%
project_dir = '/Volumes/GoogleDrive-108158338286165837329/Mi unidad/Memory_Attention_Javi_Fer/';

% List files
temp = dir(sprintf('%s/directional_stimuli/*png', project_dir));
for c_stim = 1:length(temp)
    filename{c_stim} = temp(c_stim).name;
end
out = table(filename);

% Write it to csv
csvwrite(sprintf('%s/directional_stimuli/stim_names.csv',project_dir), out)
