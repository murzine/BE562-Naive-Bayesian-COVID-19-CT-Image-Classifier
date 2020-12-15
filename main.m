% clear; close all;

% mkdir preprocessed_images
% rmdir preprocessed_images s
% mkdir preprocessed_images

directory_dataset = ["dataset/COVID/*.png" "dataset/non-COVID/*.png"];
directory_preprocessed  = ["preprocessed_images/COVID/*.png" "preprocessed_images/non-COVID/*.png"];
%images = dir(directory);
%nimages = length(images);
class = ["COVID" "non-COVID"];
%mkdir preprocessed_images COVID
%mkdir preprocessed_images non-COVID
addpath('preprocessed_images/COVID')
addpath('preprocessed_images/non-COVID')


tic
features = cell(1,2);
for loopnum = 1:2
    image_preprocess(convertStringsToChars(directory_dataset(loopnum)),convertStringsToChars(class(loopnum)));
    features{loopnum} = feature_extraction(convertStringsToChars(directory_preprocessed(loopnum)),convertStringsToChars(class(loopnum)));
end
[trainingCOVID,trainingnonCOVID,testingCOVID,testingnonCOVID] = dataseparation(features{1},features{2});
[COVIDfeats,NONCOVIDfeats,testset] = feature_evaluation(trainingCOVID,trainingnonCOVID,testingCOVID,testingnonCOVID,9);
[sensitivity, specificity] = classifier(COVIDfeats,NONCOVIDfeats,testset)
toc