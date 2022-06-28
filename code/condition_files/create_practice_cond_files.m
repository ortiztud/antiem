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

%% Define some initial variables (paths and file names mostly)
% ----------------------------------------------------------

% Where is the root folder for the task?
root_folder = '/Volumes/GoogleDrive-108158338286165837329/Mi unidad/Memory_Attention_Javi_Fer/ANTIEM PsychoPy v.1.85.2/';

% Where are the stimuli
stim_folder = ['materials/practice_stim'];

% Where do you want the condition files to be written?
out_folder = [root_folder, '/materials'];

% Load conditions ANTi and select only one block
anti = readtable('ConditionsANTIEM.xlsx');
anti = anti(anti.Block == 1,:);
% Load stimuli info
stim = readtable("practice_stim.xlsx");

% Initialize random seed (for replicability purposes)
rng(9999)

% Create random order for the stimuli list
rand_ord = randperm(height(stim));

% Get file names and sort them randomly
names = stim.original_name(rand_ord);

%% Create practice list
% ----------------------------------------------------------
% I won't counterbalance here as I see no benefit at the moment. Since we
% only have 8 different object for practice, we will repeat them 6 times
% each.
c = 0;
for cb_list = 1

    % Get a copy
    enc_stim = names';

    % Chunk indices
    ind = (1+(48*c):48+(48*c));
    c = c+1;


    %% Encoding task (ANT-i)
    % ----------------------------------------------------------
    % Loop through encoding trials
    for c_trials = 1:height(anti)

        % Check target direction
        if strcmpi(anti.TargetDirection{c_trials}, 'left')

            % Select encoding stimuli (by default, all looking left)
            anti.TargetImage{c_trials} = [stim_folder, '/', enc_stim{c}];
        else

            % Select encoding stimuli (right)
            anti.TargetImage{c_trials} = [stim_folder, '/', enc_stim{c}(1:end-4), '_right.png'];
        end

        % Check distractor direction
        if strcmpi(anti.DistractDirection{c_trials}, 'left')

            % Select encoding stimuli (by default, all looking left)
            anti.DistractImage{c_trials} = [stim_folder, '/', enc_stim{c}];
        else

            % Select encoding stimuli (right)
            anti.DistractImage{c_trials} = [stim_folder, '/', enc_stim{c}(1:end-4), '_right.png'];
        end

        % Update counter
        if c == 8
            c = 1;
        else
            c = c +1;
        end
    end

    %% Save outputs
    % ----------------------------------------------------------
    % Print condition files
    writetable(anti, sprintf('%s/practice_list.csv', out_folder))

end