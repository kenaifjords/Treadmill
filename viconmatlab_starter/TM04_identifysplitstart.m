% TM04_identifysplitstart
global homepath subject F p colors asym
close all
approx_stependbase_save = 20;
approx_stependbase_learn = 80;
mult_std_thresh = 3;
yesplot = 1;

if yesplot == 1
    figure(); hold on;
    title('subject learning curves')
    ylabel('asymmetry');
    xlabel('steps')
    legend
end

for subj = 1:subject.n
    for blk = 1:length(subject.blockname)
        nostart = 0; %reset flag
        % find mean and variability of baseline
        if mod(blk,2) == 1 %odd number blk refers to learning
            approx_endbase = approx_stependbase_learn;
        elseif mod(blk,2) == 0 % even number blk refers to savings
            approx_endbase = approx_stependbase_save;
        end
        base_meanasym = mean(asym{subj}.asymlength{blk}(1:approx_endbase));
        base_stdasym = std(asym{subj}.asymlength{blk}(1:approx_endbase));
        
%         % find first step with variability greater than 4*std?
%         startsplit_step = find(asym{subj}.asymlength{blk}(approx_endbase:end) > base_meanasym + mult_std_thresh * base_stdasym,...
%             1, 'first') + approx_endbase;
%         mult_std_threshw = mult_std_thresh;
%         while isempty(startsplit_step)
%             startsplit_step = find(asym{subj}.asymlength{blk}(approx_endbase:end) > base_meanasym + (mult_std_threshw-1) * base_stdasym,...
%             1, 'first');
%             if mult_std_threshw < 2
%                 nostart = 1;
%                 break
%             end
%             if isempty(startsplit_step) || startsplit_step == 1
%                 fprintf(['split start not identified: subj ' subject.list{subj} ' blk ' num2str(blk)]);
%                 nostart = 1; %flag
%                 break
%             else
%                 startsplit_step = startsplit_step + approx_endbase;
%             end
% %             fprintf('stuck here')
% %             fprintf(['split start not identified: subj ' num2str(subj) 'blk ' num2str(blk)])
% %             mult_std_threshw
% %             startsplit_step
%         end
        
        % find moving average
        smoothasym = movmean(asym{subj}.asymlength{blk},9); % sliding average over 5 steps
        
%         % find peak of smoothed asym
%             [smoothpk,ipk] = max(abs(smoothasym));
%             % find the first asym step that is greater than 75%(?) of max
%             pkthresh = 0.65*smoothpk;
%             startsplit_step = find(smoothasym > pkthresh,1,'first');
%             
        % find start step from asym delta from smooth
        smoothasym_diff = smoothasym(2:end) - smoothasym(1:end-1);
        smoothasym_diff = [smoothasym_diff; 0];
        [smoothpk,ipk] = max(abs(smoothasym_diff));
        pkthresh = 0.9*smoothpk;
        startsplit_step = ipk; %find(smoothasym > pkthresh,2); % ipk;
        
%         if yesplot == 1
%             figure(333); hold on;
%             if subject.fastleg(subj,blk) == 1
%                 learn = -smoothasym;
%             else
%                 learn = smoothasym;
%             end
%             plot(learn,'DisplayName', [subject.list{subj} ' : ' num2str(blk)]);
% %             plot(asym{subj}.asymlength{blk},':','LineWidth', 0.5)
%             plot(startsplit_step,smoothasym(startsplit_step),'ro')
%             ylim([-1.2,1.2]);
%             
%         end     
        
        %### here need to identify endsplit with time and find nearest step
        %index
        % plot learning curves
        if yesplot == 1
            if nostart == 0
                if 0 %subject.fastleg(subj,blk) == 1
                    learn = -asym{subj}.asymlength{blk}; %(startsplit_step-20:end);%
                    smoothlearn = -smoothasym;
                else
                    learn = asym{subj}.asymlength{blk};% (startsplit_step-20:end); %
                    smoothlearn = smoothasym;
                end
                figure(subj+100); hold on; title(subject.list{subj})
                plot(learn,'DisplayName', [subject.list{subj} ' : ' num2str(blk)]);
                plot(smoothlearn,':')
                plot(startsplit_step, asym{subj}.asymlength{blk}(startsplit_step),'ro')
                ylim([-1.2,1.2]);
            end     
        end
    end
end