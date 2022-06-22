%% Project ANTiEM: Attention Network Test with interactions and Episodic Memory
% ----------------------------------------------------------
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fernando Luna & Javier Ortiz-Tudela
% Contact: 
% ortiztudela@psych.uni-frankfurt.com
% LISCO Lab - Goethe Universitat
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Additional info %%%
% This XXXXX
%%%%%%%%%%%%%%%%%%%%%%%

%% Clean everything
clear; close all

%% Define some initial variables (paths and file names mostly)
% ----------------------------------------------------------

% Where are the stimuli
stim_folder = 'directional_stimuli/';

% Load conditions ANTi 
anti = readtable('ConditionsANTIEM.xlsx');

% Load stimuli info
stim = readtable("stim_info.xlsx");

% Initialize random seed (for replicability purposes)
rng(9999)

% Create random order for the stimuli list
rand_ord = randperm(144);

% Get file names and sort them randomly
names = stim.original_name(rand_ord);

%% Create counterbalancing lists
% ----------------------------------------------------------
% Now I will chop the stim list into three lists with a leave one chunk (48
% stimuli) out reserved for test
c = 0;
for cb_list = 1:3

    % Get a copy
    temp = names';

    % Chunk indices
    ind = (1+(48*c):48+(48*c));
    c = c+1;

    % Chop list
    test_stim = temp(ind);
    temp(ind) = [];
    enc_stim = temp;

    % Loop through encoding trials
    for c_trials = 1:length(enc_stim)

        % Check target direction
        if strcmpi(anti.TargetDirection{c_trials}, 'left')

            % Select encoding stimuli (by default, all looking left)
            anti.TargetImage{c_trials} = [stim_folder, enc_stim{c_trials}];
        else

            % Select encoding stimuli (right)
            anti.TargetImage{c_trials} = [stim_folder, enc_stim{c_trials}(1:end-4), '_right.png'];
        end

        % Check distractor direction
        if strcmpi(anti.DistractDirection{c_trials}, 'left')

            % Select encoding stimuli (by default, all looking left)
            anti.DistractImage{c_trials} = [stim_folder, enc_stim{c_trials}];
        else

            % Select encoding stimuli (right)
            anti.DistractImage{c_trials} = [stim_folder, enc_stim{c_trials}(1:end-4), '_right.png'];
        end
    end

    % Print condition files
    writetable(anti, sprintf('cond_files/encoding_list_%d', cb_list))
    writetable(table(test_stim'), sprintf('cond_files/retrieval_list_%d', cb_list))

end