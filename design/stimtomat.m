clear all;
defaults = task_defaults;


itemkey{1, 1}  = 'In fact, Amy walked to work.';
itemkey{1, 2}  = 1;
itemkey{2, 1}  = 'The Garcia family arrives home believing the score is 5-3.';
itemkey{2, 2}  = 2;
itemkey{3, 1}  = 'Sarah gets ready assuming her shoes are under the dress.';
itemkey{3, 2}  = 1;
itemkey{4, 1}  = 'Lisa now believes that Jacob is sleeping.';
itemkey{4, 2}  = 1;
itemkey{5, 1}  = 'By the time Mary comes in, John doesn''t know where his keys are.';
itemkey{5, 2}  = 2;
itemkey{6, 1}  = 'Susie sees the minivan in the driveway.';
itemkey{6, 2}  = 1;
itemkey{7, 1}  = 'The CEO comes to work and discovers that all of the walls are cleaned.';
itemkey{7, 2}  = 2;
itemkey{8, 1}  = 'When the hikers arrive they see no one in their cabin.';
itemkey{8, 2}  = 2;
itemkey{9, 1}  = 'When Larry writes his paper he thinks the debate has been solved.';
itemkey{9, 2}  = 2;
itemkey{10, 1} = 'Laura returns assuming that her horse''s hair isn''t braided';
itemkey{10, 2} = 1;
itemkey{11, 1} = 'Near Titan today there are many islands.';
itemkey{11, 2} = 2;
itemkey{12, 1} = 'Early 1900s novels portray the country as experiencing economic wealth.';
itemkey{12, 2} = 1;
itemkey{13, 1} = 'In the painting the south bank of the river is wooded.';
itemkey{13, 2} = 1;
itemkey{14, 1} = 'Today the length of the man''s hair is long.';
itemkey{14, 2} = 1;
itemkey{15, 1} = 'The biography says that the room was light.';
itemkey{15, 2} = 2;
itemkey{16, 1} = 'Today the color of the blouse is white.';
itemkey{16, 2} = 2;
itemkey{17, 1} = 'On the explorer''s maps, the island appears to be mostly submerged.';
itemkey{17, 2} = 2;
itemkey{18, 1} = 'The house is currently one story.';
itemkey{18, 2} = 2;
itemkey{19, 1} = 'Today, the island is covered in lava rock.';
itemkey{19, 2} = 1;
itemkey{20, 1} = 'An antique drawing of City Hall shows a fountain in front.';
itemkey{20, 2} = 2;

questionkey = itemkey(:,1);
answerkey =  cell2mat(itemkey(:,2));


% belief
d   = dir(fullfile(defaults.path.stim, '*belief_question.txt'));
bq  = strcat(defaults.path.stim, filesep, {d.name});
d   = dir(fullfile(defaults.path.stim, '*belief_story.txt'));
bs  = strcat(defaults.path.stim, filesep, {d.name});
for i = 1:10

%     belief(i).storyfile = bs{i};
%     belief(i).questionfile = bq{i};

    % story
    fidlog = fopen(bs{i});
    text = [];
    while 1
        tmp = fgetl(fidlog);
        if ~ischar(tmp), break, end
        text = [text ' ' deblank(tmp)];
    end
    belief(i).story = strtrim(deblank(text));

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
    belief(i).question = strtrim(deblank(text));
    idx = find(strcmpi(questionkey, belief(i).question));

    if isempty(idx), print('EMPTY IDX!!!'); return; end
    belief(i).answer = answerkey(idx);
end

% false-photo
d = dir(fullfile(defaults.path.stim, '*photo_question.txt'));
pq = strcat(defaults.path.stim, filesep, {d.name});
d = dir(fullfile(defaults.path.stim, '*photo_story.txt'));
ps = strcat(defaults.path.stim, filesep, {d.name});
for i = 1:10

%     photo(i).storyfile = ps{i};
%     photo(i).questionfile = pq{i};

    % story
    fidlog = fopen(ps{i});
    text = [];
    while 1
        tmp = fgetl(fidlog);
        if ~ischar(tmp), break, end
        text = [text ' ' deblank(tmp)];
    end
    photo(i).story =  strtrim(deblank(text));

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
    photo(i).question =  strtrim(deblank(text));
    
    idx = find(strcmpi(questionkey, photo(i).question));
    if isempty(idx), print('EMPTY IDX!!!'); return; end
    photo(i).answer = answerkey(idx);
end

b = belief;
p = photo;


save english_tom.mat b p





