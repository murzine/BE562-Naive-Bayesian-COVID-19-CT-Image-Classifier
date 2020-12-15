function features_vector = haralick_features(glcm)
    [HaralickF1,HaralickF2,HaralickF3,HaralickF4,HaralickF5,...
        HaralickF6,HaralickF7,HaralickF8,HaralickF9,HaralickF10,...
        HaralickF11,HaralickF12,HaralickF13] = deal(zeros(1,length(glcm)));

    for count = 1:length(glcm)
        x = 1:size(glcm{count},1);
        y = 1:size(glcm{count},2);
        [meshgridx, meshgridy] = meshgrid(x,y);
        %find the marginal pdfs
        px = sum(glcm{count},2);
        py = sum(glcm{count},1);
        %calculate means for x and y

        meanx_index = 1:size(glcm{count},1);
        meanx = sum(sum((meanx_index./256)*glcm{count}));
        meany_index = 1:size(glcm{count},2);
        meany = sum(sum((meany_index./256)*(glcm{count}')));

        
        %calculate standard deviations
        stddevx = sum(sum(((meanx_index-meanx).^2)*glcm{count}));
        stddevy = sum(sum(((meany_index-meany).^2)*glcm{count}'));
        stddevx = sqrt(stddevx);
        stddevy = sqrt(stddevy);
        HaralickF4(count) = sum(sum(((meanx_index-meanx).^2)*glcm{count}));
        % calculate the px+y and px-y vectors
        Ng = size(glcm{count},1);%number of intensity levels in image, equal to the row and column dimensions of glcm matrix
        pxplusy = zeros(1,((2*Ng)-1));
        pxminusy =  zeros(1,Ng);
        %Combined entropies HXY
        HaralickF1(count) = sum(sum((glcm{count}.^2)));
        
        HaralickF2(count) = sum(sum((((meshgridy./256)-(meshgridx./256)).^2).*glcm{count}));
        HaralickF5(count) = sum(sum(glcm{count}./(1+(((meshgridy./256)-(meshgridx./256)).^2))));
        F3 = ((meshgridy./256)-meanx).*((meshgridx./256)-meany).*glcm{count};
        HaralickF3(count) = sum(sum(F3))/(stddevx*stddevy);
        

        for k1 = 1:size(glcm{count},1)
            for l1 = 1:size(glcm{count},2)
                kplus = k1+l1;
                kminus = abs(k1-l1);
                pxplusy(kplus-1) = pxplusy(kplus-1)+glcm{count}(k1,l1);
                pxminusy(kminus+1) = pxminusy(kminus+1)+glcm{count}(k1,l1);
            end
        end
        
        %feature 1 & 2
        HXY = -sum(sum(glcm{count}.*log(glcm{count}+0.005)));
        HXY1 = -sum(sum((glcm{count}.*(log((px*py)+0.005)))));
        HXY2 = -sum(sum((px*py).*(log((px*py)+0.005))));
        HaralickF3(count) = HaralickF3(count)/(stddevx*stddevy);



        %feature 6
        pxplusy_index = 1:length(pxplusy);
        HaralickF6(count) =  sum(((2*pxplusy_index)./((2*256)-1)).*pxplusy);
        HaralickF7(count) = sum(((((2*pxplusy_index)./((2*256)-1))-HaralickF6(count)).^2).*pxplusy);
        HaralickF8(count) = -sum(pxplusy.*log(pxplusy+0.005)); %We add 0.005 into the logarithm because some values of px+y and px-y are zero so the log of this is NaN
        HaralickF9(count) = -sum(sum(glcm{count}.*log(glcm{count}+0.005)));
        %feature 10
        pxminusy_index = 1:length(pxminusy);
        diffavg = sum((pxminusy_index-1).*pxminusy);
        %Combine Haralick feature 10 and feature 11 count in same loop to
        %save speed
        HaralickF10(count) = sum((((pxminusy_index./256)-diffavg).^2).*pxminusy);
        HaralickF11(count) = -sum(pxminusy.*log(pxminusy+0.005));
        %Features 12-13
        %Entropy of px
        HX = -sum(px.*log(px+0.005));
        %Entropy of py
        HY = -sum(py.*log(py+0.005));

        HaralickF12(count) = (HXY-HXY1)/max([HX HY]);
        HaralickF13(count) = sqrt(1-exp(-2*(HXY2-HXY)));
    end
    Haralick_matrix = [HaralickF1' HaralickF2' HaralickF3' HaralickF4'...
        HaralickF5' HaralickF6' HaralickF7' HaralickF8' HaralickF9'...
        HaralickF10' HaralickF11' HaralickF12' HaralickF13'];
    Mean_features = mean(Haralick_matrix);
    %by just taking max and min you get row vector of the max and min of
    %each column
    range_features = max(Haralick_matrix)-min(Haralick_matrix);
    features_vector = [Mean_features range_features];
    
end