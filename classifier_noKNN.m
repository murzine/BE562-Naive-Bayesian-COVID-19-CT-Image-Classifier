function [sensitivity, specificity] = classifier(COVIDfeats,NONCOVIDfeats,testset)
COVstd = std(COVIDfeats);
NonCOVstd = std(NONCOVIDfeats);
meanstd = mean([COVstd;NonCOVstd]);
pcov = zeros(size(testset.data,1),length(meanstd));
pnoncov = zeros(size(testset.data,1),length(meanstd));
for i = 1:length(meanstd)
    for j = 1:size(testset.data,1)
        countyCov = 0;
        countyNonCov = 0;
        for k = 1:size(COVIDfeats,1)
            if abs(testset.data(j,i)-COVIDfeats(k,i)) <= (meanstd(i)*2.7)%1.4 for all nimages
                countyCov = countyCov + 1;
            end
        end
        for m = 1:size(NONCOVIDfeats,1)
            if abs(testset.data(j,i)-NONCOVIDfeats(m,i)) <= (meanstd(i)*2.7)%1.4 scaling for all images
                countyNonCov = countyNonCov + 1;
            end
        end
        pcov(j,i) = countyCov/size(COVIDfeats,1);
        pnoncov(j,i) = countyNonCov/size(NONCOVIDfeats,1);
    end
end
pcov = pcov + 0.005;
pnoncov = pnoncov + 0.005;

TP = 0;
TN = 0;
FN = 0;
FP = 0;

for n = 1:size(testset.data,1)
    ratio = log(prod(pcov(n,:))/prod(pnoncov(n,:)));
    if ratio > 0
        label = 'COVID';
    end
    if ratio < 0
        label = 'NonCOVID';
    end
    if isequal(label,'COVID') && isequal(convertStringsToChars(testset.labels(n)),'COVID')
        TP = TP+1;
    end
    if isequal(label,'NonCOVID') && isequal(convertStringsToChars(testset.labels(n)),'NonCOVID')
        TN = TN+1;
    end
    if isequal(label,'COVID') && isequal(convertStringsToChars(testset.labels(n)),'NonCOVID')
        FP = FP+1;
    end
    if isequal(label,'NonCOVID') && isequal(convertStringsToChars(testset.labels(n)),'COVID')
        FN = FN+1;
    end
end

sensitivity = TP/(TP+FN);
specificity = TN/(TN+FP);


figure(1)
[X,Y,T,AUC,O] = perfcurve(testset.labels,prod(pcov,2),'COVID');
plot(X,Y,'LineWidth',2)
hold on
xlabel('1-Specificity')
ylabel('Sensitivity')
%legend = cell(1,2);
%legend{2} = sprintf('Standard features (AUC = %.3f)',AUC);
title('Classifier with 4 features')

disp(AUC)

fprintf('There are %d TP \n',TP)
fprintf('There are %d TN \n',TN)
fprintf('There are %d FP \n',FP)
fprintf('There are %d FN \n',FN)
acc = (TP+TN)/(TP+TN+FN+FP);
disp(acc)
disp(O)

end