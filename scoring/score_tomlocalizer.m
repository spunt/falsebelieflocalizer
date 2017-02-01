function [b, totalNR] = score_tomlocalizer(fname, varargin)
% score = score_tomlocalizer(fname, varargin)
%
%   yesnokeys:               1x2 array for keys representing yes/no responses
%   omitNoResponses:         0 - No,  1 - Yes
%   germankey:               0 - No,  1 - Yes
%
def  = { ...
  'yesnokeys'           ,       [1 2]                       ,...
  'omitNoResponses'     ,       0                           ,...
  'germankey'           ,       0                           ,...
};
vals = setargs(def, varargin);
if nargin==0, mfile_showhelp; fprintf('\t= DEFAULT SETTINGS =\n'); disp(vals); return; end
if nargin < 1, disp('USAGE: score = score_tomlocalizer(fname, varargin)'); return; end
if iscell(fname), fname = char(fname); end

% | CONFIGURATION STRING
% | ========================================================================================
b.defstr = sprintf('BELIEF-PHOTO_NR%d', omitNoResponses);

% | ANSWER KEY
% ==========================================================================================
anskey      = get_anskey;
ref         = anskey(:,1);
key         = cell2mat(anskey(:,2));
answerkey   = key;
answerkey(key==1) = yesnokeys(1);
answerkey(key==2) = yesnokeys(2);

% | READ DATA
% ==========================================================================================
d             = load(fname);
if any(strcmpi(fieldnames(d), 'belief'))
    d.b = d.belief;
    d.p = d.photo;
end
data          = d.Seeker;
b.subjectID     = d.subjectID;
item          = strtrim([{d.b.question}; {d.p.question}]');
itemkey       = zeros(size(item));
for i = 1:numel(itemkey)
    idx = find(strcmpi(ref, item{i}));
    itemkey(i) = answerkey(idx);
end
data(data==0) = NaN;
totalNR       = sum(isnan(data(:,8)));
data(:,11)    = 0;
for i = 1:2
   cdata = data(data(:,2)==i, :);
   cdata = sortrows(cdata, 5);
   cdata(:,11) = itemkey(cdata(:,5), i);
   data(data(:,2)==i,:) = sortrows(cdata, 1);
end
data(:,12)  = data(:,8)==data(:,11);
if omitNoResponses, data(isnan(data(:,8)),[10 12]) = NaN; end
acc = [NaN NaN];
rt  = acc;
for c = 1:2
    tmpacc              = data(data(:,2)==c, [11 8]);
    tmpacc(tmpacc==2)   = 0;
    [dprime(c), responsebias(c)] = calc_signaldetectiontheory(tmpacc);
    acc(c)  = 100*(nansum(data(data(:,2)==c,12))/nansum(~isnan(data(data(:,2)==c,12))));
    rt(c)   = nanmean(data(data(:,2)==c,10));
end

% COLLECT IT
b.oondlabels = {'Belief' 'Photo'};
varnames     = {'ACC' 'RT' 'DPRIME' 'BIAS'};
condnames    = b.oondlabels;
allnames     = [];
for i = 1:length(varnames)
    allnames = [allnames strcat(varnames{i}, '_', condnames)];
end
b.allname    = allnames;
b.alldata    = [acc rt dprime responsebias];
end
function anskey = get_anskey(varargin)
    anskey{1, 1}  = 'In fact, Amy walked to work.';
    anskey{1, 2}  = 1;
    anskey{2, 1}  = 'The Garcia family arrives home believing the score is 5-3.';
    anskey{2, 2}  = 2;
    anskey{3, 1}  = 'Sarah gets ready assuming her shoes are under the dress.';
    anskey{3, 2}  = 1;
    anskey{4, 1}  = 'Lisa now believes that Jacob is sleeping.';
    anskey{4, 2}  = 1;
    anskey{5, 1}  = 'By the time Mary comes in, John doesn''t know where his keys are.';
    anskey{5, 2}  = 2;
    anskey{6, 1}  = 'Susie sees the minivan in the driveway.';
    anskey{6, 2}  = 1;
    anskey{7, 1}  = 'The CEO comes to work and discovers that all of the walls are cleaned.';
    anskey{7, 2}  = 2;
    anskey{8, 1}  = 'When the hikers arrive they see no one in their cabin.';
    anskey{8, 2}  = 2;
    anskey{9, 1}  = 'When Larry writes his paper he thinks the debate has been solved.';
    anskey{9, 2}  = 2;
    anskey{10, 1} = 'Laura returns assuming that her horse''s hair isn''t braided';
    anskey{10, 2} = 1;
    anskey{11, 1} = 'Near Titan today there are many islands.';
    anskey{11, 2} = 2;
    anskey{12, 1} = 'Early 1900s novels portray the country as experiencing economic wealth.';
    anskey{12, 2} = 1;
    anskey{13, 1} = 'In the painting the south bank of the river is wooded.';
    anskey{13, 2} = 1;
    anskey{14, 1} = 'Today the length of the man''s hair is long.';
    anskey{14, 2} = 1;
    anskey{15, 1} = 'The biography says that the room was light.';
    anskey{15, 2} = 2;
    anskey{16, 1} = 'Today the color of the blouse is white.';
    anskey{16, 2} = 2;
    anskey{17, 1} = 'On the explorer''s maps, the island appears to be mostly submerged.';
    anskey{17, 2} = 2;
    anskey{18, 1} = 'The house is currently one story.';
    anskey{18, 2} = 2;
    anskey{19, 1} = 'Today, the island is covered in lava rock.';
    anskey{19, 2} = 1;
    anskey{20, 1} = 'An antique drawing of City Hall shows a fountain in front.';
    anskey{20, 2} = 2;

    % if germankey, answerkey(:,3) = [[item.b.answer] [item.p.answer]]'; end % not sure if this is correct
    % answerkey = [1 1 1;1 2 2;1 3 1;1 4 1;1 5 2;1 6 1;1 7 2;1 8 2;1 9 2;1 10 1;2 1 2;2 2 1;2 3 1;2 4 1;2 5 2;2 6 2;2 7 2;2 8 2;2 9 1;2 10 2];
    % for i = 1:size(data,1), data(i,11) = answerkey(answerkey(:,1)==data(i,2) & answerkey(:,2)==data(i,5),3); end
end
function [dprime, responsebias] = calc_signaldetectiontheory(tmpacc)
    true_rescale        = 100/sum(tmpacc(:,1)==1);
    false_rescale       = 100/sum(tmpacc(:,1)==0);
    count.hits          = true_rescale*(sum(tmpacc(:,1)==1 & tmpacc(:,2)==1)) + 1;
    count.misses        = true_rescale*sum(tmpacc(:,1)==1 & tmpacc(:,2)==0) + 1;
    count.falsealarms   = false_rescale*sum(tmpacc(:,1)==0 & tmpacc(:,2)==1) + 1;
    count.correctreject = false_rescale*sum(tmpacc(:,1)==0 & tmpacc(:,2)==0) + 1;
    hit_rate            = count.hits / (count.hits + count.misses);
    zhr                 = norminv(hit_rate);
    false_alarm_rate    = count.falsealarms / (count.falsealarms + count.correctreject);
    zfar                = norminv(false_alarm_rate);
    % | D-Prime
    dprime              = zhr - zfar;
    % | Response Bias (Criterion, c)
    responsebias           = -(zhr + zfar)/2;
end
