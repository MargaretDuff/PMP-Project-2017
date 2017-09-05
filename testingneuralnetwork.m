%% testing neural network method
all_img = 'C:\Users\Margaret\Documents\University\Summer Project 2017\Equine faecal  egg count images\Images sorted for machine learning\all images\1mm\scaled_0.25\number of eggs\**\*.JPG';
files= dir(all_img);
for k=1:numel(files)
    S=files(k).folder;
    dirname=(S(length(all_img)-7:length(S)));
    files(k).NumberOfEggs=dirname;
end
Table=struct2table(files);
a=0;
Results=[];
Results=[Results zeros(height(Table),1)];
a=a+1;
for k=1:height(Table)
    
    S=[files(k).folder '\' files(k).name];
    Results(k,a)=cropandanalyse(S );
end


T=array2table(Results);
Table=[Table T]
