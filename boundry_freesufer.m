clear

addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
addpath /rfanfs/pnl-zorro/software/SignalDropQCTool/nrrdFunctions/

%% 

bse_label='/projects/schiz/NFL/freesurfer_processed/destrieux_labelmaps2DWI/'
cd(bse_label);
LabelDir=dir('01*');
Subjects=numel(LabelDir);
tic
for kk=1:Subjects
    sub_name=LabelDir(kk).name;
    LabelData=MRIread([sub_name, '/wmparc-in-bse.nii.gz']);
    Data=LabelData.vol;
    G=LabelData.vol;
    G(G~=0)=1;

    [nx ny nz]=size(LabelData.vol);

%% labelling different brain areas defined. 

LeftGyralRegion={11109,11110,11111,11112,11113,11114,11115,11116,11117,11118,11119, .....
    11120,11121,11122,11123,11124,11125,11126,11127,11128,11129,11130,11131,11132, .....
    11133, 11134, 11135, 11136, 11137, 11138};
RightGyralRegion={12109,12110,12111,12112,12113,12114,12115,12116,12117,12118,12119,12120 ...
    12122,12123,12124, 12125,12126, 12127, 12128, 12129, 12130, 12131, 12132, 12133, 12134 ...
    12135, 12136, 12137, 12138};
LeftSulcalRegion={11139, 11140, 11141, 11145, 11146, 11147, 11148, 11149, 11150, ....
    11151, 11152, 11153, 11154, 11155,11156, 11157, 11158, 11159, 11160, 11161, 11162, ....
    11163, 11164, 11165, 11166, 11167, 11168, 11169, 11170, 11171, 11172, 11173, 11174};
RightSulcalRegion={12139, 12140, 12141, 12145, 12146, 12147, 12148, 12149, 12150, ....
    12151, 12153, 12154, 12155, 12156, 12157, 12158, 12159, 12160, 12161, 12162, 12163, ...
    12164, 12165, 12166, 12167, 12168, 12169, 12170, 12171, 12172, 12173, 12174};

ROIs=[LeftGyralRegion, RightGyralRegion, LeftSulcalRegion, RightSulcalRegion];
bn=numel(ROIs);

%% to calculate the Euclidean distance transform

id=[]; %% all the labels position
for i =1:bn 
    label=ROIs{i};
    id=[id; find(Data ==label)];
end

GYSU=Data(id); % all the labels position in the brain
U=unique(GYSU); % finding the unique boundary 
g=length(U);

for i =1:g
   Data(Data==U(i))=1; % converting all the labels binary
end

Data(Data~=1)=0; % what ever is not equal to the label to zero

[store idx]=bwdist(Data); % computing the distance transform

reuse_idx=idx;
store(store~=1)=0; % getting only the boundaries
store(G~=1)=0; % removing the outside boundary of the brain
idx=idx(store==1); % findind the index of voxel from which the  boundary was calculated
uni_idx=unique(idx); % finding each unique index
j=length(uni_idx); 

Final_Data=LabelData.vol; % using this data for storing new results
Final_Data(Data~=1)=0; % using only the sulcus and gyrus 

for ii =1: j
    index=uni_idx(ii);
    val=Final_Data(index);
    reuse_idx(reuse_idx==index)=val;
end
reuse_idx(store~=1)=0;

%% output

LabelData.vol(LabelData.vol~=0)=0;
LabelData.vol=reuse_idx;
output_name=([bse_label, sub_name, '/boundary_sulcus_gyrus_label.nii.gz']);
MRIwrite(LabelData,output_name);

%% to visualize the images
% 
% for kl=1:nz
%     figure(1), imagesc(store(:,:,kl)); pause(0.2);
% end
% 
% figure
% subplot(2,2,1), isosurface(store,15), axis equal, view(3)
% camlight, lighting gouraud, title('Euclidean')
end
toc
