function [selectedCOVID,selectedNONCOVID,testset] = feature_evaluation(traincovidfeatures,trainnoncovidfeatures,testcovidfeatures,testnoncovidfeatures,numFeaturesToExtract)
%[rows cols] = size(features);
codata = zeros(length(traincovidfeatures),13);
noncodata = zeros(length(trainnoncovidfeatures),13);


for i = 1:length(traincovidfeatures)
    codata(i,:) = traincovidfeatures{1,i}(1:13);
end
for j = 1:length(trainnoncovidfeatures)
    noncodata(j,:) = trainnoncovidfeatures{1,j}(1:13);
end

mincovid = min(codata);
minnoncovid = min(noncodata);

maxcovid = max(codata);
maxnoncovid = max(noncodata);

meancovid = mean(codata);
meannoncovid = mean(noncodata);

diffmin = abs(mincovid - minnoncovid);
diffmax = abs(maxcovid - maxnoncovid);
diffmean = abs(meancovid - meannoncovid)./max([meancovid;meannoncovid]);

[maxmean,order] = sort(diffmean,'descend');

testcodata = zeros(length(testcovidfeatures),13);
testnoncodata = zeros(length(testnoncovidfeatures),13);


for i = 1:length(testcovidfeatures)
    testcodata(i,:) = testcovidfeatures{1,i}(1:13);

end
for j = 1:length(testnoncovidfeatures)
    testnoncodata(j,:) = testnoncovidfeatures{1,j}(1:13);
end

selectedCOVID = zeros(length(traincovidfeatures),numFeaturesToExtract);
selectedNONCOVID = zeros(length(trainnoncovidfeatures),numFeaturesToExtract);
testCOVID = zeros(length(testcovidfeatures),numFeaturesToExtract);
testnonCOVID = zeros(length(testnoncovidfeatures),numFeaturesToExtract);

for i = 1:numFeaturesToExtract
    selectedCOVID(:,i) = codata(:,order(i));
    selectedNONCOVID(:,i) = noncodata(:,order(i));
    testCOVID(:,i) = testcodata(:,order(i));
    testnonCOVID(:,i) = testnoncodata(:,order(i));
end
testset.data = [testCOVID;testnonCOVID];
testinglabels(1:length(testcovidfeatures)) = "COVID";
testinglabels(length(testcovidfeatures)+1:(length(testcovidfeatures)+length(testnoncovidfeatures))) = "NonCOVID";
testset.labels = testinglabels;

end