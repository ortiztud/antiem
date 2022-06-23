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

% Where are the stimuli
stim_folder = 'directional_stimuli/';

% Where do you want the condition files to be written?
out_folder = '/Volumes/GoogleDrive-108158338286165837329/Mi unidad/Memory_Attention_Javi_Fer/ANTI PsychoPy v.1.85.2/materials/';

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

    %% Encoding task (ANT-i)
    % ----------------------------------------------------------
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

    %% Retrieval task (Recognition memory)
    % ----------------------------------------------------------
    % Get encoding info (old trials)
       n_new = length(test_stim);
       n_old = length(enc_stim);

    % Create a new table for new trials with the same variables as the
    % encoding table but with empty rows.
    retrieval = anti(1,:); retrieval(:,:)=[];
    retrieval.TargetImage(1: n_new) = test_stim;
    
    % Add new stim (half of them pointing right, the other half pointing
    % left)
    for c_trials = 1:n_new
        if c_trials <= n_new
            retrieval.TargetImage{c_trials}  = [stim_folder, test_stim{c_trials}(1:end-4), '_right.png'];
        else
            retrieval.TargetImage{c_trials}  = [stim_folder, test_stim{c_trials}(1:end-4), '_left.png'];
        end
    end

    % Code correct response
    anti.CorrectAnswer = repmat({'left'},n_old,1);
    retrieval.CorrectAnswer = repmat({'right'},n_new,1);

    % Add trial type for the retrieval phase to both tables
    anti.old_or_new = ones(height(anti),1);
    retrieval.old_or_new = repmat(2,n_new,1);

    % Merge tables
    retrieval = [anti;retrieval];

    %% Save outputs
    % ----------------------------------------------------------
    % Print condition files
    writetable(anti, sprintf('%s/encoding_list_%d.csv', out_folder, cb_list))
    writetable(retrieval, sprintf('%s/retrieval_list_%d.csv', out_folder, cb_list))

end