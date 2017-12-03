function MinDistance=centerOfMass_GP(fname,labelname,hemi)

addpath /projects/schiz/software/Matlab/nrrdUtilities/
addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
addpath /rfanfs/pnl-zorro/software/SignalDropQCTool/nrrdFunctions/

%% this part open the facemotor cortex to brain stem area / need to get the center of mass in every plane 

v=spm_vol(fname);
[d,xyz]=spm_read_vols(v);
data=d;
data(data~=0)=0;
v.fname=['center-',v.fname];
[i, j, k]=size(d);
cOx=zeros(k,1);
cOy=zeros(k,1);
cOz=(1:k)';

for ii =1:k
 
    img=d(:,:,ii);
    
        if sum(img(:))>0

        [y, x] = meshgrid(1:size(img, 2), 1:size(img, 1));

        weightedx = x .* img; %x*p(xyz)
        weightedy = y .* img; %y*p(xyz)

        cx = sum(weightedx(:)) / sum(img(:));
        cy = sum(weightedy(:)) / sum(img(:));

        cx=floor(cx);
        cy=floor(cy);
        
        cOx(ii,1)=cx;
        cOy(ii,1)=cy;

        data(cx, cy, ii)=1;
    end
end

%spm_write_vol(v,data);

cxId=find(cOx~=0);
cyId=find(cOy~=0);
cOx(cxId);
cOy(cyId);
cOz(cyId);


%% this part opens GP brain area

g=spm_vol(labelname);
[d2,xyz]=spm_read_vols(g);
g.fname=['center-',g.fname];
labimg=d2;

if  isequal(hemi,'left')
    labimg(labimg~=1)=0;
    labimg(labimg==1)=1;
else
    %disp('it is right')
    labimg(labimg~=2)=0;
    labimg(labimg==2)=1;
end

[ny, nx, nz] = meshgrid(1:size(labimg, 2), 1:size(labimg, 1), 1:size(labimg, 3) );

weightednx = nx .* labimg; %x*p(xyz)
weightedny = ny .* labimg; %y*p(xyz)
weightednz = nz .* labimg; %z*p(xyz)

cox = sum(weightednx(:)) / sum(labimg(:));
coy = sum(weightedny(:)) / sum(labimg(:));
coz = sum(weightednz(:)) / sum(labimg(:));

cox=floor(cox);
coy=floor(coy);
coz=floor(coz);

labimg(labimg~=0)=0;
labimg(cox, coy, coz)=1;
%spm_write_vol(g,labimg);

%% distance between two brain areas
distance=zeros(numel(cOz),1);

for p =1:numel(cOy)
    
distance(p,1)=sqrt((cOx(p)-cox)^2+(cOy(p)-coy)^2+(cOz(p) -coz)^2);

end
distance=distance*1.25;
MinDistance=min(distance);
