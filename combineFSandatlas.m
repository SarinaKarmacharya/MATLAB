addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
caselist='/projects/schiz/NFL/freesurfer_processed/shape_viv/matlab_SubjectList.txt'
name=textread(caselist, '%s');
N=numel(name);
for i =1:N
nrrdname=['/projects/schiz/NFL/case' name{i} '/labelmaps/' name{i} '-AHCC-kg.nhdr'];
labelmap=['/projects/schiz/NFL/case' name{i} '/labelmaps/' name{i} '-AHCC-kg.nii.gz'];
freesurferNrrdName=['/projects/schiz/NFL/freesurfer_processed/' name{i} '.freesurfer/mri/wmparc.nrrd']
freesurfer=['/projects/schiz/NFL/freesurfer_processed/' name{i} '.freesurfer/mri/wmparc.nii.gz'];


    if (exist(nrrdname))

        system(['ConvertBetweenFileFormats ' nrrdname ' ' labelmap]);
    else
        disp(['file is missing ' name{i}])
    end
         if (exist(freesurferNrrdName))
             system(['ConvertBetweenFileFormats ' freesurferNrrdName ' ' freesurfer])
         else
             disp([' freesurfer file is missing ' name{i}])
         end
 

atlas=MRIread([labelmap]);

tmp3=zeros([256   256   176]);
atlas.vol(atlas.vol==4)=19;
atlas.vol(atlas.vol==5)=20;
atlas.vol(atlas.vol==6)=21;
atlas.vol(atlas.vol==7)=22;

%atlas=MRIread([labelmap]);

freesurferlabel=MRIread([freesurfer]);

freesurferlabel.vol(atlas.vol>0)=0;

tmp3=freesurferlabel.vol+atlas.vol;

freesurferlabel.vol=tmp3

Newfilename=(['/projects/schiz/NFL/freesurfer_processed/shape_viv/final-results/' name{i} '_FsLabelMask-edited.nii.gz']);
MRIwrite(freesurferlabel, Newfilename);

end 