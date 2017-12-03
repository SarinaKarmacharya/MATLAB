addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/


caselist='/rfanfs/pnl-zorro/Collaborators/Ana_Rivas/ALCOHOL/scripts/caselist.txt';

CaseName=textread(caselist,'%s');

N=length(CaseName);

for i =1: N
    
mask=MRIread(['/rfanfs/pnl-zorro/Collaborators/Ana_Rivas/ALCOHOL/preProcess/Masks-Epi/' CaseName{i} '_dwi_xc_mask_Edited.nii.gz']);
one=find(mask.vol==1);
numvoxels=length(one);
volume=numvoxels*8;

disp((CaseName{i}));
disp([volume]);

end

