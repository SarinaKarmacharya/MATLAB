addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/


labelmap='/projects/schiz/NFL/case01510/labelmaps/01510-AHCC-kg.nii.gz'

freesurfer='/projects/schiz/NFL/freesurfer_processed/01510.freesurfer/mri/wmparc_test.nii.gz';

atlas=MRIread([labelmap]);
freesurferlabel=MRIread([freesurfer]);
 
atlas.vol;
freesurferlabel.vol;

tmp3=zeros([256   256   176]);
k=atlas.vol;
p=freesurferlabel.vol;

for i =1:size(freesurferlabel.vol,1);
    for j=1:size(freesurferlabel.vol,2)
        for k=1:size(freesurferlabel.vol,3)
    
    if ([(freesurferlabel.vol(i,j,k) >0) & (atlas.vol(i,j,k)>0)]);
       freesuferlabel.vol(freesuferlabel.vol(i,j,k)==0);
    else
        disp(['they dont have overlap']);
    end
        end
        

    end 
end




freesurferlabel.vol(atlas.vol>0)=0;
tmp3=freesurferlabel.vol+atlas.vol;
freesurferlabel.vol=tmp3

Newfilename=('test.nii.gz');
MRIwrite(freesurferlabel, Newfilename);





;o =find([(atlas.vol >0 )& (freesurferlabel.vol >0)])