
global homepath subject F p colors asym


tic

includebothvisits = 1;
includeblks = 2;
plotallaxes = 0;
plotallsubj = 0;
lntyp = {'-', '--'};


for subj = 1%:subject.n % FUM BAB COM

    if subject.order(subj,1) == 1 % the first elt is 1, starts with HE nx2 matrix
        effcond0 = 1;
    else
        effcond0 = 2;
    end
    % if we want to include both visits
    if includebothvisits
        effcond0 = [1 2];
    end
    rfastsubj = 1; lfastsubj = 1;
    
    for effcond =  effcond0 % 1:length(subject.effortcondition)
        
        for blk = includeblks % 1:subject.nblk
%             subj
%             effcond
%             blk
           
            for axis = [2 3] %to plot x,y,z
                % forces             
                infR = F(subj).R{effcond,blk}(:,axis);%column vector
                infL = F(subj).L{effcond,blk}(:,axis);
                %infR_BW = infR/subject.weight{subj};
                %infL_BW = infL/subject.weight{subj}; 

                % HS index
                inF_hsRidx = F(subj).hsR_idx{effcond,blk};
                inF_hsLidx = F(subj).hsL_idx{effcond,blk};

                %search peak index per stride
                inF_idxR = F(subj).idxR{effcond,blk};
                inF_idxL = F(subj).idxL{effcond,blk};
                lenMR = length(inF_idxR);
                lenML = length(inF_idxL);


                for strdR = 1 : length(inF_hsRidx)-1
                    if ~isnan(inF_hsRidx(strdR)) && ~isnan(inF_hsRidx(strdR+1))
                        F(subj).strideForceR{effcond,blk} = infR(inF_hsRidx(strdR) : inF_hsRidx(strdR+1));         
                    else
                        strideForceR = [];                
                    end
                    strdFR{1,strdR} = F(subj).strideForceR{effcond,blk}; %cell not in F                    
                    lenR(1,strdR) = length(strdFR{1,strdR});
                end
                    lencellR = length(strdFR);

                for strdL = 1 : length(inF_hsLidx)-1
                    if ~isnan(inF_hsLidx(strdL)) && ~isnan(inF_hsLidx(strdL+1))
                        F(subj).strideForceL{effcond,blk} = infL(inF_hsLidx(strdL) : inF_hsLidx(strdL+1));
                    else
                        stridForceL = []; %F(subj).strideForceL{effcond,blk} = [];   
                    end
                    strdFL{1,strdL} = F(subj).strideForceL{effcond,blk};
                    lenL(1,strdL) = length(strdFL{1,strdL});
                end
                    lencellL = length(strdFL);

%                 inF_strideForceR = F(subj).strideForceR{effcond,blk};
%                 inF_strideForceL = F(subj).strideForceL{effcond,blk};
%                 numStrideR = length(inF_strideForceR);
%                 numStrideL = length(inF_strideForceL);

                for var1 = 1:lenMR 
                        peakR(1,var1) = max(strdFR{1,var1}(inF_idxR(var1):end));%row matrix of peak forces per stride
                        %PeakR.peakR(subj,effcond,blk,axis) = peakR(1,var1);                 
                end

                for var2 = 1:lenML                    
                        peakL(1,var2) = max(strdFL{1,var2}(inF_idxL(var2):end));  
                        %PeakL.peakL(subj,effcond,blk,axis) = peakL(1,var2);
                end

%                 inF_peakR = F(subj).peakR{effcond,blk};
%                 
%                 figure
%                 subplot(1,length(includeblks),blk - (includeblks(1)-1)); hold on;
%                 [~] = plot(numStrideR,inF_peakR,'.b');

%                 for var2 = 1:length(inF_idxL)
%                     F(subj).peakL{effcond,blk} = max(inF_strideForceL(inF_idxL(var2):end));     
%                 end                
             end
        end
    end
end





toc