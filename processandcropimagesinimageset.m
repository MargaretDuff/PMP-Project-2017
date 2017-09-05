%% Setting up directories and decide on ratio of testing test to teaching set


img_dir = 'C:\Users\Margaret\Documents\University\Summer Project 2017\Equine faecal  egg count images\Images sorted for machine learning\All';
Set = imageSet(img_dir, 'recursive');  
% [imgSet,testingSet]=partition(Set, 0.75 ,'randomized');
% disp(['Your imageSet contains ', num2str(sum([imgSet.Count])),...
% 	' images from ' num2str(numel(imgSet)) ' classes.'])
% disp(['Your testingSet contains ', num2str(sum([testingSet.Count])),...
% 	' images from ' num2str(numel(testingSet)) ' classes.'])
 imgSet = imageSet(img_dir, 'recursive'); 
%% For each image in the training set we crop out all of the objects 
for i=1:numel(imgSet)
    H=imgSet(i).ImageLocation;
    for j=1:imgSet(i).Count
        img=char(H(j));
        cropimages(img);
    end
end
%% Before this step you must split the directory into eggs and not eggs 
img_dir = 'C:\Users\Margaret\Documents\University\Summer Project 2017\Equine faecal  egg count images\Images sorted for machine learning\All\croppedimages';
imgSet = imageSet(img_dir, 'recursive');  

disp(['Your imageSet contains ', num2str(sum([imgSet.Count])),...
	' images from ' num2str(numel(imgSet)) ' classes.'])



%% %% We create a visual BAG OF FEATURES to describe the training set
% extractorFcn = customParasitologyFcn;
bag = bagOfFeatures(imgSet,'VocabularySize',1000, 'upright',false)
%% Then we encode it as histograms of features, and cast it to a table
% (This is useful for working with the classificationLearner app)
eggsData = double(encode(bag, imgSet));
eggsDataTable = array2table(eggsData);
eggsType = categorical(repelem({imgSet.Description}',...
	[imgSet.Count], 1));
eggsDataTable.eggsType = eggsType;
eggsType=dummyvar(eggsType);
