files=dir('*.nhdr');

N=length(files);

for i= 1:N
    initialName=fullfile(files(i).name);
    nrrdFile=fullfile(strrep(files(i).name,'nhdr','nrrd'));
    system(['unu save -f nrrd -i ' initialName ' -o '  ' '  nrrdFile]);
end

NewName=textread('New_Name_Revised.txt', '%s');
oldName=textread('Old_Name_Revised.txt', '%s');

files=dir('*.nrrd');


orignaldir=pwd;
for i =1:numel(oldName)
    cd DWI/
    if (exist([oldName{i} '.nrrd']))
        system(['mv ' oldName{i} '.nrrd' ' ' NewName{i} '.nrrd']); 
        
    else
        disp(['There is no file to change Name']);
    end
    cd (orignaldir);
end
