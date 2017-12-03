function changeFStoBW(path)

cd /rfanfs/pnl-zorro/projects/ADHD/freesurfer-analyses/


dirname=dir('subjects');
allDirs =dirname([dirname.isdir]);
allSubDirs=allDirs(3:end);
for i =1 : length(allSubDirs);
    originalfolder=pwd;
    alldir=allSubDirs(i);
    thisDirName=alldir.name;
    cd subjects/
    cd (thisDirName)
    cd mri
    
    volume_name =[(thisDirName), '_mask', '.nrrd'];
    output_name =[(thisDirName), '_mask', '.nrrd'];
    final_name=[(thisDirName),'_mask', '.nii.gz'];
    edited_mask=[(thisDirName),'_mask-edr', '.nii.gz'];
    
    %deleting files
    %delete (volume_name)
    %delete (output_name)
    
    delete (edited_mask)
    
    %system(['ConvertBetweenFileFormats wmparc.mgz ' volume_name])
    system(['unu 1op "if" -i ' volume_name ' -o ' output_name])
    system(['ConvertBetweenFileFormats ' output_name ' ' final_name])
    system(['fslmaths ' final_name ' -bin -kernel sphere  2 -dilM ' edited_mask ]);
    system(['fslmaths ' final_name ' -fillh26 -kernel sphere  4 -dilF ' edited_mask ]);
    getenv('ANTS')
    
    cd (originalfolder)
end
    %im(~im==0)=1;
    %im5=imfill(im);
    %conn=conndef(3,'maximal');
    %im2=imfill(im, conn, 'holes');
    %im3=imfill(im2,conn,  'holes');
    %im4=imfill(im3, conn, 'holes');
    %o=find(im==1);
    
    %Nii.vol=im2
    %N.vol=im
    
%MRIwrite(Nii,'/rfanfs/pnl-zorro/projects/ADHD/freesurfer-analyses/subjects/case103/mri/test_mask.nii.gz');
    
%MRIwrite(N,'/rfanfs/pnl-zorro/projects/ADHD/freesurfer-analyses/subjects/case103/mri/test_mask111.mgz');
%fid = fopen(j);
    %j='residual_RTOP-final.csv';
 %paramIds = textscan(fid,'%s',1,'HeaderLines',5);
 %fclose(fid);
 
 %path='/rfanfs/pnl-zorro/home/sarina/new-neonate/RESULTS/';
 %data='RTOP.xls'
 %h=xlsread('RTAP.xls');
 %data=dataset('xlsfile',sprintf('%s\%s', path, data));



 
