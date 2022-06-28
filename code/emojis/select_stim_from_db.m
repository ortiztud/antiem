%% Project ANTiEM: Attention Network Test with interactions and Episodic Memory
% ----------------------------------------------------------
%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fernando Luna & Javier Ortiz-Tudela
% Contact:
% ortiztudela@psych.uni-frankfurt.com
% LISCO Lab - Goethe Universitat
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Script info %%%
% This script blah blah
%%%%%%%%%%%%%%%%%%%%%%%

%% Clean everything
clear; close all

%% Read in original stim
% ----------------------------------------------------------

% Where are the original stimuli
original_dir = '/Volumes/GoogleDrive-108158338286165837329/Mi unidad/Memory_Attention_Javi_Fer/directional_database';

% Task directory
task_dir = '/Volumes/GoogleDrive-108158338286165837329/Mi unidad/Memory_Attention_Javi_Fer/ANTI PsychoPy v.1.85.2/materials/stim';

% Read in stim info. We will flip only those that we want for the task
stim_info = readtable(sprintf('%s/stim_info.xlsx', original_dir), "ReadVariableNames",true);

% temp = dir(sprintf('%s/*png', original_dir));
% for c_stim = 1:length(temp)
%     filename{c_stim} = temp(c_stim).name;
% end

%% Flip them
% ----------------------------------------------------------

% Loop through stimuli
for c_stim = 1:height(stim_info)

    % Get current stimulus name
    filename = stim_info.original_name{c_stim};

    % Read stim
   [origin, cmap, alpha]  = imread(sprintf('%s/selected/%s', original_dir, filename));
   
   % In case this is an indexed image, we need to do a bit of extra work
   if ~isempty(cmap)
       origin = ind2rgb(origin, cmap);
       cmap = [];
   end

    % Flip horizontally both the stimuli and the transparency layer
    right_stim = origin(:,end:-1:1,:);
    alpha = alpha(:,end:-1:1);

    % Grab a copy of the original (leftwards facing) stimulus
    copyfile([original_dir, '/selected/', filename], [task_dir, '/', filename]);

    % Save new stim
    imwrite(right_stim, sprintf('%s/%s_right.png', ...
        task_dir, filename(1:end-4)), 'Alpha', alpha)

    % Echo to terminal
    sprintf('Image %d out of %d flipped', c_stim, height(stim_info))

end
