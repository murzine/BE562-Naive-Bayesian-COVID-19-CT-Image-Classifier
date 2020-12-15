function features = feature_extraction(directory,class)
    images = dir(directory);
    nimages = length(images); 
    number_of_bits = 8;
    image = cell(1,nimages);
    features = cell(1,nimages);
    %image = cell(1,250);
    %features = cell(1,250);
    glcm = cell(1,4);
    for i = 1:nimages
        %%This reads all the images into a cell array
        currentfilename = strcat('preprocessed_images/',class,'/',images(i).name);
        currentimage = imread(currentfilename);
        L = single(currentimage);
        image{i} = abs(L - (2^number_of_bits -1));
        [r,c] = size(image{i});
        P0 = zeros(256,256);
        P45 = zeros(256,256);
        P90 = zeros(256,256);
        P135 = zeros(256,256);

    %this was tested on a matric for which GLCMs were known and the calculated 
    %P0,P45,P90,P135 glcm matched. This matrix was presented in the 
    %original Haralick features paper (Haralick et al. 1973).
        for k = 1:c
            for j = 1:r
            %find P0
                    actualnumP0 = image{i}(j,k);

                if (k ~= 1) && (k ~= c)
                    rightsideP0 = image{i}(j,k+1);
                    leftsideP0 = image{i}(j,k-1);
                    P0(actualnumP0+1,rightsideP0+1) = P0(actualnumP0+1,rightsideP0+1)+1;
                    P0(actualnumP0+1,leftsideP0+1) = P0(actualnumP0+1,leftsideP0+1)+1;
                end
                if k == 1
                    rightsideP0 = image{i}(j,k+1);
                    P0(actualnumP0+1,rightsideP0+1) = P0(actualnumP0+1,rightsideP0+1)+1;
                end
                if k == c
                    leftsideP0 = image{i}(j,k-1);
                    P0(actualnumP0+1,leftsideP0+1) = P0(actualnumP0+1,leftsideP0+1)+1;
                end
            %find P90
                    actualnumP90 = image{i}(j,k);
                if (j ~= 1) && (j ~= r)
                    belowP90 = image{i}(j+1,k);
                    aboveP90 = image{i}(j-1,k);
                    P90(actualnumP90+1,belowP90+1) = P90(actualnumP90+1,belowP90+1)+1;
                    P90(actualnumP90+1,aboveP90+1) = P90(actualnumP90+1,aboveP90+1)+1;
                end
                if j == 1
                    belowP90 = image{i}(j+1,k);
                    P90(actualnumP90+1,belowP90+1) = P90(actualnumP90+1,belowP90+1)+1;
                end
                if j == r
                    aboveP90 = image{i}(j-1,k);
                    P90(actualnumP90+1,aboveP90+1) = P90(actualnumP90+1,aboveP90+1)+1;
                end
            %find P45
                if (k < c) && (j > 1)
                    actualnumP45 = image{i}(j,k);
                    diagupP45 = image{i}(j-1,k+1);
                    P45(actualnumP45+1,diagupP45+1) = P45(actualnumP45+1,diagupP45+1)+1;
                end
                if (j < r) && (k > 1)
                    actualnumP45 = image{i}(j,k);
                    diagdownP45 = image{i}(j+1,k-1);
                    P45(actualnumP45+1,diagdownP45+1) = P45(actualnumP45+1,diagdownP45+1)+1;
                end
            %find P135
                if (k > 1) && (j > 1)
                    actualnumP135 = image{i}(j,k);
                    diagupP135 = image{i}(j-1,k-1);
                    P135(actualnumP135+1,diagupP135+1) = P135(actualnumP135+1,diagupP135+1)+1;
                end
                if (k < c) && (j < r)
                    actualnumP135 = image{i}(j,k);
                    diagdownP135 = image{i}(j+1,k+1);
                    P135(actualnumP135+1,diagdownP135+1) = P135(actualnumP135+1,diagdownP135+1)+1;
                end
            end
        end
        P0normalized = P0/(sum(sum(P0)));
        P90normalized = P90/(sum(sum(P90)));
        P45nomalized = P45/(sum(sum(P45)));
        P135normalized = P135/(sum(sum(P135)));
        glcm{1} = P0normalized;
        glcm{2} = P90normalized;
        glcm{3} = P45nomalized;
        glcm{4} = P135normalized;

        features{i} = haralick_features(glcm);
   
   %glcm = graycomatrix(currentimage,'offset', [0 1], 'Symmetric', true);
   %feature_vector = haralick_features(glcm);
   
    end
end