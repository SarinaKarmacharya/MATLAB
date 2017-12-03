
function MinDistance=MinDistanceROI2ROI(fname,labelname,hemi)
% This code calculate every distance between two brain areas

%% 
addpath /projects/schiz/software/Matlab/nrrdUtilities/
addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
addpath /rfanfs/pnl-zorro/software/SignalDropQCTool/nrrdFunctions/

%% loading label map
v=spm_vol(fname);
%v=spm_vol('101107_labelmap_right.nii');
[d,~]=spm_read_vols(v);
img=d;
[y, x, z]=meshgrid(1:size(img,2), 1:size(img,1),1:size(img,3));
x0=x .* img;
y0=y .* img;
z0=z .* img;

x_id=find(x0~=0);
X0=x0(x_id);

y_id=find(y0~=0);
Y0=y0(y_id);

z_id=find(z0~=0);
Z0=z0(z_id);

%% 
g=spm_vol(labelname);
%g=spm_vol('101107_STN_dwispace.nii');
[d2,~]=spm_read_vols(g);
labimg=d2;

if  isequal(hemi,'left')
    labimg(labimg~=1)=0; %% 3 is for STN , 1 is for GP
    labimg(labimg==1)=1;
else
    %disp('it is right')
    labimg(labimg~=2)=0; %% 4 is for STN, 2 is for GP
    labimg(labimg==2)=1;
end

[ny, nx, nz]=meshgrid(1:size(labimg,2), 1:size(labimg,1),1:size(labimg,3));

xx= nx .* labimg;
yy= ny .* labimg;
zz= nz .* labimg;

xx_id=find(xx~=0);
XX=xx(xx_id);

yy_id=find(yy~=0);
YY=yy(yy_id);

zz_id=find(zz~=0);
ZZ=zz(zz_id);

%% 
N=numel(X0);
n=numel(XX);
my_dist=zeros(N,n);
for i =1:N
    for j=1:n
    my_dist(i,j)= sqrt((X0(i)-XX(j)).^2 + (Y0(i)-YY(j)).^2 +(Z0(i)-ZZ(j)).^2); 
    end
end
distance=my_dist.*1.25;
MinDistance=min(distance(:));
