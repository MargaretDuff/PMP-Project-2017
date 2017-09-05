function [ numberofeggs ] = scaleRotateFindCirclesFunction(img)
% % Read file

I=imread(img);
S=size(I);
if S(1)~=486
    if S(2)~=648;
        I=imresize(I, [486 648]);
    end
end
%%imshow(I)
numberofeggs=0;
% %% grayscale
% 
% edge2=rgb2ycbcr(I);
% gray=edge2(:,:,1);
% % %% adjust image
% %
% % %% adjust image
% %
% I1=imadjust(gray);
% Si=size(I);
% for i=1:Si(1);
%     for j=1:Si(2);
%         %         if I(i,j)>200
%         %             I(i,j)=255;
%         %         end
%         if I1(i,j)<50
%             I1(i,j)=230;
%         end
%     end
% end
% %%imshow(I1)
% gray=imadjust(I1);
% %%imshow(I1)
% 
% %% find edges
% % 0.2 for 1mm images
% blurry=imgaussfilt(gray,5);
% %Canny for full size 1mm images, sobel for 0.25 scaled
% edg=edge(blurry, 'sobel');
% %%imshow(edg)
%
% %% Alternative edge detection and grayscale -2
% I1=double(I)/255;
% I1=proj_tv_color(I1,10,100,0.25);%%figure; %imshow(I1)
% I1=uint8(I1*255); %%imshow(I1)
% I1=rgb2gray(I1);
% I1=imadjust(I1);
%  Si=size(I1);
% for i=1:Si(1);
%     for j=1:Si(2);
%         %         if I(i,j)>200
%         %             I(i,j)=255;
%         %         end
%         if I1(i,j)<50
%             I1(i,j)=230;
%         end
%     end
% end
% %%figure; %imshow(I1)
% gray=imadjust(I1); %%figure; %imshow(gray)
% edg=edge(gray, 'sobel',0.04);
% 
% %%figure; %imshow(edg)
%% Alternative edge detection and grayscale -3

I1=rgb2gray(I);
I1=imadjust(I1);
 Si=size(I1);
for i=1:Si(1);
    for j=1:Si(2);
        %         if I(i,j)>200
        %             I(i,j)=255;
        %         end
        if I1(i,j)<50
            I1(i,j)=230;
        end
    end
end
%figure; %imshow(I1)
I1=imadjust(I1); %figure; %imshow(I1)

I1=double(I1)/255;
I1=proj_tv_color(I1,10,100,0.25);%figure; %imshow(I1)
gray=uint8(I1*255); %imshow(gray)
edg=edge(gray, 'sobel',0.04);
edge2=edg;
%figure; %imshow(edg)
%% Remove Noise
% for 1mm images full size
%edge2=bwmorph(edg, 'bridge', 20); %%imshow(edge2)
%for 1mm images 0.25 size
%  edge2=bwmorph(edg, 'bridge', 0); %%imshow(edge2)

BW2=bwconncomp(edge2);
n=BW2.NumObjects;
numPixels=cellfun(@numel, BW2.PixelIdxList);
[~,sortIndex] = sort(numPixels,'ascend');
% for 1mm images full size
% minIndex = sortIndex(1:floor(0.98*n));
%  for 1mm images 0.25 size 0.8 ish
minIndex = sortIndex(1:floor(85*n/100));

for i=1:length(minIndex);
    edge2(BW2.PixelIdxList{minIndex(i)})=0;
end
%%imshow(edge2)

%% %Hough transform
[H,theta,rho] = hough(edge2);


%% Find peaks in the Hough Transform
P = houghpeaks(H,50,'threshold',ceil(0.15*max(H(:))));



%% Find lines in the image using the houghlines function.
lines = houghlines(edge2,theta,rho,P,'FillGap',40,'MinLength',60);
%% Remove these lines from the image

