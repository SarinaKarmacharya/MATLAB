
addpath /rfanfs/pnl-zorro/home/sarina/MATLAB_scripts/
caselist='/rfanfs/pnl-zorro/Collaborators/Silveri/SilveriData/scripts/casenumbers.txt'
casel=textread(caselist);

cd /rfanfs/pnl-zorro/Collaborators/Silveri/SilveriData/SILVK_T1_processed_wmparc_stat/silvk_t1_processed_wmparc_stat/

dirResult=dir('silvk_t1_processed_wmparc_stat');

allDirs =dirResult([dirResult.isdir]);
allSubDir=allDirs(3:end);
N=numel(allSubDir);

finalData=zeros(31,1)

for i=1:length(allSubDir)
    originaldir=pwd;
    thisDir=allSubDir(i);
    thisDirName=thisDir.name
    
    cd silvk_t1_processed_wmparc_stat
    cd (thisDirName)
    data=readtable('wmparc.csv');
    
    Intracranial=cell2mat(data.x_TitleSegmentationStatistics(37));
    
    finalData(i,:)=str2num(Intracranial);
    
    %system(['mv wmparc.stats  wmparc.csv']);
    
    cd (originaldir);
    
end

h=table(finalData, 'VariableNames', {'Intracranial'})

writetable(h, 'total_Intracranial.csv');
