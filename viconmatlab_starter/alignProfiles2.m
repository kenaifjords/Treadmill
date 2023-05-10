function [alignedMatrix,centerI] = alignProfiles2(trialProfiles,alignIndices)

    % the profiles must be a cell structure arranged in a column vector
        % this means that the first profile is a cell {1,1}, the next
        % profile is {2,1}, so on and so forth
    % the indices input is a vector of integers
    
    B = trialProfiles; 
    tricount = size(trialProfiles,1);
    I = alignIndices;
    % determine pretail
    ptail = max(I,[],'omitnan');
    % determine tail (a) determine the length of each profile and (b)
    % identify the tail needed (can sort out profiles longer than 2 seconds)
    for j = 1:tricount
        if isnan(I(j))
            % do nothing
            lengthTail(j) = NaN;
        else
            lengthProfile(j) = length(B{j,1});
    %         if lengthProfile(j) > 3000
    %             lengthProfile(j) = NaN;
    %         end
            if isnan(I(j))
                lengthTail(j) = lengthProfile(j);
            end
            lengthTail(j) = lengthProfile(j) - I(j);
        end
    end
    tail = max(lengthTail);
    % preassign matrix

    aM = nan(tricount, (ptail + tail + 2)); % allows for a nan pad on longest trial
    % add each profile to the matrix
    for j =1:tricount
        if sum(isnan(B{j,1})) == 1
            aM(j,:) = nan(1,(ptail + tail + 2));
        else
            if isnan(I(j))
                % do nothing
            else
                profile_in = B{j,1}';
                if size(profile_in,1) ~= 1
                    profile_in = profile_in';
                end            
                ppad = ptail - I(j) + 1;
                pad = tail - (lengthProfile(j) - I(j)) + 1;
                prepad = nan(1,ppad);
                pprof = cat(2, prepad,profile_in);
                postpad= nan(1,pad);
                prof = cat(2,pprof,postpad);
                prof(prof == -1) = NaN;
                aM(j,:) = prof;
            end
        end
    end
    alignedMatrix = aM;
    centerI = ptail;
end