% TMfigure_predictionPlotNoData
steps = 0:800;
A = 0.7;
r1 = 0.01; r1s = 0.018;
r2 = 0.02; r2s = 0.025;
asym_L1 = A * exp(- r1 * steps);
asym_L2 = A * exp(- r2 * steps);

asym_L1s = A * exp(- r1s * steps);
asym_L2s = A * exp(- r2s * steps);
%%
figure();
subplot(221); hold on;
plot(steps,asym_L1,'k','LineWidth',2);
plot(steps,asym_L2,'b','LineWidth',2);
title('Learning for effort condition A and B')
legend('A: learning','B: learning')
ylabel({'asymmetry'; 'compare A to B'})
text(175,0.45,'Faster learning in B')
ylim([0 0.8])

subplot(222); hold on;
plot(steps,asym_L1s,'k:','LineWidth',3);
plot(steps,asym_L2s,'b:','LineWidth',3);
title('Savings for effort condition A and B')
legend('A: savings','B: saving')
text(175,0.45,'Faster relearning in B')
ylim([0 0.8])

subplot(223); hold on;
plot(steps,asym_L1,'k','LineWidth',2);
plot(steps,asym_L1s,'k:','LineWidth',3);
title('Learning and savings in A')
xlabel('steps')
ylabel({'asymmetry'; 'compare within condition'})
text(175,0.5,{'A : Large savings'; 'much faster relearning'})
ylim([0 0.8])

subplot(224); hold on;
plot(steps,asym_L2,'b','LineWidth',2);
plot(steps,asym_L2s,'b:','LineWidth',3);
title('Learning and savings in B')
xlabel('steps')
text(175,0.5,{'B : Small savings'; 'slightly faster relearning'})

ylim([0 0.8])