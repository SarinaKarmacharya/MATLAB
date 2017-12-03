function brain2mask()

addpath /projects/schiz/pi/yogesh/toolboxes/nifti

m=load_untouch_nii('/rfanfs/pnl-zorro/projects/ADHD/freesurfer_final_Qdec/case104.freesurfer/mri/brainmask.nii');

m.img(m.img~=0)=1;
conn=conndef(3,'maximal');

m.img=imfill(m.img, conn, 'holes');m.img=imfill(m.img, 'holes');m.img=imfill(m.img, 'holes');

m.img=bwareaopen(m.img,1000, 26);


fm = ('/rfanfs/pnl-zorro/projects/ADHD/freesurfer_final_Qdec/case104.freesurfer/mri/binarynmask.nii')
save_untouch_nii(m,fm); 