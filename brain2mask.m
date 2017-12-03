function brain2mask(directory,input, output)

addpath /projects/schiz/pi/yogesh/toolboxes/nifti

subject=textread('/rfanfs/pnl-zorro/Collaborators/Silveri/SilveriData/scripts/casenumbers.txt', '%s')
for i= 1:numel(subject)
m=load_untouch_nii(['/rfanfs/pnl-zorro/Collaborators/Silveri/SilveriData/SILVK_T1_processed_brainmask/SILVK0' subject{i} '/brainmask.nii']);
%m=load_untouch_nii('/rfanfs/pnl-zorro/Collaborators/Silveri/SilveriData/SILVK_T1_processed_wmparc/SILVK018/wmparc.nii');

m.img(m.img>=120)=0;
m.img(m.img~=0)=1;

cc = bwconncomp(m.img);
stats = regionprops(cc, 'Area');
A = [stats.Area];
[~,biggest] = max(A);
m.img(labelmatrix(cc)~=biggest) = 0;

conn=conndef(3,'maximal');
m.img=imfill(m.img, conn, 'holes');
m.img=imfill(m.img, 'holes');
m.img=imfill(m.img, conn, 'holes');
m.img=imerode(m.img,strel('disk',12));

se2 = strel('disk',10);
m.img = imclose(m.img,se2);

m.img=imfill(m.img, conn, 'holes');
m.img=imfill(m.img, 'holes');
m.img=imfill(m.img, conn, 'holes');
se = strel('disk',12);

m.img = imdilate(m.img,se);

%Create morphological structuring element
% %shape
m.img=imfill(m.img, 'holes');
CC = bwconncomp(m.img);
stats2 = regionprops(CC, 'Area');
A2 = [stats2.Area];
[~,biggest] = max(A2);
m.img(labelmatrix(CC)~=biggest) = 0;



%fm= (image, directory);
fm = (['/rfanfs/pnl-zorro/Collaborators/Silveri/SilveriData/SILVK_T1_processed_brainmask/SILVK0' subject{i} '/SilvK0' subject{i} 'T1_mask.nii']);
save_untouch_nii(m,fm); 
end