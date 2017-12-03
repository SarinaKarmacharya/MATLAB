addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
cd /rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/
originaldir=pwd

dirname=dir('all_labelmap');

nameofdir=dirname([dirname.isdir]);

cd ('all_labelmap');
files=dir('*.nrrd')
    N=length(files)
    CaseName=cell(N,1);
    loadstr=zeros(N,1); 

tmp = zeros([84 84 26]);
tmp2=zeros([84 84 26]);
tmp3=zeros([84 84 26]);
for id =1:N
        
        %[~,f]=fileparts(files(id).name)
        CaseName{id}=sprintf(files(id).name);
        mat=nrrdLoad(CaseName{id});
        %loadStr{id}=nrrdLoad(CaseName{id});
        tmp = tmp +mat;
        
        tmp2=tmp/N;
        tmp3=tmp2*100;
        
        tmp3(tmp3<100)=0;
        tmp3(tmp3==100)=1;
        
        tmp3(tmp3<=80)=0;
        tmp3(tmp3>=80)=1;
end
    


e=MRIread('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/empty_mask.nii.gz');

[nx,ny,nz]=size(tmp3);
M=zeros(ny,nx,nz);

for k=1:nz
    X=tmp3(:,:,k);
    M(:,:,k)=(fliplr(rot90(rot90(rot90(X)))));
end
e.vol=M

MRIwrite(e,'/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/average_all_heat_map_FOOT80_2.nii.gz');


cd (originaldir);




