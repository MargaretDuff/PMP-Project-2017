%% testing analyse features method
all_img = 'C:\Users\Margaret\Documents\University\Summer Project 2017\Equine faecal  egg count images\Images sorted for machine learning\all images\1mm\scaled_0.25\number of eggs\**\*.JPG';
files= dir(all_img);

for k=1:numel(files)
    S=files(k).folder;
    dirname=(S(length(all_img)-7:length(S)));
    files(k).NumberOfEggs=dirname;
end
Table=struct2table(files);
Table=Table(:,[1 7]);
name={'N/a';'N/a';'N/a';'N/a';'N/a';'N/a'};
NumberOfEggs={'lowereccentricity';'uppereccentricity'; 'lowermetric'; 'uppermetric'; 'lowerintensity'; 'upperintensity'};
T2=table(name, NumberOfEggs);
Table=[Table; T2];
lowereccentricity=0.75;
uppereccentricity=0.95;
lowermetric=0.8;
uppermetric=0.95;
lowerintensity=80;
upperintensity=115;
a=0;
Results=[];

Results=[Results zeros(height(Table),1)];
a=a+1;
for k=1:height(Table)-6
    
    S=[files(k).folder '\' files(k).name];
    Results(k,a)=analysefeatures(S );
end
Results(height(Table)-5,a)=lowereccentricity;
Results(height(Table)-4,a)=uppereccentricity;
Results(height(Table)-3,a)=lowermetric;
Results(height(Table)-2,a)=uppermetric;
Results(height(Table)-1,a)=lowerintensity;
Results(height(Table),a)=upperintensity;


T=array2table(Results);
Table=[Table T]
