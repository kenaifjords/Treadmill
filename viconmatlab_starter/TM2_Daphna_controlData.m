%% TM2_Daphna_control group data set
% run TM2_01_build, 02b_identifyHeelStrikes, and 03b_heelStrikeValidation
if 0
% identify control subjects
cg_idx = find(sum(subject.order,2) == 0);
% force data
cF = F(cg_idx);
% marker data
cp = p(cg_idx);

% subject specifics
csubject.list = subject.list(cg_idx);
csubject.fastleg = subject.fastleg(cg_idx);
csubject.weight_kg = subject.mass(cg_idx);
csubject.height_mm = subject.height(cg_idx);
csubject.daysbtw = subject.daysbtw(cg_idx);
csubject.leglength = subject.leglength(cg_idx);
csubject.feetonly = subject.feetonly(cg_idx);


%% SAVE
save('control_force','cF')
save('control_mark','cp')
save('controlsubject','csubject')
end

%% Load
if ~exist('cF')
    f = load('control_force.mat');
    cF = f.cF;
end
if ~exist('cp')
    f = load('control_mark.mat');
    cp = f.cp;
end
if ~exist('csubject')
    f = load('controlsubject.mat');
    csubject = f.csubject;
end
clear f

%% Example GRF
% choose control subject
subj = 4;
% choose slow baseline block
blk = 2;
% find fast leg (binary, R = 1, L = 0) consistent for all blocks
fl = csubject.fastleg(subj);

if fl == 1 % fast leg is right
    fl_frc = cF(subj).R{3,blk}; % 3 refers to the effort condition
                                % so is unchanging for these groups
    sl_frc = cF(subj).L{3,blk};
    fl_color = 'r'; sl_color = 'g';
    % get valid heelstrike indices
    fl_vHS = cF(subj).hsR_idx{3,blk}(cF(subj).validstepR{3,blk}(:,1));
    sl_vHS = cF(subj).hsL_idx{3,blk}(cF(subj).validstepL{3,blk}(:,1));
    fl_vTO = cF(subj).toR_idx{3,blk}(cF(subj).validstepR{3,blk}(:,1));
    sl_vTO = cF(subj).toL_idx{3,blk}(cF(subj).validstepL{3,blk}(:,1));

elseif fl == 2 % fast leg is left
    fl_frc = cF(subj).L{3,blk};
    sl_frc = cF(subj).R{3,blk};
    sl_color = 'r'; fl_color = 'g';
    % get valid heelstrike indices
    sl_vHS = cF(subj).hsR_idx{3,blk}(cF(subj).validstepR{3,blk}(:,1));
    fl_vHS = cF(subj).hsL_idx{3,blk}(cF(subj).validstepL{3,blk}(:,1));
    sl_vTO = cF(subj).toR_idx{3,blk}(cF(subj).validstepR{3,blk}(:,1));
    fl_vTO = cF(subj).toL_idx{3,blk}(cF(subj).validstepL{3,blk}(:,1));
end

% plot vgrf 
figure('Name','VGRF'); hold on;
plot(fl_frc(:,3),fl_color); % 3 choose z force
plot(sl_frc(:,3),sl_color);

% add validated heelstrikes to the plot
plot(fl_vHS, fl_frc(fl_vHS),'*')
plot(sl_vHS, sl_frc(sl_vHS),'*')

%% Example COP

if fl == 1 % fast leg is right
    fl_cop = cF(subj).COPR{3,blk}; 
    sl_cop = cF(subj).COPL{3,blk};
    fl_color = 'r'; sl_color = 'g';
%     fl_cop(fl_cop > 800) = NaN; sl_cop(sl_cop < 300) = NaN;

elseif fl == 2 % fast leg is left
    fl_cop = cF(subj).COPL{3,blk};
    sl_cop = cF(subj).COPR{3,blk};
    sl_color = 'r'; fl_color = 'g';
%     fl_cop(fl_cop < 300) = NaN; sl_cop(sl_cop > 800) = NaN;
end

