function defaults = task_defaults
% DEFAULTS  Defines defaults for Why/How Localizer Task
%
% You can modify the values below to suit your particular needs. Note that
% some combinations of modifications may not work, so if you do modify 
% anything, make sure to do a test run before running a subject. The default
% values were used in study used to validate the task. See:
%
%    Spunt, R. P., & Adolphs, R. (2014). Validating the why/how contrast 
%    for functional mri studies of theory of mind. Neuroimage, 99, 301-311.
%
%__________________________________________________________________________
% Copyright (C) 2014  Bob Spunt, Ph.D.

% Screen Resolution
%==========================================================================
defaults.screenres      = [1024 768];   % recommended screen resolution (if 
                                        % not supported by monitor, will
                                        % default to current resolution)

% Response Keys
%==========================================================================
defaults.trigger        = '5%'; % trigger key (to start ask)
defaults.valid_keys     = {'1!' '2@' '3#' '4$'}; % valid response keys
defaults.escape         = 'ESCAPE'; % escape key (to exit early)
                                
% Paths
%==========================================================================
defaults.path.base      = pwd;
defaults.path.data      = fullfile(defaults.path.base, 'data');
defaults.path.utilities = fullfile(defaults.path.base, 'ptb-utilities');
defaults.path.stim      = fullfile(defaults.path.base, 'stimuli');
defaults.path.design    = fullfile(defaults.path.base, 'design');

% Text 
%==========================================================================
defaults.font.name      = 'Arial'; % default font
defaults.font.size1     = 38; % default font size (smaller)
defaults.font.size2     = 42; % default font size (bigger)
defaults.font.wrap      = 42; % default font wrapping (arg to DrawFormattedText)

% Timing (specify all in seconds)
%==========================================================================
defaults.storyDur       = 15;       % max duration of story presentation
defaults.questionDur    = 6;        % max duration of question presentation
defaults.TR             = 1;        % Your TR (in secs) - Task runtime will be adjusted
                                    % to a multiple of the TR                                                
defaults.ignoreDur      = 1;        % number of seconds at beginning of story and question presentation 
                                    % in which to ignore button presses

end


