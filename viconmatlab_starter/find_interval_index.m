

function[idx_R,idx_L] = find_interval_index(forceR,forceL,hsR_idx,hsL_idx)

%% %%%%%%%%%% right leg %%%%%%%%%%%% %%
for strdR = 1 : length(hsR_idx)-1
    if ~isnan(hsR_idx(strdR)) && ~isnan(hsR_idx(strdR+1))
        strideForceR{1,strdR} = forceR(hsR_idx(strdR) : hsR_idx(strdR+1));       
    else
        strideForceR = [];                
    end
end

for var1 = 1:length(hsR_idx)-1
    [MaxR(var1),iMaxR(var1)] = max(strideForceR{1,var1});%row vectors of maximum and index
    [MinR(var1),iMinR(var1)] = min(strideForceR{1,var1});%row vectors of minimum and index     
end
 
for var2 = 1:length(iMaxR)
    F_intvl_R{1,var2} = strideForceR{1,var2}(iMinR(var2):iMaxR(var2));
end

for var3 = 1:length(iMaxR)
   fbR{1,var3} = (F_intvl_R{1,var3} < 0);
end

neg2pos_pattern = [1 0];

for var4 = 1:length(iMaxR)
    idx0_R(1,var4) = find(F_intvl_R{1,var4} > 0, 1,'last');%row vector containing the indices of neg2pos for each stride
end

for var5 = 1:length(iMaxR)
    idx_R(1,var5)= idx0_R(var5)+iMinR(var5)-1; % row vector of indices of interest for each stride
end

%% %%%%%%%%%%%%%%%% left leg %%%%%%%%%%%% %%

for strdL = 1 : length(hsL_idx)-1
    strideForceL{1,strdL} = forceL(hsL_idx(strdL) : hsL_idx(strdL+1));     
end

for var6 = 1:length(hsL_idx)-1
    [MaxL(var6),iMaxL(var6)] = max(strideForceL{1,var6});%row vectors of maximum and index
    [MinL(var6),iMinL(var6)] = min(strideForceL{1,var6});%row vectors of minimum and index       
end
 
for var7 = 1:length(iMaxL)
    F_intvl_L{1,var7} = strideForceL{1,var7}(iMinL(var7):iMaxL(var7)); 
end

for var8 = 1:length(iMaxL)
   fbL{1,var8} = (F_intvl_L{1,var8} < 0);
end

neg2pos_pattern = [1 0];

for var9 = 1:length(iMaxL)
    %figure(1); plot(F_intvl_L); title(['subject' 'effcond' 'blk' 'axis' 'var9 ' num2str(var9)]);
    if isempty(find(F_intvl_L{1,var9} > 0,1,'last'))
        idx0_L(1,var9) = NaN;
        %disp(['subject' 'effcond' 'blk' 'axis' 'var9' num2str(var9)])
    else 
        idx0_L(1,var9) = find(F_intvl_L{1,var9} > 0,1,'last');%row vector containing the indices of neg2pos for each stride
    end
    
end

for var10 = 1:length(iMaxL)
    idx_L(1,var10)= idx0_L(var10)+iMinL(var10)-1; % row vector of indices of interest for each stride
end


end






 
