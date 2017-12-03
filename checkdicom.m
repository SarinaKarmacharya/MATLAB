dirResult =dir('PNL');
allDirs =dirResult([dirResult.isdir]);
allSubDirs=allDirs(3:end);
originalDir=pwd
for i= 1:length(allSubDirs)
    thisDir = allSubDirs(i);
    thisDirName = thisDir.name;
    folder=sprintf(thisDirName);
    cd PNL; 
    sub=pwd
    cd (folder);   
    ls
    name=ls;
    this=name(%s);
    finalname=num2str(this);
    nameex=sprintf(finalname);
    system(['dcmdump ' ' ' nameex ' ' '|grep SeriesDescription'])
end
