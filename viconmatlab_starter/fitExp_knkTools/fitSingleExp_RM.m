function [fitParamS,linearCIsS,aicS] = fitSingleExp_RMM(dataSeries,ifplot) %,subi)
%fitExpModels Fit exponential models and present results for diagnostics
%
%   Inputs:
%   a. dataSeries: Step length symmetry data as a vector.
%
%
%   Copyright (c) <2018> <Usman Rashid>
%   Licensed under the MIT License. See LICENSE in the project root for
%   license information.
global asym

try
    [ fittedS, residsS, fitParamS, linearCIsS, aicS] = fitSingleExpPSO(dataSeries);
catch
   fittedS = []; residsS = []; fitParamS = []; linearCIsS = []; aicS = [];
   ifplot = 0; ifprint = 0;
end

subi = 1;

% %% Plot results
if ifplot == 1
    % Single exponential
    subplot(1, 4, subi)
    plot(1:length(dataSeries), dataSeries, 'k.');
    hold
    plot(1:length(fittedS), fittedS, 'r-', 'LineWidth', 1.5);
    title(['Single exp. model; AIC: ' num2str(aicS)])
    box off;
    ylabel('Symmetry')
    ax = axis;
    axis([1 length(dataSeries) ax(3) ax(4)]);
    xticklabels([])
    
    subplot(1, 4, subi + 1)
    plot(1:length(dataSeries), residsS, 'k.');
    title('Residuals-vs-strides')
    box off;
    ax = axis;
    axis([1 length(dataSeries) ax(3) ax(4)]);
    xticklabels([])
    text(length(dataSeries)/2,-0.4,{'AIC: ',num2str(aicS)});

    subplot(1, 4, subi +2)
    histogram(residsS, 10, 'FaceColor', [1 1 1], 'LineWidth', 1.5);
    title('Residuals histogram')
    box off;
    ylabel('Frequency')

    subplot(1, 4, subi+3)
    qh = qqplot(residsS);
    qh(1).MarkerEdgeColor = [0 0 0];
    title('Residuals QQ-plot')
    ylabel('Quantiles of residuals')
    xlabel('')

% %     % Double exponential
% %     subplot(2, 4, 5)
% %     plot(1:length(dataSeries), dataSeries, 'k.');
% %     hold
% %     plot(1:length(fittedD), fittedD, 'r-', 'LineWidth', 1.5);
% %     title(['Double exp. model; AIC: ' num2str(aicD)])
% %     box off;
% %     ylabel('Symmetry')
% %     ax = axis;
% %     axis([1 length(dataSeries) ax(3) ax(4)]);
% %     xlabel('Stride No.')
% %     text(length(dataSeries)/2,-0.4,{'AIC: ',num2str(aicD)});
% % 
% %     subplot(2, 4, 6)
% %     plot(1:length(dataSeries), residsD, 'k.');
% %     box off;
% %     ax = axis;
% %     axis([1 length(dataSeries) ax(3) ax(4)]);
% %     xlabel('Stride No.')
% % 
% %     subplot(2, 4, 7)
% %     histogram(residsD, 10, 'FaceColor', [1 1 1], 'LineWidth', 1.5);
% %     box off;
% %     xlabel('Symmetry');
% %     ylabel('Frequency');
% % 
% %     subplot(2, 4, 8)
% %     qh = qqplot(residsD);
% %     title('');
% %     ylabel('Quantiles of residuals');
% %     xlabel('Standard normal quantiles');
% %     qh(1).MarkerEdgeColor = [0 0 0];
end
% %% Print diagnostic information
% if ifprint
% %     fprintf('Estimates for the single exponential model:\n');
% %     fprintf('Name\t\tEstimate\t95pc linearised CIs\n');
% %     fprintf('a\t\t%.4f\t\t%.4f, %.4f\n', fitParamS(1), linearCIsS(1, 1), linearCIsS(1, 2));
% %     fprintf('b\t\t%.4f\t\t%.4f, %.4f\n', fitParamS(2), linearCIsS(2, 1), linearCIsS(2, 2));
% %     fprintf('c\t\t%.4f\t\t%.4f, %.4f\n', fitParamS(3), linearCIsS(3, 1), linearCIsS(3, 2));
%     % asym.singleExp.a(subj,effcond,blk) = fitParamS(1);
%     % asym.singleExp.aCI(subj,effcond,blk,:) = linearCIsS(1,:);
%     % asym.singleExp.b(subj,effcond,blk) = fitParamS(2);
%     % asym.singleExp.bCI(subj,effcond,blk,:) = linearCIsS(2,:);
%     % asym.singleExp.c(subj,effcond,blk) = fitParamS(3);
%     % asym.singleExp.cCI(subj,effcond,blk,:) = linearCIsS(3,:);
% %     fprintf('\nEstimates for the double exponential model:\n');
% %     fprintf('Name\t\tEstimate\t95pc linearised CIs\n');
% %     fprintf('a_s\t\t%.4f\t\t%.4f, %.4f\n', fitParamD(1), linearCIsD(1, 1), linearCIsD(1, 2));
% %     fprintf('b_s\t\t%.4f\t\t%.4f, %.4f\n', fitParamD(2), linearCIsD(2, 1), linearCIsD(2, 2));
% %     fprintf('a_f\t\t%.4f\t\t%.4f, %.4f\n', fitParamD(3), linearCIsD(3, 1), linearCIsD(3, 2));
% %     fprintf('b_f\t\t%.4f\t\t%.4f, %.4f\n', fitParamD(4), linearCIsD(4, 1), linearCIsD(4, 2));
% %     fprintf('c\t\t%.4f\t\t%.4f, %.4f\n', fitParamD(5), linearCIsD(5, 1), linearCIsD(5, 2));
%     % asym.doubleExp.as(subj,effcond,blk) = fitParamD(1);
%     % asym.doubleExp.asCI(subj,effcond,blk,:) = linearCIsD(1,:);
%     % asym.doubleExp.bs(subj,effcond,blk) = fitParamD(2);
%     % asym.doubleExp.bsCI(subj,effcond,blk,:) = linearCIsD(2,:);
%     % asym.doubleExp.af(subj,effcond,blk) = fitParamD(3);
%     % asym.doubleExp.afCI(subj,effcond,blk,:) = linearCIsD(3,:);
%     % asym.doubleExp.bf(subj,effcond,blk) = fitParamD(4);
%     % asym.doubleExp.bfCI(subj,effcond,blk,:) = linearCIsD(4,:);
%     % asym.doubleExp.c(subj,effcond,blk) = fitParamD(5);
%     % asym.doubleExp.cCI(subj,effcond,blk,:) = linearCIsD(5,:);
% %     fprintf('\n\nInformation Criteria:\n');
% %     fprintf('AIC for the single exponential model: %.3f\n', aicS);
% %     % asym.singleExp.AIC(subj,effcond,blk) = aicS;
% %     fprintf('AIC for the double exponential model: %.3f\n', aicD);
%     % asym.doubleExp.AIC(subj,effcond,blk) = aicD;
% end
end
