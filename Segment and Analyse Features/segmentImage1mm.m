function [BW,maskedImage] =segmentImage1mm(im)


%imshow(im)

%% Convert to binary image
%%Convert the image to black and white in order to prepare for boundary tracing using bwboundaries.
I = im(:,:,1);
%%imshow(I)
%% Adjust contrast and complement image

I=histeq(I);
bw = imbinarize(I, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity',0.2);
bw=imcomplement(bw);
%%imshow(bw)
%% Using morphology functions, remove pixels which do not belong to the objects of interest.
% remove all small objects
% 200 for 1mm images
bw = bwareaopen(bw,200);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw = imfill(bw,'holes');
%% Optional 

%     %% opening and filling by reconstruction (instead of next  section)- not quite as good at opening up gaps
%      se = strel('disk',15);
%     bwe = imerode(bw, se); %imshow(bwe)
% bwer = imreconstruct(bwe, bw,4);
%  %imshow(bwer)
%  bw=bwer;
%
%% morphological opening and closing


% open up gaps
% 10 for 1mm images
se = strel('disk',10);
bw = imopen(bw,se);

% % fill any holes, so that regionprops can be used to estimate
% % the area enclosed by each of the boundaries
% % bw = imfill(bw,'holes');
%%imshow(bw)

%% Implementing the watershed algorithm

[B1,L1] = bwboundaries(bw,'noholes');
stats = regionprops(L1,'Area', 'BoundingBox' );

for k=1:length(B1)
    if (stats(k).Area <3000) && (stats(k).Area >1800)
        rect=stats(k).BoundingBox;
        
        A=imcrop(bw,rect);
       % %imshow(A)
        D = bwdist(~A); % image B (above)
        D=uint8(D*(256/16));
        D=imcomplement(D);
        D = imhmin(D,20);
              % %imshow(D)

        L=watershed(D);
        
        A(L == 0) = 0;
        S=size(A);
        bw(rect(2):rect(2)+S(1)-1, rect(1):rect(1)+S(2)-1)=A;
     %   %imshow(bw)
    end
end

BW=logical(bw);
% Form masked image from input image and segmented image.
maskedImage = im;
maskedImage(~BW) = 0;
