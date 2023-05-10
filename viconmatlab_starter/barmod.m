function hBar = barmod(varargin)%(x,ar,bo,bgo,xlimo,ylimo,labels)
% x = plot data (number or bar groups x number of bars per group
% ar = aspectratio width / height
% bo = bar offset :
% bgo – bar group offset (spacing between groups of bars—input as ratio to *total bar group width)
% xlimo – x-limit offset (space between left/right extents of bar chart data and left/right extents of plot, respectively—input as ratio to total bar group width)
% ylimo – y-limit offset (space between top/bottom extents of bar chart data and top/bottom extents of plot, respectively—input as ratio to total bar group width)
% labels – labels corresponding to bar groups.

%Empty inputs declaration
x = []; yhp = x; ar = x; bgo = x; bo = x; xlimo = x; ylimo = x;  labels = x;



if nargin >= 1
    x = varargin{1}; %input data
    %default: (1-5)x(1-5) randomized data set
    if nargin >= 2
        yhp = varargin{2}; %plot height (pixels)
        %default: 500
        if nargin >= 3
            ar = varargin{3}; %aspect ratio (width/height)
            %default: 5/4
            if nargin >= 4
                bo = varargin{4}; %bar offset (width between bars in groups)
                %default: 0
                if nargin >= 5
                    bgo = varargin{5}; %bar group offset (width between bar groups)
                    %default: 1/2 (total bar group width)
                    if nargin >= 6
                        xlimo = varargin{6}; %xlim offset (either side of bar chart)
                        %default: same size as "bgo"
                        if nargin >= 7
                            ylimo = varargin{7}; %ylim offset (top and bottom of bar chart)
                            %default: same size as "xlimo"
                            if nargin >= 8
                                labels = varargin{8}; %x-tick labels
                                %default: %strcat('label',num2str(#datapoints/set))
                            end
                        end
                    end
                end
            end
        end
    end 
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "x":
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Creating default (1-5)x(1-5) randomized data set
        if isempty(x)
            NBG = ceil(rand*5);
            n = ceil(rand*5);
            x = rand(NBG,n) -.2; %default: random 1-to-5 x 1-to-5 bar chart
        end 

%Storing "x" size data
        szx = size(x);
        NBG = szx(1); %number of bar groups (data points/set)
        n = szx(2); %number of bars/group (data sets)

%In case of row vector input, make column vector
        if NBG == 1 
            x = x'; 
            szx = size(x);
            NBG = szx(1); 
            n = szx(2);
        end

%In case of datum input, reject input
        if NBG == 1 && n == 1
    error('This function does not support data inputs of a single datum.')
        end

        
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                           Plotting bar chart
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%

        hBar = bar(x,'hist');
        hold on

%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                            Sizing bar chart
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "yhp":
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        if isempty(yhp)
        yhp = 500; %default pixel height of plot
        end        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "ar":
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isempty(ar)
        ar = 5/4; %default aspect ratio
        end
        
%Centering bar chart
        xwp = yhp*ar; %pixel width of plot
        ss = get(0,'screensize'); %retrieving screen resolution
        ss = ss(3:4);
        set(gcf, 'Position',  [(ss(1)-xwp)/2, (ss(2)-yhp)/2, xwp, yhp])

        
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%               Important bar chart modification parameters
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%


%Bar group width (bgw) system defaults (determined experimentally)
        if n == 1
            bgw = 1; 
        elseif 2 <= n && n <= 6
            bgw = 2*n/(2*n + 3);
        elseif n > 6
            bgw = .8;
        end

        bw = bgw/n; %bar width
        bgs = 1 - bgw; %bar group space (width of space between bar groups)

        
%Original x-coordinate of each bar centroid
        oc = x; %(same size as input "x")
        for i = 1:NBG 
            for j = 1:n
                oc(i,j) = i - bgw*(n-1)/(2*n) + (j-1)*bgw/n; %original centers
            end
        end
     
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "bo"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isempty(bo)
        bo = 0; %bar space offset - default: 0 (no space)
        end
        bo = bo*bw; %scaling to bar width
        
%creating a total bar group width that accounts for bar offest
        tbgw = bgw + bo*(n-1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "bgo"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isempty(bgo)
        bgo = 1/2; %bar group offset - default: half the bar group width
        end
        bgo = bgo*tbgw; %scaling to total bar group width

        
%Displacement of each bar
        d = x; %distance each bar moves (same size as x)
        for i = 1:NBG
            for j= 1:n
                d(i,j) = i*(bgs-bgo-(n-1)*bo) - j*bo;
            end
        end

nbc = oc-d; %new bar center
nbgc = mean(nbc,2); %new bar group center


%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                       Modifying bar chart limits
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "xlimo"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isempty(xlimo)
            xlimo = bgo; %plot limits offset - default: same size as bgo
        else
            xlimo = xlimo*tbgw; %accounting for bar offset
        end
        
        
%Modifying x limits
        xlimRB = nbc(szx(1),szx(2))+bw/2; %right xlim, to the final bar
        xlimR = xlimRB + xlimo; %final right xlim, including xlim offset
        xlimLB = nbc(1,1)-bw/2; %left xlim, beginning at first bar
        xlimL = xlimLB - xlimo; %first xlim, including xlim offset
        xlim([xlimL xlimR])
        
        
%Modifying y limits
        xwv = xlimR-xlimL; % value width of the plot along x-axis
        xpr = xwp/xwv; %pixel-to-value ratio along x-axis
        xlimop = xlimo*xpr; %pixel width of xlim offset
    
    %Accounting for negative input 
        yminv = min(min(x));
        ymaxv = max(max(x));
        
    %Accounting for pixel offset (visual adjustment)
        if 0 <= ar && ar <= 1
            po = 8/3*ar + 4/3;%some pixel offset I think that makes it just
            %not quite right. Pretty sure the math is right--just visually,
            %seemed just barely off.
        else
            po = 4;
        end
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "ylimo"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isempty(ylimo)
            ylimop = xlimop - po; %plot limits offset - default: same size as xlimop
        else
            ylimop = ylimo*tbgw*xpr - po; %accounting for bar offset
        end
    
        
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%              Case of both positive and negative input values
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%

        if yminv < 0
            %ensuring the ylimo input value works
            if 2*ylimop >= yhp
                ylimolim = (yhp/2 + po)/(tbgw*xpr); %ylim limit
                error(string(strcat('Your y-limit offset exceeds the pixel height of the plot.',...
                    {' '},'Please choose a value in the range 0 <= ylimo <',{' '},num2str(ylimolim),'.')))                
                return
            end
            yspanp = yhp - 2*ylimop; %getting the pixel height of ymax
            yspanv = ymaxv - yminv; %pulling in ylim bar extents
            ypr = yspanp/yspanv; %pixel-to-value ratio along y-axis
            ylimo = ylimop/ypr; %offset for bottom of plot
            ylim([yminv-ylimo ymaxv+ylimo])

%visual square test
%                     hold on
%                     plot([xlimL xlimR],[ymaxv ymaxv])
%                     plot([xlimL xlimR],[yminv yminv])
%                     plot([xlimRB xlimRB],[yminv-ylimo ymaxv+ylimo])
%                     plot([xlimLB xlimLB],[yminv-ylimo ymaxv+ylimo])

%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                     Case of all negative input values
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%

                    if ymaxv < 0
                %ensuring the ylimo input value works
                if ylimop >= yhp
                        ylimolim = (yhp + po)/(tbgw*xpr); %ylim limit
                        error(string(strcat('Your y-limit offset exceeds the pixel height of the plot.',...
                            {' '},'Please choose a value in the range 0 <= ylimo <',{' '},num2str(ylimolim),'.')))
                        return
                    end
                    yspanp = yhp - ylimop; %getting the pixel height of ymax
                    yspanv = 0 - yminv; %pulling in maximum bar height
                                        %(associated with minimum bar value in this case)
                                        %"0" there to indicate the difference between ymax and ymin
                                        %(ymaxv = 0 here, as we are starting from the top axis)
                    ypr = yspanp/yspanv; %pixel-to-pixel ratio along y-axis
                    ylimo = ylimop/ypr; %offset for bottom of plot
                    ylim([yminv-ylimo 0])
                    
%visual square test
%                     hold on
%                     plot([xlimL xlimR],[yminv yminv])
%                     plot([xlimRB xlimRB],[yminv-ylimo 0])
        
                    end
        else
        
            
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                     Case of all positive input values
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%

            %ensuring the ylimo input value works
            if ylimop >= yhp
                ylimolim = (yhp + po)/(tbgw*xpr); %ylim limit
                error(string(strcat('Your y-limit offset exceeds the pixel height of the plot.',...
                    {' '},'Please choose a value in the range 0 <= ylimo <',{' '},num2str(ylimolim),'.')))
                return
            end
            yspanp = yhp - ylimop; %getting the pixel height of ymax
            yspanv = ymaxv - 0; %pulling in maximum bar height
                                %"0" there to indicate the difference between ymax and ymin
                                %(ymin = 0 here, as we are starting from the bottom axis)
            ypr = yspanp/yspanv; %pixel-to-pixel ratio along y-axis
            ylimo = ylimop/ypr; %offset for bottom of plot
            ylim([0 ymaxv+ylimo])
            
%visual square test
%                     hold on
%                     plot([xlimL xlimR],[ymaxv ymaxv])
%                     plot([xlimRB xlimRB],[0 ymaxv+ylimo])
        end

%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                        Applying bar group labels
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading in "labels"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if isempty(labels)
            for i = 1:NBG
            labels{i} = strcat('title',num2str(i));
            end
        end
               
        
%warning if labels array is not the correct size
        if length(labels) < NBG
            warning(string(strcat('Your label array size is less than the number of',...
                {' '},'bar groups. To keep label elements from looping, make sure',...
                {' '},'your label array contains as many as elements as bar groups',...
                {' '},'(in your case,',{' '},num2str(NBG),').')));
        elseif length(labels) > NBG
            warning(string(strcat('Your label array size is greater than the number of',...
                {' '},'bar groups. You may have accidentally forgotten a data group',...
                {' '},'or entered the same label twice (or simply put in one too many labels).')));
        end

        
        
%centering x-ticks to each bar group
        ax = gca;
        xticks(nbgc);
        %applying labels to x-ticks
        ax.XAxis.TickLabels = labels;

        
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                        Adjusting patch vertices
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
        
%Storing patch .Vertices arrays
        v = cell(1);
        for i = 1:n
            v{i} = hBar(i).Vertices;
        end

        
        
%Creating index array for .Vertices arrays
        szv = length(v{1}); %length of .Vertices arrays
        ia = zeros(1,szv); %indexing array declaration
        for i = 1:szv
            hold on
            if floor((i-1)/5)==(i-1)/5
                ia(i) = 1; %indexing array
            else
                ia(i) = 0;
            end
        end

        
        
%Adjusting vertices with displacement variable "d"
        for j = 1:n
            for k = 1:NBG
                for i = 1:szv
                    if ia(i) ~= 1 && i > 5*k-4 && i <= 5*k 
                        v{j}(i,1) =  v{j}(i,1) - d(k,j);
                        hBar(j).Vertices = v{j};
                    end                    
                    v2{k,j} = v{j}(5*k-3:5*k,:);
                end 
            end
        end

        
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%                  Individualizing bars in patch vertices
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%

%clear hBar data, but leave plot axes
        delete(hBar)

%Setting parula (default color map) matrix
        clrs = parula(n);

%Making individual patches for each bar
        for j = 1:n
            for k = 1:NBG
        hBar(k,j) = patch(v2{k,j}(:,1),v2{k,j}(:,2),clrs(j,:));
        hold on
            end
        end
        
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%               Adding Error Bars (RMM an extreme novice)
%~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~%
%bar centers are nbc

end