for k = 1:length(lines)
    if abs(lines(k).theta)<5
        xy = [lines(k).point1; lines(k).point2];
        edge2=insertShape(double(edge2),'Line',  [xy(1,:) xy(2,:) ], 'LineWidth',10,'Color','black', 'Opacity',1);
        edge2=im2bw(edge2);
        %%imshow(edge2)
    end
    
end

%% Find circles

for Ang=0:10:170
    %% rotate
    %display(['scanning angle ' num2str(Ang) ' degrees' ])
    Rotate=imrotate(edge2, -Ang, 'loose');
    
    %% Rescale
    S=size(Rotate);
    %     for 1mm images
    SNew=S(1)*336158/751059;
    %for 2mm images
    %     SNew=S(1)/1.8;
    new=imresize(Rotate, [SNew,S(2)]);
    %     %%imshow(new)
   %% find circles
    %For full size 1mm images
    
    %   [centres, radii]=imfindcircles(new, [60,70], 'ObjectPolarity', 'bright', 'Sensitivity', 0.98)
    %     For 0.25 1mm images
    [centres, radii, ~]=imfindcircles(new, [11,33], 'ObjectPolarity', 'bright', 'Sensitivity', 0.85,'EdgeThreshold', 0);
    %    For 2mm images full size
    %   [centres, radii]=imfindcircles(new, [20,35], 'ObjectPolarity', 'bright', 'Sensitivity', 0.92)

    if ~isempty(radii)
      
        BW=double(new);
        I(1:10,1:10,1)=zeros(10);
        I(1:10,1:10,2)=zeros(10);
        I(1:10,1:10,3)=zeros(10)+255;
        I2=imrotate(I,-Ang, 'loose' );
        I3=imresize(I2, [SNew,S(2)]);
        I3gray=rgb2gray(I3);
        I4=I3;
        for k=1:length(radii)
            
            intensity1=min(min(I3gray(max(1,floor(centres(k,2))-6):min(floor(centres(k,2))+6,SNew),max(1,floor(centres(k,1))-6):min(floor(centres(k,1))+6,S(2)))));
            intensity2=mean(mean(I3gray(max(1,floor(centres(k,2))-3):min(floor(centres(k,2))+3,SNew),max(1,floor(centres(k,1))-3):min(floor(centres(k,1))+3,S(2)))));
           
            if intensity1>50 && intensity1<95
                if intensity2>70 && intensity2<95
                if abs(radii(k)-14.5)<5
                    foundbefore=0;
                    
                    for u=-16:16
                        for v=-16:16
                            if mean(I4(max(min(floor(centres(k,2))+u,floor(SNew)),1),max(min(floor(centres(k,1))+v,S(2)),1),:))>230
                                foundbefore=1;
                            end
                        end
                    end
                    
                    if foundbefore==0
                        numberofeggs=numberofeggs+1;
                    end
                    
                    BW=insertShape(BW, 'circle',[centres(k,:)  radii(k)], 'Color','white', 'LineWidth', 3);
                    
                    I4=insertShape(I4, 'circle',[centres(k,:)  radii(k)], 'Color','white', 'LineWidth', 3);
                    
                 
                end
                end
            end
            
            
            I5=imresize(I4, [S(1) S(2)]);
            I6=imrotate(I5, Ang);
            stop=0;
            
            for i=1:Si(1)
                for j=1:Si(2)
                    if stop==0
                        if (I6(i,j,1)==0) && (I6(i,j,2)==0) && (I6(i,j,3)==255)
                            i1=i;j1=j;
                            stop=1;
                        end
                    end
                end
            end
            I=imcrop(I6, [j1,i1,Si(2),Si(1)]);
            
            
        end
    end
    %To plot if you wish 
    
    
%     if output==1
%         %figure(Ang+2);
%         subplot(1,2,1);
%         %%imshow(I);
%         subplot(1,2,2);
%         %%imshow(BW);
%     end
    %     %figure(1)
end
   
    
end

