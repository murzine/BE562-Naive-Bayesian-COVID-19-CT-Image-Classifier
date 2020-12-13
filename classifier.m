function [sensitivity, specificity] = classifier(COVIDfeats,NONCOVIDfeats,testset)
COVstd = std(COVIDfeats);
NonCOVstd = std(NONCOVIDfeats);
meanstd = mean([COVstd;NonCOVstd]);
pcov = zeros(size(testset.data,1),length(meanstd));
pnoncov = zeros(size(testset.data,1),length(meanstd));
for i = 1:length(meanstd)
        for j = 1:size(testset.data,1)
            countyCov = 0;
            countyNonCov =0;
            for k = 1:size(COVIDfeats,1)
                if abs(testset.data(j,i)-COVIDfeats(k,i)) <= (1*meanstd(i))
                    countyCov = countyCov + 1;
                end
            end
            for m = 1:size(NONCOVIDfeats,1)
                if abs(testset.data(j,i)-NONCOVIDfeats(m,i)) <= (1*meanstd(i))
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
TPR = zeros(1,size(testset.data,1));
FPR = zeros(1,size(testset.data,1));
score = zeros(1,size(testset.data,1));

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
        score(1,n) = 1;
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
    
    FPR(1,n) = FP/(FP+TP);
    TPR(1,n) = TP/(TP+FN);
    
    
    
end

sensitivity = TP/(TP+FN);
specificity = TN/(TN+FP);
accuracy = (TP+TN)/(TP+TN+FP+FN)

% plot(FPR,TPR)
% figure;
% [tpr fpr] = perfcurve(convertStringsToChars(testset.labels),score,'COVID');
% plot(tpr,fpr)

fprintf('There are %d TP \n',TP)
fprintf('There are %d TN \n',TN)
fprintf('There are %d FP \n',FP)
fprintf('There are %d FN \n',FN)
end

% function [sensitivity,specificity] = classifier(COVIDfeats,NONCOVIDfeats,testset)
% COVstd = std(COVIDfeats);
% NonCOVstd = std(NONCOVIDfeats);
% meanstd = mean([COVstd;NonCOVstd]);
% pcov = zeros(size(testset.data,1),length(meanstd));
% pnoncov = zeros(size(testset.data,1),length(meanstd));
% indices = [];
% 
% trainingset.data = [COVIDfeats;NONCOVIDfeats];
% z(1:size(COVIDfeats,1)) = "COVID";
% b(1:size(NONCOVIDfeats,1)) = "NonCOVID";
% l = [z b];
% trainingset.labels = l;
% distnce = zeros(1,size(trainingset.data,1));
% data = cell(1,size(testset.data,1));
% labeler = cell(1,size(testset.data,1));
% 
% 
% for x = 1:size(testset.data,1)
%     for y = 1:size(trainingset.data,1)
%         distnce(y) = sqrt(sum((testset.data(x,:)-trainingset.data(y,:)).^2));
%     end
%     dist_new = sort(distnce);
%     indices = [];
%     for p = 1:22
%         m = find(distnce == dist_new(p));
%         indices = [indices m];
%     end
%     data{x} = trainingset.data(indices,:);
%     labeler{x} = trainingset.labels(indices);
% end
% 
% 
% for i = 1:length(meanstd)
%     for j = 1:size(testset.data,1)
%         countyCov = 0;
%         countyNonCov = 0;
%         for k = 1:size(data{j},1)
%             if isequal(convertStringsToChars(labeler{j}(k)),'COVID')
%                 if abs(testset.data(j,i)-data{j}(k,i)) <= (meanstd(i)/9)
%                     countyCov = countyCov + 1;
%                 end
%             end
%             if isequal(convertStringsToChars(labeler{j}(k)),'NonCOVID')
%                 if abs(testset.data(j,i)-data{j}(k,i)) <= (meanstd(i)/9)
%                     countyNonCov = countyNonCov + 1;
%                 end 
%             end
%         end
%         pcov(j,i) = countyCov/size(COVIDfeats,1);
%         pnoncov(j,i) = countyNonCov/size(NONCOVIDfeats,1);
%     end
% end
% pcov = pcov + 0.005;
% pnoncov = pnoncov + 0.005;
% 
% TP = 0;
% TN = 0;
% FN = 0;
% FP = 0;
% 
% for n = 1:size(testset.data,1)
%     ratio = log(prod(pcov(n,:))/prod(pnoncov(n,:)));
%     if ratio > 0
%         class = 'COVID';
%     end
%     if ratio < 0
%         class = 'NonCOVID';
%     end
%     if isequal(class,'COVID') && isequal(convertStringsToChars(testset.labels(n)),'COVID')
%         TP = TP+1;
%     end
%     if isequal(class,'NonCOVID') && isequal(convertStringsToChars(testset.labels(n)),'NonCOVID')
%         TN = TN+1;
%     end
%     if isequal(class,'COVID') && isequal(convertStringsToChars(testset.labels(n)),'NonCOVID')
%         FP = FP+1;
%     end
%     if isequal(class,'NonCOVID') && isequal(convertStringsToChars(testset.labels(n)),'COVID')
%         FN = FN+1;
%     end
% end
% 
% sensitivity = TP/(TP+FN);
% specificity = TN/(TN+FP);
% accuracy = (TP+TN)/(TP+TN+FP+FN)
% 
% fprintf('There are %d TP \n',TP)
% fprintf('There are %d TN \n',TN)
% fprintf('There are %d FP \n',FP)
% fprintf('There are %d FN \n',FN)
% acc = (TP+TN)/(TP+TN+FN+FP);
% disp(acc)
% 
% end
