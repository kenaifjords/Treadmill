function [ihs1,ihs2,ito1,ito2] = ...
    getHeelStrike_FootVelocityAndForce(F1,F2,pheel1,pheel2,ptoe1,ptoe2)

    % get z forces
    fz1 = F1(:,3);
    fz2 = F2(:,3);
    % z heel positions
    heel1 = pheel1(:,3);
    heel2 = pheel2(:,3);
    % heel height thresholds
    heelrange1 = max(heel1) - min(heel1);
    heelrange2 = max(heel2) - min(heel2);
    heelthresh1 = 0.25*heelrange1 + min(heel1);
    heelthresh2 = 0.25*heelrange2 + min(heel2);
    % toe positions
    toe1 = ptoe1(:,3);
    toe2 = ptoe2(:,3);
    % find foot center
    foot1 = (pheel1 + ptoe1)/2;
    foot2 = (pheel2 + ptoe2)/2;
    % find foot center in vertical position
    foot1z = foot1(:,3);
    foot2z = foot2(:,3);
    
    % remove NaN for filtering
        
    % find foot center velocity - output of the differentiation function is
    % filtered original, first derivative, second derivative
    z1 = diff23f5(foot1z,1/100,10);
    z2 = diff23f5(foot2z,1/100,10);
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
    inset1 = find(heel1(set_hs1) < heelthresh1);
    ihs1_0 = set_hs1(inset1);
    inset2 = find(heel2(set_hs2) < heelthresh2);
    ihs2_0 = set_hs2(inset2);
    
    % find the force threshold heel strike using the vertical foot
    % velocity heel strike as a starting point
    forcethresh = 100; % N
    % for forceplate 1
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
            while fz1(k) < forcethresh
                k = k+1;
            end
            ihs1(i) = k;
        else
            ihs1(i) = ihs1_0(i);
        end
    end
    % for forceplate 2
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
            while fz2(k) < forcethresh
                k = k+1;
            end
            ihs2(i) = k;
        else
            ihs2(i) = ihs2_0(i);
        end
    end
end
