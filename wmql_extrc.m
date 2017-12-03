
    dirName=dir('T4_Imaging_Data');
    nameofDir=dirName([dirName.isdir]);
    subdir = nameofDir(3:end);
    n=length(subdir);

    originalDir=pwd
    
    %load cases.txt
    %caselist=cases(:,1);
    %n=length(caselist)
    
   
%for i= 1: length(subdir)
for i=1:n
    SubDirName=subdir(i);
    Subdirname=SubDirName.name;
    nameSubdir=sprintf(Subdirname);
    %name=num2str(cases(i,1));
    %nameSubdir=sprintf(['X', name]);
    cd T4_Imaging_Data;
    cd (nameSubdir);
    %cd diff;
    
    
    handDrawnAtlas=['/rfanfs/pnl-a/pnl/Collaborators/Active/Kates22q11DS/Projects/20160706_mdlf_andrew/all_cases/' nameSubdir '_label.nii.gz'];
    
    freesurferAtlas=['/rfanfs/pnl-a/pnl/Collaborators/Active/Kates22q11DS/T4_Imaging_Data/' nameSubdir '/diff/' nameSubdir '.fs2dwi/' 'wmparc-in-bse-1mm-centered.nii.gz'];
    MDLFQueryFile=['/rfanfs/pnl-a/pnl/Collaborators/Active/Kates22q11DS/Scripts_MDLF/mdlf_wmql.qry'];
    HandQueryFile=['/rfanfs/pnl-a/pnl/Collaborators/Active/Kates22q11DS/Scripts_MDLF/MDLF.qry'];
    tractographyFile=['/rfanfs/pnl-a/pnl/Collaborators/Active/Kates22q11DS/T4_Imaging_Data/' nameSubdir '/tracts/' nameSubdir '.vtk'];
    outputDir=[nameSubdir '_wmql'];
    outputDir_left=[outputDir '/left'];
    outputDir_right=[outputDir '/right'];
    
    
    leftTractographyFile=[outputDir '/' nameSubdir '_mdlf_left.vtk'];
    
    rightTractographyFile=[outputDir '/' nameSubdir '_mdlf_right.vtk'];
    
    
    system(['wmql.sh ' ' ' tractographyFile ' ' handDrawnAtlas ' '  HandQueryFile ' ' outputDir ' ' nameSubdir]);  
    
    system(['wmql.sh ' ' ' leftTractographyFile ' ' freesurferAtlas ' ' MDLFQueryFile ' ' outputDir_left ' ' nameSubdir]);
    
    system(['wmql.sh ' ' ' rightTractographyFile ' ' freesurferAtlas ' ' MDLFQueryFile ' ' outputDir_right ' ' nameSubdir]);
    
    
    cd (originalDir);
end


