function changeDirnames(dirName)
cd /projects/schiz/NFL/new_MRS/new/

dirResult =dir('PNL');
allDirs =dirResult([dirResult.isdir]);
allSubDirs=allDirs(3:end);

 for i = 1:length(allSubDirs)
    originalFolder = pwd
    thisDir = allSubDirs(i);
    thisDirName = thisDir.name;
    oldname =[thisDirName(1:6)];
    newname = ['R', thisDirName(2:6)];
    cd PNL
    movefile(oldname, newname);
    % changeDirnames(newname);
    cd (originalFolder);
 end
for i= 1:length(allSubDirs)
    originalDir=pwd
    thisDir = allSubDirs(i);
    thisDirName = thisDir.name;
    folder=sprintf(thisDirName);
    cd PNL; 
    sub=pwd
    cd (folder);   
    ls
    name=ls;
    this=name(13:18);
    finalname=num2str(this);
    nameex=sprintf(finalname);
    cd (sub)
    oldname=[thisDirName]
    newname=[finalname]
    movefile(oldname, newname);
    cd (originalDir)
end
    
 
 
   for i = 1:length(allSubDirs)
     originalFolder = pwd
     allfolder =allSubDirs(i);
     name=allfolder.name;
     folder=sprintf(name);
     cd PNL; cd (folder);
     mkdir T1dicom_1;
     movefile('R*', 'T1dicom_1');
     cd (originalFolder);
   end
   
   cd ../
  
   %dicoms to nhdr by executing lixux command
   
   command = 'DWIConvert --inputDicomDirectory ${i} --outputVolume ${i}/T1w_MRS_1.nhdr'
    [status, cmdout] =system([command]);