%% Detecting Round Objects Matlab example adapted for our use
function numberofeggs = cropandanalyse(img_path)
bagoffeaturescroppedimages=load('bagoffeaturescroppedimages3.mat');
bag=bagoffeaturescroppedimages.bag;
%% Setting paramaters and initialising count
numberofeggs=0;


% 
%% Read image and segment 

%%%% Read Image
RGB = imread(img_path);
% imshow(RGB);
[bw, ~]=segmentImage1mm(RGB);
%% Find the Boundaries
[B,L] = bwboundaries(bw,'noholes');


%% Determine the properties of all objects

stats = regionprops(L,'Area','BoundingBox', 'Orientation');


filter=zeros(length(B),1);
% loop over the boundaries
for k = 1:length(B)
    
    
     area=stats(k).Area;
    if area<2500
        if area>600
            filter(k)=1;
        end
    end
end

filter=logical(filter);

for s=1:length(B)
    if filter(s)
        rect=stats(s).BoundingBox;
        angle=stats(s).Orientation;
        I2=imcrop(RGB,rect);
        I2=imrotate(I2, -angle);
        eggsData = double(encode(bag, I2));
        [Y,~,~]=myNeuralNetworkFunction3(eggsData);
        %If you want number of eggs
        Y=round(Y);
        if Y==[1 0]
            numberofeggs=numberofeggs+1;
        end
% If you want a more probabilistic answer on numbers of eggs: 
%             numberofeggs=numberofeggs+Y(1);
    end
end


end
