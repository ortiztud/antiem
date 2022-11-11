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
root_folder = '/Users/javierortiz/Library/CloudStorage/GoogleDrive-fjavierot@gmail.com/Mi unidad/colab_projects/Memory_Attention_Javi_Fer/ANTIEM PsychoPy v.1.85.2';

% Where are the stimuli
stim_folder = ['materials/stim'];

% Where do you want the condition files to be written?
out_folder = [root_folder, 'materials'];
out_folder = 'out';
% Load conditions ANTi
anti = readtable('ConditionsANTIEM.xlsx');

% Load stimuli info
stim = readtable([root_folder, '/materials/stim_info.xlsx']);

% Initialize random seed (for replicability purposes)
rng(9999)

% Create random order for the stimuli list
rand_ord = randperm(144);

% Get file names and sort them randomly
names = stim.original_name(rand_ord);

%% Define on-screen positions
% ----------------------------------------------------------
stim_width = .10; % 10% of the screen height. This is code in the task file
up_pos = .20;
down_pos = up_pos * -1;
sep_value = stim_width * 1.2 + stim_width;

% Loop through trials
for c_trial = 1:height(anti)

    % Update Y axis
    if strcmpi(anti.TargetPosition(c_trial), 'up')
        anti = update_positions(anti, c_trial, 'y', up_pos);
    elseif strcmpi(anti.TargetPosition(c_trial), 'down')
        anti = update_positions(anti, c_trial, 'y', down_pos);
    end

    % Update X axis
    anti = update_positions(anti, c_trial, 'x', sep_value);

    % Update cue
    if strcmpi(anti.ValidityCue(c_trial), 'valid')
        anti.CueCoordY{c_trial} = anti.TargetCoordY{c_trial};
    elseif strcmpi(anti.ValidityCue(c_trial), 'invalid')
        anti.CueCoordY{c_trial} = anti.TargetCoordY{c_trial} * -1;
    elseif strcmpi(anti.ValidityCue(c_trial), 'nocue')
        anti.CueCoordY{c_trial} = -2;
    end
end

% Save
% writetable(anti, 'ConditionsANTIEM.xlsx');

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
            anti.TargetImage{c_trials} = [stim_folder, '/', enc_stim{c_trials}];
        else

            % Select encoding stimuli (right)
            anti.TargetImage{c_trials} = [stim_folder, '/', enc_stim{c_trials}(1:end-4), '_right.png'];
        end

        % Check distractor direction
        if strcmpi(anti.DistractDirection{c_trials}, 'left')

            % Select encoding stimuli (by default, all looking left)
            anti.DistractImage{c_trials} = [stim_folder, '/', enc_stim{c_trials}];
        else

            % Select encoding stimuli (right)
            anti.DistractImage{c_trials} = [stim_folder, '/', enc_stim{c_trials}(1:end-4), '_right.png'];
        end
    end

    %% Save outputs
    % ----------------------------------------------------------
    % Print condition files
    writetable(anti, sprintf('%s/encoding_list_%d.csv', out_folder, cb_list))

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
            retrieval.TargetImage{c_trials}  = [stim_folder, '/', test_stim{c_trials}(1:end-4), '_right.png'];
        else
            retrieval.TargetImage{c_trials}  = [stim_folder, '/', test_stim{c_trials}(1:end-4), '_left.png'];
        end
    end

    % Code correct response
    anti.CorrectAnswer = repmat({'up'},n_old,1);
    retrieval.CorrectAnswer = repmat({'down'},n_new,1);

    % Add trial type for the retrieval phase to both tables
    anti.old_or_new = ones(height(anti),1);
    retrieval.old_or_new = repmat(2,n_new,1);

    % Merge tables
    retrieval = [anti;retrieval];

    %% Save outputs
    % ----------------------------------------------------------
    % Print condition files
    writetable(retrieval, sprintf('%s/retrieval_list_%d.csv', out_folder, cb_list))

end


function temp = update_positions(anti, c_trial, axis, value)

% Get copy
temp = anti;

% Update coordinates based on the requested axis
switch axis
    case 'x'

        temp.TargetCoordX(c_trial)= 0;
        temp.DistL1CoordX(c_trial) = value * -1;
        temp.DistL2CoordX(c_trial) = value * -2;
        temp.DistR1CoordX(c_trial) = value * 1;
        temp.DistR2CoordX(c_trial) = value * 2;

    case 'y'
        temp.TargetCoordY{c_trial} = value;
        temp.DistL1CoordY{c_trial} = value;
        temp.DistL2CoordY{c_trial} = value;
        temp.DistR1CoordY{c_trial} = value;
        temp.DistR2CoordY{c_trial} = value;
end

end