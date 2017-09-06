%% Detecting Round Objects Matlab example adapted for our use
function numberofeggs = analysefeatures(img_path)
%% Setting paramaters and initialising count
numberofeggs=0;
lowereccentricity=0.75;
uppereccentricity=0.95;
lowermetric=0.8;
uppermetric=0.95;
lowerintensity=80;
upperintensity=115;

% 
%% Read image and segment 

%%%% Read Image
RGB = imread(img_path);
% imshow(RGB);
[bw, ~]=segmentImage1mm(RGB);
%% Find the Boundaries
[B1,L1] = bwboundaries(bw,'noholes');

% Display the label matrix and draw each boundary
imshow(label2rgb(L1, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B1)
    boundary = B1{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
%% Determine the properties of all objects
stats = regionprops(L1,'Area','Centroid', 'Perimeter', 'Eccentricity');


for k = 1:length(B1)
    
    %   
    
    
%        RGB1=RGB(:,:,1); RGB1(L1~=k)=0;R=mean(RGB1(RGB1~=0));
%        RGB2=RGB(:,:,2);RGB2(L1~=k)=0; G=mean(RGB2(RGB2~=0));
%        RGB3=RGB(:,:,3); RGB3(L1~=k)=0;B=mean(RGB3(RGB3~=0));
%        colour=[R G B];
%        AverageEgg= [ 104.6773  103.0000   49.6668];
    
    %    YCbCr=rgb2ycbcr(RGB);
    %     YCbCr1=YCbCr(:,:,1);YCbCr1(L1~=k)=0; Y=mean(YCbCr1(YCbCr1~=0));
    %     YCbCr2=YCbCr(:,:,2);YCbCr2(L1~=k)=0; Cb=mean(YCbCr2(YCbCr2~=0));
    %     YCbCr3=YCbCr(:,:,3);YCbCr3(L1~=k)=0; Cr=mean(YCbCr3(YCbCr3~=0));
    %     colour=[Y Cb Cr];
    %     AverageEgg=[78,101,136];
%     %
%         HSV=rgb2hsv(RGB);
%         HSV1=HSV(:,:,1).*256;HSV1(L1~=k)=0; H=mean(HSV1(HSV1~=0));
%         HSV2=HSV(:,:,2).*256;HSV2(L1~=k)=0; S=mean(HSV2(HSV2~=0));
%         HSV3=HSV(:,:,3).*256; HSV3(L1~=k)=0; V=mean(HSV3(HSV3~=0));
%         colour=[H  V];
%         AverageEgg=[43, 127];
%     %
    %
%     colourmetric=norm(colour - AverageEgg, 2);
    
    bwtest=rgb2gray(RGB);
    bwtest(L1~=k)=0;
    intensity=mean(bwtest(bwtest~=0));
    
    
    %    Using regionstats
    
    area=stats(k).Area;
    perimeter=stats(k).Perimeter;
    metric = 4*pi*area/perimeter^2;
    
    % display the results
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
    
    if stats(k).Eccentricity >= lowereccentricity
        if stats(k).Eccentricity <= uppereccentricity
            if metric>=lowermetric
                if metric< uppermetric
                    if intensity >=lowerintensity
                        if intensity<= upperintensity
%                             if colourmetric<32
                                if (1000< area)&& (area <1900)
                                    
                                    numberofeggs=numberofeggs+1;
                                end
% %                             end
                        end
                    end
                end
            end
        end
    end
    
end



end

