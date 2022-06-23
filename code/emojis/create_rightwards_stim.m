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
project_dir = '/Volumes/GoogleDrive-108158338286165837329/Mi unidad/Memory_Attention_Javi_Fer/ANTI PsychoPy v.1.85.2/';

% List files
temp = dir(sprintf('%s/directional_stimuli/*png', project_dir));
for c_stim = 1:length(temp)
    filename{c_stim} = temp(c_stim).name;
end

%% Flip them
% ----------------------------------------------------------

% Loop through stimuli
for c_stim = 1:length(filename)

    % Read stim
   [origin, cmap, alpha]  = imread(sprintf('%s/directional_stimuli/%s', project_dir, filename{c_stim}));
   
   % In case this is an indexed image, we need to do a bit of extra work
   if ~isempty(cmap)
       origin = ind2rgb(origin, cmap);
       cmap = [];
   end

    % Flip horizontally both the stimuli and the transparency layer
    right_stim = origin(:,end:-1:1,:);
    alpha = alpha(:,end:-1:1);

    
    % Save new stim
    imwrite(right_stim, sprintf('%s/directional_stimuli/%s_right.png', ...
        project_dir, filename{c_stim}(1:end-4)), 'Alpha', alpha)

    % Echo to terminal
    sprintf('Image %d out of %d flipped', c_stim, length(filename))

end
