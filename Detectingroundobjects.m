%% Detecting Round Objects Matlab example adapted to find eggs
% % % % %
%% Read Image
RGB = imread('C:\Users\Margaret\Documents\University\Summer Project 2017\Equine faecal  egg count images\Images sorted for machine learning\all images\1mm\scaled_0.25\number of eggs\1 egg\IMG_2056.JPG');
imshow(RGB);
numberofeggs=0;
% %%  Looking for eggs via texture filtering
% S = stdfilt(RGB);
% I=mat2gray(S);
% imshow(I);
%
% %% Convert the image to black and white in order to prepare for boundary tracing using bwboundaries.
% I = rgb2gray(I);
% imshow(I)
% %% Adjust contrast
% I=imadjust(I);
% I=imcomplement(I);
% imshow(I)
%
% %% Binarize image and take the complement
% bw = imbinarize(I, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity',0.4);
% bw=imcomplement(bw);
% imshow(bw)
% %% remove all small objects
% %200 for 1mm images
% bw = bwareaopen(bw,100);
% imshow(bw)
% %%
% se = strel('disk',3);
% bw = imclose(bw,se);
% imshow(bw)
% %% Fill holes
% % fill any holes, so that regionprops can be used to estimate the area enclosed by each of the boundaries
% bw = imfill(bw,'holes');
% imshow(bw)
% %% open up gaps
% %10 for 1mm images
% se = strel('disk',10);
% bw = imopen(bw,se);
%
% imshow(bw)
% %% Find the Boundaries
% [B,L] = bwboundaries(bw,'noholes');
% %
% % % Display the label matrix and draw each boundary
% % imshow(label2rgb(L, @jet, [.5 .5 .5]))
% % hold on
% % for k = 1:length(B)
% %     boundary = B{k};
% %     plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% % end
% %% %% Plot on the original image
% [B,L] = bwboundaries(bw,'noholes');
%
% % Display the label matrix and draw each boundary
% imshow(RGB)
% hold on
% for k = 1:length(B)
%     boundary = B{k};
%     plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
% end
%
% %% Determine the properties of all objects
% % Use region proprops to find some important prperties
% stats = regionprops(L,'Area','Centroid', 'Perimeter', 'Eccentricity');
%
% % Start a count for the number of eggs predicted in an image
%
% eggstore=[];
% % loop over each object
% for k = 1:length(B)
%     boundary = B{k};
%
%     %     Manually finding the intensity for each object
%     sumpixels=0;
%     sumintensity=0;
%     S=size(L);
%     bwtest=rgb2gray(RGB);
%     for i=1:S(1)
%         for j=1:S(2)
%             if L(i,j)~=k;
%                 bwtest(i,j)=0;
%             else
%                 sumpixels=sumpixels+1;
%                 sumintensity=sumintensity+double(bwtest(i,j));
%             end
%         end
%     end
%     intensity=sumintensity/sumpixels;
%
%     %    Extracting info from regionstats
%
%     area=stats(k).Area;
%     perimeter=stats(k).Perimeter;
%     metric = 4*pi*area/perimeter^2; % A measure of roundness
%
%     % decide if the ojecct is an egg
%     color1='green'; %eccentricity
%     color2='red'; % metric
%     color3='blue'; %intensity
%     if stats(k).Eccentricity >= lowereccentricity
%         if stats(k).Eccentricity <= uppereccentricity
%             if metric >= lowermetric
%                 if metric <= uppermetric
%                     if intensity >= lowerintensity
%                         if intensity <= upperintensity
%                             color1='y'; %change colour if it is an egg
%                             color2='magenta';
%                             color3='cyan';
%                            eggstore=[eggstore k];
%                            numberogeggs=numberofeggs+1;
%                         end
%                     end
%                 end
%             end
%         end
%     end
%     eccentricity_string = sprintf('%2.2f',stats(k).Eccentricity);
%     metric_string = sprintf('%2.2f',metric);
%     intensity_string=sprintf('%2.2f',intensity);
%     text(boundary(1,2)-20,boundary(1,1)+6,eccentricity_string,'Color',color1,...
%         'FontSize',14,'FontWeight','bold');
%     text(boundary(1,2)+20,boundary(1,1)-6,metric_string,'Color',color2,...
%         'FontSize',14,'FontWeight','bold');
%     text(boundary(1,2)+20,boundary(1,1)-12,intensity_string,'Color',color3,...
%         'FontSize',14,'FontWeight','bold');
%
% end
%%

% % % % Looking for eggs via contrast only
%%


%%Two alternatives
%
% I2=imadjust(RGB,[.4 .5 0; .6 .6 1],[]);
% I = rgb2gray(I2);
% bw = imbinarize(I);
% bw=imcomplement(bw);
% imshow(bw)
% %%Convert the image to black and white in order to prepare for boundary tracing using bwboundaries.
[bw, mask]=segmentImage1mm(RGB);
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

eggstore1=[];
% loop over the boundaries
for k = 1:length(B1)
    
    HSV=rgb2hsv(RGB);
    HSV1=HSV(:,:,1).*256;HSV1(L1~=k)=0; H=mean(HSV1(HSV1~=0));
    HSV2=HSV(:,:,2).*256;HSV2(L1~=k)=0; S=mean(HSV2(HSV2~=0));
    HSV3=HSV(:,:,3).*256; HSV3(L1~=k)=0; V=mean(HSV3(HSV3~=0));
    colour=[H  V]
    AverageEgg=[43, 127];
    
    %    RGB1=RGB(:,:,1); RGB1(L1~=k)=0;R=mean(RGB1(RGB1~=0));
    %    RGB2=RGB(:,:,2);RGB2(L1~=k)=0; G=mean(RGB2(RGB2~=0));
    %    RGB3=RGB(:,:,3); RGB3(L1~=k)=0;B=mean(RGB3(RGB3~=0));
    %    colour=[R G B]
    %    AverageEgg= [ 104.6773  103.0000   49.6668];
    
    
    
    colourmetric=norm(colour - AverageEgg);
    
    
    % Finidng intesnisty using the mean
    bwtest=rgb2gray(RGB);
    bwtest(L1~=k)=0;
    intensity=mean(bwtest(bwtest~=0));
    
    %
    
    %    Using regionstats
    boundary = B1{k};
    
    area=stats(k).Area;
    perimeter=stats(k).Perimeter;
    metric = 4*pi*area/perimeter^2;
    
    % display the results
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
    color1='green';
    color2='red';
    color3='blue';
    if stats(k).Eccentricity >= lowereccentricity
        if stats(k).Eccentricity <= uppereccentricity
            if metric>=lowermetric
                if metric< uppermetric
                    if intensity >=lowerintensity
                        if intensity<= upperintensity
%                             if colourmetric<25
                                color1='y';
                                color2='magenta';
                                color3='cyan';
                                eggstore1=[eggstore1 k];
                                %                             numberogeggs=numberofeggs+1;
                                %                             end
%                             end
                        end
                    end
                end
            end
        end
    end
    
    eccentricity_string = sprintf('%2.2f',stats(k).Eccentricity);
    metric_string = sprintf('%2.2f',metric);
    intensity_string=sprintf('%2.2f',intensity);
    
    text(boundary(1,2)-35,boundary(1,1)+13,eccentricity_string,'Color',color1,...
        'FontSize',14,'FontWeight','bold');
    text(boundary(1,2)+35,boundary(1,1)-13,metric_string,'Color',color2,...
        'FontSize',14,'FontWeight','bold');
    text(boundary(1,2)+70,boundary(1,1)-39,intensity_string,'Color',color3,...
        'FontSize',14,'FontWeight','bold');
end
%%


% %%
%
%
% for a=eggstore
%     for b=eggstore1
%
%         S=size(L);
%         stop=0;
%         for i=1:S(1)
%             for j=1:S(2)
%                 if stop==0
%                     if L(i,j)==a
%
%                         if L1(i,j)==b
%
%                             numberofeggs=numberofeggs-1;
%                             stop=1;
%                         end
%                     end
%                 end
%             end
%
%         end
%     end
% end
%
%
%
%
% numberofeggs
%
%