% keep COP only when foot is on the treadmill
fl_cop_all = fl_cop;
for istep = 1:length(fl_vTO)
    if istep == 1
        fl_cop(1:fl_vHS(istep),:) = NaN;
    end
    if length(fl_vHS) > istep
%        disp([ num2str(fl_vTO(istep)) ',' num2str(fl_vHS(istep+1))])
       fl_cop(fl_vTO(istep) + 1:fl_vHS(istep + 1) - 1,:) = NaN;
    end
end

sl_cop_all = sl_cop;
for istep = 1:length(sl_vTO)
    if istep == 1
        sl_cop(1:sl_vHS(istep),:) = NaN;
    end
    if length(sl_vHS) > istep
%        disp([ num2str(sl_vTO(istep)) ',' num2str(sl_vHS(istep+1))])
       sl_cop(sl_vTO(istep) + 1:sl_vHS(istep + 1) - 1,:) = NaN;
    end
end

% plot COP
figure('Name','COP')
subplot(121); title('x COP'); hold on;
% plot(fl_cop(:,1),fl_cop(:,2),fl_color);
plot(fl_cop(:,1),fl_color);
plot(sl_cop(:,1),sl_color);
plot(fl_vHS,fl_cop(fl_vHS,1),'*')
plot(sl_vHS,sl_cop(sl_vHS,1),'*')
plot(fl_vTO,fl_cop(fl_vTO,1),'o')
plot(sl_vTO,sl_cop(sl_vTO,1),'o')
% add validated heelstrikes to the plot
% plot(fl_cop(fl_vHS,1), fl_cop(fl_vHS),'*')

subplot(122); title('y COP'); hold on;
plot(fl_cop(:,2),fl_color);
plot(sl_cop(:,2),sl_color);
plot(fl_vHS,fl_cop(fl_vHS,2),'*')
plot(sl_vHS,sl_cop(sl_vHS,2),'*')
plot(fl_vTO,fl_cop(fl_vTO,2),'o')
plot(sl_vTO,sl_cop(sl_vTO,2),'o')
% plot(sl_cop(:,1),fl_cop(:,2),sl_color);
% plot(sl_cop(sl_vHS), sl_cop(sl_vHS),'*')

figure('Name','COP'); hold on;
plot(fl_cop(:,1),fl_cop(:,2),fl_color);
plot(sl_cop(:,1),sl_cop(:,2),sl_color);

%% EXample Marker

if fl == 1 % fast leg is right
    fl_ankle = cp(subj).Rankle{3,blk};
    fl_toe = cp(subj).Rtoe{3,blk};
    fl_heel = cp(subj).Rheel{3,blk};
    
    sl_ankle = cp(subj).Lankle{3,blk};
    sl_toe = cp(subj).Ltoe{3,blk};
    sl_heel = cp(subj).Lheel{3,blk};

elseif fl == 2 % fast leg is left
    fl_ankle = cp(subj).Lankle{3,blk};
    fl_toe = cp(subj).Ltoe{3,blk};
    fl_heel = cp(subj).Lheel{3,blk};
    
    sl_ankle = cp(subj).Rankle{3,blk};
    sl_toe = cp(subj).Rtoe{3,blk};
    sl_heel = cp(subj).Rheel{3,blk};
end

% plot ankle marker on saggital plane
figure('Name','Foot Position'); 
subplot(211); hold on;
plot(fl_ankle(:,1), fl_ankle(:,2),fl_color); % 2 chooses x and y positions
plot(sl_ankle(:,1), sl_ankle(:,2),sl_color);

subplot(212); hold on;
plot(fl_ankle(:,2), fl_ankle(:,3),fl_color); % 2 chooses y and z positions
plot(sl_ankle(:,2), sl_ankle(:,3),sl_color);
 
% add validated heelstrikes to the plot
plot(fl_ankle(fl_vHS,2), fl_ankle(fl_vHS,3),'*')
plot(sl_ankle(sl_vHS,2), sl_ankle(sl_vHS,3),'*')