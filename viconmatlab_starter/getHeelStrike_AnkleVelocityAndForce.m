function [ihs1,ihs2,ito1,ito2] = ...
    getHeelStrike_AnkleVelocityAndForce(F1,F2,pankle1,pankle2)

    % get z forces
    fz1 = F1(:,3);
    fz2 = F2(:,3);
    % z heel positions
    ankle1 = pankle1(:,3);
    ankle2 = pankle2(:,3);
    % heel height thresholds
    anklerange1 = max(ankle1) - min(ankle1);
    anklerange2 = max(ankle2) - min(ankle2);
    thresh1 = 0.25*anklerange1 + min(ankle1);
    thresh2 = 0.25*anklerange2 + min(ankle2);
    
    % find ankle velocity - output of the differentiation function is
    % filtered original, first derivative, second derivative
    z1 = diff23f5(ankle1,1/100,10);
    z2 = diff23f5(ankle2,1/100,10);
    % vertical velocity
    vz1 = z1(:,2);
    vz2 = z2(:,2);
    
    % identify local maxima on a step to step time line - this is
    % characteristic of toe off
    [~,ito1] = findpeaks(vz1,'MinPeakDistance',50,'MinPeakHeight',200);
    [~,ito2] = findpeaks(vz2,'MinPeakDistance',50,'MinPeakHeight',200);
    
    % identify local minima on a shorter time interval, this generates a 
    % set of potential heel strikes
    [~,set_hs1] = findpeaks(-vz1,'MinPeakDistance',10,'MinPeakHeight',200);
    [~,set_hs2] = findpeaks(-vz2,'MinPeakDistance',10,'MinPeakHeight',200);
            
    % use a threshold on the heel height to select the proper heel
    % strike (i could also implement a force-based constraint here)
    inset1 = find(ankle1(set_hs1) < thresh1);
    ihs1_0 = set_hs1(inset1);
    inset2 = find(ankle2(set_hs2) < thresh2);
    ihs2_0 = set_hs2(inset2);
    
    % find the force threshold heel strike using the vertical foot
    % velocity heel strike as a starting point
    forcethresh = 100; % N
    % for forceplate 1
    clear j k
    for i = 1:length(ihs1_0)
        % if greater than the threshold force, count backward to
        % idenify the last point where the force was less than the
        % threshold
        threshdiff = fz1(ihs1_0(i)) - forcethresh;
        if threshdiff > 0 && threshdiff > forcethresh % fzr(iR_heelstrike(i)) > forcethresh
            j = ihs1_0(i);
            while fz1(j) > forcethresh
                j = j-1;
            end
            ihs1(i) = j;
        elseif threshdiff < 0 && abs(threshdiff) > forcethresh % fzr(iR_heelstrike(i) < forcethresh
            k = ihs1_0(i);
            while fz1(k) < forcethresh && k < length(fz1)
                k = k+1;
            end
            ihs1(i) = k;
        else
            ihs1(i) = ihs1_0(i);
        end
    end
    % for forceplate 2
    clear j k
    for i = 1:length(ihs2_0)
        % if greater than the threshold force, count backward to
        % idenify the last point where the force was less than the
        % threshold
        threshdiff = fz2(ihs2_0(i)) - forcethresh;
        if threshdiff > 0 && threshdiff > forcethresh % fzr(iR_heelstrike(i)) > forcethresh
            j = ihs2_0(i);
            while fz2(j) > forcethresh
                j = j-1;
            end
            ihs2(i) = j;
        elseif threshdiff < 0 && abs(threshdiff) > forcethresh % fzr(iR_heelstrike(i) < forcethresh
            k = ihs2_0(i);
            while fz2(k) < forcethresh && k < length(fz2)
                k = k+1;
            end
            ihs2(i) = k;
        else
            ihs2(i) = ihs2_0(i);
        end
    end
end
