%% testing analyse features method
all_img_eggs = '/home/md669/Documents/Summer Project 2017/Images sorted by number of eggs/New forest horse faecal egg images 16-8-17/eggs or not/eggs/*.JPG';
files= dir(all_img_eggs)
all_img_neggs = '/home/md669/Documents/Summer Project 2017/Images sorted by number of eggs/New forest horse faecal egg images 16-8-17/eggs or not/no eggs/*.JPG';
files= [files ; dir(all_img_neggs)]
all_img_eggs = '/mhome/damtp/q/md669/Documents/Summer Project 2017/Images sorted by number of eggs/1mm/scaled_0.25/eggs or not/eggs/*.JPG';
files= [files ; dir(all_img_eggs)]
all_img_neggs = '/mhome/damtp/q/md669/Documents/Summer Project 2017/Images sorted by number of eggs/1mm/scaled_0.25/eggs or not/no eggs/*.JPG';
files= [files ; dir(all_img_neggs)]

Table=struct2table(files);
Table=Table(:,1);
Results= zeros(height(Table),1);
for k=1:height(Table)
    
display([ 'Testing image ' files(k).name ])
    Results(k,1)=scaleRotateFindCirclesFunctionOld(files(k).name);
end
T=array2table(Results);
Table=[Table T]
