function plot_forceplate_output(forcedata,frameidx)
figure(); hold on;
stime = frameidx / 1000;
flabels = {'Fx' 'Fy' 'Fz'};
for i = 1:3
    subplot(3,1,i); hold on;
    plot(stime,forcedata(:,0+i),'b')
    plot(stime,forcedata(:,9+i),'r')
    ylabel(flabels(i))
end
figure(); hold on;
flabels = {'Mx' 'My' 'Mz'};
for i = 1:3
    subplot(3,1,i); hold on;
    plot(stime,forcedata(:,3+i),'b')
    plot(stime,forcedata(:,12+i),'r')
    ylabel(flabels(i))
end
figure(); hold on;
flabels = {'Cx' 'Cy' 'Cz'};
for i = 1:3
    subplot(3,1,i); hold on;
    plot(stime,forcedata(:,6+i),'b')
    plot(stime,forcedata(:,15+i),'r')
    ylabel(flabels(i))
end
end