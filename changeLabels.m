addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/

DirName=dir('Andrew');
dirName=DirName([DirName.isdir]);
subdir=dirName(3:end);
originalDir=pwd;

for i= 1: length(subdir)
    SubDirName=subdir(i)
    Subdirname=SubDirName.name
    nameSubdir=sprintf(Subdirname);
    cd Andrew
    cd (nameSubdir);
    cd T1w/Diffusion/
    
    if(exist([nameSubdir, '-dwi_label.nii.gz']))
        
        atlas=MRIread([nameSubdir, '-dwi_label.nii.gz']);
        label=MRIread([nameSubdir, '-dwi_label.nii.gz']);
        
        label.vol(atlas.vol==1)=15000;
        label.vol(atlas.vol==2)=16000;
       
        Newfilename=[nameSubdir,'-dwi_label-edr.nii.gz'];
  
        MRIwrite(label, Newfilename);
       
    else
        disp(['File does not exist']);
        %system(['ConvertBetweenFileFormats ' ' ' nameSubdir '-dwi_label.nrrd' ' ' nameSubdir '-dwi_label.nii.gz']);
        
        cd(originalDir);
    end
    
    cd(originalDir);
end

for i= 1: length(subdir)
    SubDirName=subdir(i)
    Subdirname=SubDirName.name
    nameSubdir=sprintf(Subdirname);
    cd Daniel
    cd (nameSubdir);
    cd T1w/Diffusion/
    system(['ConvertBetweenFileFormats ' ' ' nameSubdir '-dwi_label-edr.nii.gz' ' ' nameSubdir '-dwi_label-edr.nrrd']);
    FileName=[nameSubdir,'-dwi_label-edr.nrrd'];
    freesurfer=['/rfanfs/pnl-zorro/home/Connectome/DATA/Andrew/' nameSubdir '/' nameSubdir '_wmparc.mgz']
    system(['ConvertBetweenFileFormats ' ' ' freesurfer ' ' nameSubdir '_wmparc.nrrd']);
    freesurferName=[nameSubdir, '_wmparc.nrrd'];
    output=[nameSubdir, '_label_fs_m.nrrd']
    
    if(exist([nameSubdir, '-dwi_label-edr.nii.gz']))
        system([ ' unu 2op + ' ' ' FileName ' ' freesurferName ' ' '-o' ' ' output]);
   end
end

for i=1:length(subdir)
    SubDirName=subdir(i);
    Subdirname=SubDirName.name;
    nameOfSubdir=sprintf(Subdirname);
    originalDir=pwd
    cd Daniel
    cd (nameSubdir);
    
    freesurferAtlas=['/rfanfs/pnl-zorro/home/Connectome/DATA/Andrew/' nameSubdir '/' nameSubdir '_wmparc.mgz'];
    
    if (exist([nameSubdir, '_wmparc.mgz']))
        system(['ConvertBetweenFileFormats ' ' ' freesurferAtlas ' ' nameSubdir '_wmparc.nii.gz']);
    else
        disp(['there is no such file' ' 'nameSubdir '_wmparc.mgz' ]);
        cd (originalDir)
    end
    
    cd T1w/Diffusion;
    
    mkdir WMQL;
    outputDir= pwd
    
    freesurferAtlas2=['/rfanfs/pnl-zorro/home/Connectome/DATA/Andrew/' nameSubdir '/' nameSubdir '_wmparc.nii.gz'];
    MDLFQueryFile=['/rfanfs/pnl-zorro/home/Connectome/mdlf_wmql.qry'];
    HandQueryFile=['/rfanfs/pnl-zorro/home/Connectome/MDLF.qry'];
    tractographyFile=['/rfanfs/pnl-zorro/home/Connectome/DATA/Andrew/' nameSubdir '/T1w/Diffusion/tractograpgy/105-ukftract_b3000.vtk']
    
    if (exist('tractography'))
        
        disp(['file exists']);
        
        system(['wmql.sh ' ' ' tractographyFile ' ' freesurferAtlas2 ' ' HandQueryFile ' ' outputDir ' ' nameSubdir]);
        %for foot    
        
    else
        disp(['there is not such folder']);
        cd (originalDir);
    end
    
    handDrawnAtlas=['/rfanfs/pnl-zorro/home/Connectome/Atlas/ANDREW/' nameSubdir '-dwi_label.nrrd'];
    
    leftTractographyFile=['/rfanfs/pnl-zorro/home/Connectome/DATA/Andrew/' nameSubdir 'MDLF_mdlf_left.vtk'];
    
    rightTractograohyFile=['/rfanfs/pnl-zorro/home/Connectome/DATA/Andrew/' nameSubdir 'MDLF_mdlf_right.vtk'];
    
    system(['wmql.sh ' ' ' leftTractographyFile ' ' handDrawnAtlas ' ' MDLFQueryFile ' ' outputDir ' ' nameSubdir];  

    system(['wmql.sh ' ' ' rightTractographyFile ' ' handDrawnAtlas ' ' MDLFQueryFile ' ' outputDir ' ' nameSubdir]; 
end


