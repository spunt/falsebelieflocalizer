function run_task(test_tag)
% RUN_TASK  Run False-Belief Localizer
%  
%   USAGE: run_task([test_tag])
%
%     SEEKER COLUMN KEY
%     1 - trial #
%     2 - condition (1=Belief, 2=Photo)
%     3 - intended trial onset
%     4 - intended question onset
%     5 - stimulus index
%     6 - actual story onset
%     7 - actual question onset
%     8 - actual response
%     9 - RT to question onset
%     10 - actual block duration
%
%   Adapted from:  http://saxelab.mit.edu/superloc.php
%
%   This code uses Psychophysics Toolbox Version 3 (PTB-3) running in
%   MATLAB (The Mathworks, Inc.). To learn more: http://psychtoolbox.org
%_______________________________________________________________________
% Copyright (C) 2014  Bob Spunt, Ph.D.
if nargin<1, test_tag = 0; end

%% Check for Psychtoolbox %%
try
    ptbVersion = PsychtoolboxVersion;
catch
    url = 'https://psychtoolbox.org/PsychtoolboxDownload';
    fprintf('Psychophysics Toolbox may not be installed or in your search path.\nSee: %s\n', url);
end

%% Print Title %%
script_name='| ----------- True/False Test ----------- |'; boxTop(1:length(script_name))='=';
fprintf('\n%s\n%s\n%s\n',boxTop,script_name,boxTop)

%% DEFAULTS %%
defaults = task_defaults; 
trigger = KbName(defaults.trigger);
storyDur = defaults.storyDur; 
questionDur = defaults.questionDur; 
addpath(defaults.path.utilities)

%% Load Design and Setup Seeker Variable %%
load([defaults.path.design filesep 'design.mat'])
numTRs          = ceil(sum(Seeker(end,3:5))/defaults.TR); 
totalTime       = defaults.TR*numTRs; 
Seeker(:,4:5)   = [];
Seeker(:,4:10)  = zeros(length(Seeker),7);
Seeker(:,4)     = Seeker(:,3) + 15;
Seeker(Seeker(:,2)==1,5) = randperm(10);
Seeker(Seeker(:,2)==2,5) = randperm(10);

%% Print Defaults %%
fprintf('Test Duration:         %d secs (%d TRs)', totalTime, numTRs);
fprintf('\nTrigger Key:           %s', defaults.trigger);
fprintf(['\nValid Response Keys:   %s' repmat(', %s', 1, length(defaults.valid_keys)-1)], defaults.valid_keys{:});
fprintf('\nForce Quit Key:        %s\n', defaults.escape);
fprintf('%s\n', repmat('-', 1, length(script_name)));

%% Get Subject ID %%
if ~test_tag
    subjectID = ptb_get_input_string('\nEnter Subject ID: ');
else
    subjectID = 'TEST';
end

%% Setup Input Device(s) %%
switch upper(computer)
  case 'MACI64'
    inputDevice = ptb_get_resp_device;
  case {'PCWIN','PCWIN64'}
    % JMT:
    % Do nothing for now - return empty chosen_device
    % Windows XP merges keyboard input and will process external keyboards
    % such as the Silver Box correctly
    inputDevice = [];
  otherwise
    % Do nothing - return empty chosen_device
    inputDevice = [];
end
resp_set = ptb_response_set([defaults.valid_keys defaults.escape]); % response set
 
%% Initialize Screen %%
try
    w = ptb_setup_screen(0,250,defaults.font.name,defaults.font.size1, defaults.screenres); % setup screen
catch
    disp('Could not change to recommend screen resolution. Using current.');
    w = ptb_setup_screen(0,250,defaults.font.name,defaults.font.size1);
end

%% Initialize Logfile (Trialwise Data Recording) %%
d=clock;
logfile=fullfile(defaults.path.data, sprintf('LOG_falsebelief_sub%s.txt', subjectID));
fprintf('\nA running log of this session will be saved to %s\n',logfile);
fidlog=fopen(logfile,'a');
if fidlog<1,error('could not open logfile!');end;
fprintf(fidlog,'Started: %s %2.0f:%02.0f\n',date,d(4),d(5));

%% STIMULI %%
DrawFormattedText(w.win,'LOADING','center','center', w.white, defaults.font.wrap); Screen('Flip',w.win);
instructTex = Screen('MakeTexture', w.win, imread([defaults.path.stim filesep 'instruction.jpg']));
storypromptTex = Screen('MakeTexture', w.win, imread([defaults.path.stim filesep 'storyprompt.jpg']));
fixTex = Screen('MakeTexture', w.win, imread([defaults.path.stim filesep 'fixation.jpg']));
% belief
d   = dir(fullfile(defaults.path.stim, '*belief_question.txt')); 
bq  = strcat(defaults.path.stim, filesep, {d.name});
d   = dir(fullfile(defaults.path.stim, '*belief_story.txt')); 
bs  = strcat(defaults.path.stim, filesep, {d.name});
for i = 1:10
    
    belief(i).storyfile = bs{i};
    belief(i).questionfile = bq{i};
    
    % story
    fidlog = fopen(bs{i});
    text = [];
    while 1
        tmp = fgetl(fidlog);
        if ~ischar(tmp), break, end
        text = [text ' ' deblank(tmp)];
    end
    belief(i).story = deblank(text);
    
    % question
    fidlog = fopen(bq{i});
    text = [];
    while 1
        tmp = fgetl(fidlog);
        if ~ischar(tmp), break, end
        text = [text ' ' deblank(tmp)];
    end
    text = regexprep(text,'True','');
    text = regexprep(text,'False','');
    belief(i).question = deblank(text);
    
