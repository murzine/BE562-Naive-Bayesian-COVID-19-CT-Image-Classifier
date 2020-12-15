function image_preprocess(directory,class)

% Preprocess original images with weiner filter and convert to grayscale

images = dir(directory);
nimages = length(images);
outputFolder = strcat('preprocessed_images','/',class,'/');

for i = 1:nimages
   currentfilename = strcat('dataset/',class,'/',images(i).name);
   currentimage = imread(currentfilename);
   
   gray_image = rgb2gray(currentimage);
   gray_image = imadjust(gray_image);
   images_preprocessed = wiener2(gray_image,[3 3]);
   
   newFileName = images(i).name;
   fullFileName = fullfile(outputFolder,newFileName);
   imwrite(images_preprocessed,fullFileName)
end

end
