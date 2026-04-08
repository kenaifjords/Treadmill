function plotsparklines(array, array_col)
% plot sparklines
% input is a X x Y cell structure containing profiles that will be plotted
% in the same layout.
% we find the longest profile among all cells
mx0 = max(cellfun(@length,array));
mx = max(mx0); % the plus 2 is just a little extra padding, have to ...
% check the function...
% plot lines in each column are padded horizontally with NaNs using 
% alignProfiles3
clear mat
for col = 1:size(array,2)
    cel = array(:,col);
    mat_out = alignProfiles2(cel,ones(size(array,1),1));
%     size(mat_out)
    tack_on = mx + 2 - size(mat_out,2);
    if size(mat_out) < mx + 2 % +2 is a pad added in the align function
        mat0 = [mat_out NaN(size(array,1),tack_on)];
    else
        mat0 = mat_out;
    end
%     size(mat0)
    mat(:,:,col) = mat0;
    clear mat0 mat_out
% end
end
% set x value for plotting
proflength = mx + 2;
x0 = 1:proflength; x = x0/(proflength/3);
% set maximum and minimum y rng for plotting
mxpk = max(mat,[],'all');
mnpk = min(mat,[],'all');
yrng = mxpk - mnpk;

% generate 
figure(); hold on;
for col = 1:size(array,2)
    m = mat(:,:,col);
    for i = 1:size(m,1)
        prof0 = m(i,:);
        % scale it vertically
        prof = prof0 / yrng;
        % set position in page (this is basically the 0,0 point for the
        % individual spark line) (col, i)
        prof_place = prof + i/2;
        x_place = x + 3 * col + col*0.5;
        % actually plot the line
        if isempty(array_col{i,col})
            % do nothing
        else
            plot(x_place,prof_place,'Color',array_col{i,col})
        end
        plot([0 x_place(end)],[i/2, i/2],'k')
    end
    
end
end