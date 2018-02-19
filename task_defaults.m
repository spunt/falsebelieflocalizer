function defaults = task_defaults
% DEFAULTS  Defines defaults for False-Belief Localizer Taskå
%

% Language: 'english' or 'german'
% =========================================================================
defaults.language = 'german';

% Screen Resolution
%==========================================================================
defaults.screenres      = [1280 960];   % recommended screen resolution (if
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
if ~exist(defaults.path.data, 'dir'), mkdir(defaults.path.data); end
defaults.path.utilities = fullfile(defaults.path.base, 'ptb-utilities');
defaults.path.stim      = fullfile(defaults.path.base, 'stimuli');
defaults.path.design    = fullfile(defaults.path.base, 'design');

% Text
%==========================================================================
defaults.font.name      = 'Avenir'; % default font
defaults.font.size1     = 42; % default font size (smaller)
defaults.font.size2     = 46; % default font size (bigger)
defaults.font.wrap      = 46; % default font wrapping (arg to DrawFormattedText)

% Timing (specify all in seconds)
%==========================================================================
defaults.storyDur       = 16;       % max duration of story presentation
defaults.questionDur    = 6;        % max duration of question presentation
defaults.TR             = 1;        % Your TR (in secs) - Task runtime will be adjusted
                                    % to a multiple of the TR
defaults.ignoreDur      = 1;        % number of seconds at beginning of story and question presentation
                                    % in which to ignore button presses

end


