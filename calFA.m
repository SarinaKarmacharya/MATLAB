clear
addpath /rfanfs/pnl-zorro/software/
cd /rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/
    dirName=dir('runs');
    nameofDir=dirName([dirName.isdir]);
    subdir = nameofDir(3:end);
    n=length(subdir);
    header={'FA'};
    FAValues=zeros(n,1);
    originalDir=pwd
        tmp =([84 84 26])
    for i = 1:length(subdir);
        originaldir=pwd
        thisDir = subdir(i);
        thisDirName =thisDir.name;
        subDirName = sprintf(thisDirName);
        cd runs; cd (subDirName);
        im= nrrdLoad([(subDirName),'_average_all_heat_map_FOOT100-edr_NK.nrrd']);
        fa = nrrdLoad([(subDirName),'_FA.nrrd']);
        %tmp=im.*fa;
        %tmp(tmp==0)=nan;
        %FAValues(i,1)=nanmean(tmp(:));
       
        id =find(im ==1);
        FAValues(i,1)=mean(fa(id));
        cd (originalDir);
    end
    % to save the data with header
     ds=dataset({FAValues, header{:}});
    % to save in excel format
     export(ds, 'file', 'FA_100_with_Pnl_eddy_cleaned.csv');
     %in data set way
    %k=[header;num2cell(FAValues)];
    %dlmwrite('FAValues.csv', h, '\t');