end
   
% false-photo
d = dir(fullfile(defaults.path.stim, '*photo_question.txt'));
pq = strcat(defaults.path.stim, filesep, {d.name});
d = dir(fullfile(defaults.path.stim, '*photo_story.txt'));
ps = strcat(defaults.path.stim, filesep, {d.name});
for i = 1:10
    
    photo(i).storyfile = ps{i};
    photo(i).questionfile = pq{i};
    
    % story
    fidlog = fopen(ps{i});
    text = [];
    while 1
        tmp = fgetl(fidlog);
        if ~ischar(tmp), break, end
        text = [text ' ' deblank(tmp)];
    end
    photo(i).story = deblank(text);
    
    % question
    fidlog = fopen(pq{i});
    text = [];
    while 1
        tmp = fgetl(fidlog);
        if ~ischar(tmp), break, end
        text = [text ' ' deblank(tmp)];
    end
    text = regexprep(text,'True','');
    text = regexprep(text,'False','');
    photo(i).question = deblank(text);
    
end

%==========================================================================
%
% START TASK PRESENTATION
% 
%==========================================================================

%% Present Instruction Screen %%
Screen('DrawTexture',w.win, instructTex); Screen('Flip',w.win);

%% Wait for Trigger to Begin %%
DisableKeysForKbCheck([]);
secs=KbTriggerWait(trigger,inputDevice);	
anchor=secs;	
Screen('DrawTexture',w.win, fixTex); Screen('Flip',w.win);

try

    if test_tag, nTrials = 1; totalTime = round(totalTime*.065); % for test run
    else nTrials = length(Seeker); end
    %======================================================================
    % BEGIN TRIAL LOOP
    %======================================================================
    for t = 1:nTrials 

        DrawFormattedText(w.win,'- GET READY -','center','center',w.white, defaults.font.wrap);
        WaitSecs('UntilTime',anchor + Seeker(t,3) - 2);
        Screen('Flip',w.win);
        Screen('FillRect', w.win, w.black);
        WaitSecs('UntilTime',anchor + Seeker(t,3) - .5);
        Screen('Flip', w.win);
        
        % Prep and flip story
        idx = Seeker(t,5);
        if Seeker(t,2)==1
            story = belief(idx).story;
            question = belief(idx).question;
        else
            story = photo(idx).story;
            question = photo(idx).question;
        end
        Screen('DrawTexture',w.win,storypromptTex);
        DrawFormattedText(w.win,story, 'center','center',w.white,defaults.font.wrap);
        WaitSecs('UntilTime', anchor + Seeker(t,3)); 
        Screen('Flip', w.win);
        storyOnset = GetSecs;
        Seeker(t,6) = storyOnset - anchor;

        %% Look for Button Press %%
        [resp, rt] = ptb_get_resp_windowed_noflip(inputDevice, resp_set, storyDur, defaults.ignoreDur);
        if ~isempty(resp)
            if strcmpi(resp, defaults.escape)
                sca; rmpath(defaults.path.utilities)
                fprintf('\nESCAPE KEY DETECTED\n'); return
            end
        end

        % Prep question 
        DrawFormattedText(w.win,[question '\n\nTrue(1)        False(2)'], 'center','center',w.white,defaults.font.wrap); 
        WaitSecs(.15);
        Screen('Flip',w.win);
        Seeker(t,7) = GetSecs - anchor;
        
        %% Look for Button Press %%
        [resp, rt] = ptb_get_resp_windowed_noflip(inputDevice, resp_set, storyDur, defaults.ignoreDur);
        Seeker(t,10) = GetSecs - storyOnset;
        if ~isempty(resp)
            if strcmpi(resp, defaults.escape)
                sca; rmpath(defaults.path.utilities)
                fprintf('\nESCAPE KEY DETECTED\n'); return
            end
            Seeker(t,8) = str2num(resp(1));
            Seeker(t,9) = rt; 
        end
         
        % Present fixation cross during intertrial interval
        Screen('DrawTexture', w.win, fixTex);
        Screen('Flip', w.win);

        % PRINT TRIAL INFO TO LOG FILE
        try
            fprintf(fidlog,[repmat('%d\t',1,size(Seeker,2)) '\n'],Seeker(t,:));
        catch   % if sub responds weirdly, trying to print the resp crashes the log file...instead print "ERR"
            fprintf(fidlog,'ERROR SAVING THIS TRIAL\n');
        end;        

    end % END BLOCK LOOP
    
    %% Present Fixation Screen Until End of Scan %%
    WaitSecs('UntilTime', anchor + totalTime);

catch
    
    sca; rmpath(defaults.path.utilities)
    psychrethrow(psychlasterror);
    
end

%% Save Data to Matlab Variable %%
d=clock;
outfile=sprintf('tom_%s_%s_%02.0f-%02.0f.mat',subjectID,date,d(4),d(5));
try
    save(fullfile(defaults.path.data, outfile), 'subjectID', 'Seeker', 'belief', 'photo'); 
catch
	fprintf('couldn''t save %s\n saving to falsebeliefdata.mat\n',outfile);
	save falsebeliefdata
end;

%% End of Test Screen %%
DrawFormattedText(w.win,'TEST COMPLETE\n\nPress any key to exit.','center','center',w.white,defaults.font.wrap);
Screen('Flip', w.win); 
KbWait; 

%% Exit %%
sca; rmpath(defaults.path.utilities)

end
