function [trainingCOVID,trainingnonCOVID, testingCOVID,testingnonCOVID]  = dataseparation(COVIDfeatures,nonCOVIDfeatures)
lengthCovid = length(COVIDfeatures);
lengthnonCovid = length(nonCOVIDfeatures);
trainlengthCovid = floor(0.7*lengthCovid);
trainlengthnonCovid = floor(0.7*(lengthnonCovid));
trainingCOVID = COVIDfeatures(1:trainlengthCovid);
trainingnonCOVID = nonCOVIDfeatures(1:trainlengthnonCovid);
testingCOVID = COVIDfeatures(trainlengthCovid+1:end);
testingnonCOVID = nonCOVIDfeatures(trainlengthnonCovid+1:end);
end