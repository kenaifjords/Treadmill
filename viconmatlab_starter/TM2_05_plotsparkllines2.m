% organize spark line data
[spark,spcol] = sortbyEffortVisitorder_spark2(asym_all.steplength);
% make color array
for i = 1:size(spcol,1)
    for j = 1:size(spcol,2)
        clri = spcol(i,j);
        if isnan(clri)
            spark_color{i,j} = [];
        else
            clr = colors.all{clri,1};
            spark_color{i,j} = clr;
        end
    end
end
% plot sparklines
% input is a X x Y cell structure containing profiles that will be plotted
% in the same layout. in a matched layout, add an array of colors
plotsparklines(spark,spark_color)
beautifyfig
% axis off
