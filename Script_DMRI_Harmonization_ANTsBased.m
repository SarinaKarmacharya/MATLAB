function Script_DMRI_Harmonization_ANTsBased(Inputs)

addpath('/projects/schiz/Collaborators/hengameh/Codes')
mapping_type=[1 ];
option.mapping_type=mapping_type;
option.debug_fig=0;
option.watson=0;
option.Load_dwi=0;
option.Load_gm=0;
option.use_modified_nhrd_HM=0;
option.SH_level_docomposition=8;
option.GM_before_after='after';
option.set_total_existing_labels_manuall=0;
option.showScaleAtVoxels=0;
[PATH]= sub_to_add_paths(option);
PATH.updated_gm_orig=PATH.updated_gm;
[Inf_sites,Inf_Brain_labels,Inf_patients ]= sub_to_load_id_NAA_cases_and_ages_20150121(PATH,0);
aa=Inputs.Image_name;
PATH.base= Inputs.Image_dir;%[PATH.Intrust   aa(1,1:3) '_' aa(1,5:7) '_' aa(1,9:11)];
PATH.S=Inputs.Image_raw;%[PATH.base '/diff/' aa(1,1:3) '_' aa(1,5:7) '_' aa(1,9:11)     '-dwi-Ed.nhdr'];
PATH.freeSurfer_nrrd=[];%[PATH.base '/strctXXX/' aa(1,1:3) '_' aa(1,5:7) '_' aa(1,9:11)     '.freesurfer/mri'];
PATH.tensor_mask=Inputs.Image_mask;%[PATH.base '/diff/' aa(1,1:3) '_' aa(1,5:7) '_' aa(1,9:11)   '-tensor-mask.nhdr'];
PATH.label_map_dwi=[];
PATH.Templates='/rfanfs/pnl-zorro/home/hengameh/ANTsBasedTemplates/';
% [PATH.Intrust ...
%     aa(1,1:3) '_' aa(1,5:7) '_' aa(1,9:11)   '/diff/' ...
%     aa(1,1:3) '_' aa(1,5:7) '_' aa(1,9:11)  '.wmparc-in-dwi.nrrd'];
PATH.Final_Harmonized_image=Inputs.Image_Harmonized_dir;%[PATH.Intrust 'HarmonizedImagesII/'];
%PATH.updated_gm=[PATH.Final_Harmonized_image 'SaveSomePars/'];
mkdir(PATH.Final_Harmonized_image)
%mkdir(PATH.updated_gm)
num_selected_sites =  sub_givenIMGname_findSiteNumber(aa,option,PATH);
%PATH.gm=[PATH.freeSurfer_nrrd '/XXXXwmparc.nrrd']; %gm = nrrdZipLoad( PATH.gm);
%PATH.m=[PATH.base '/diffxxxx/' aa(i_,1:3) '_' aa(i_,5:7) '_' aa(i_,9:11)     '-dwi-Ed.raw.gz'];
i_=1;
clear All_dwi
% [S_ini u_ini  b_ini] = nhdr_diff_general(PATH.S);
if option.use_modified_nhrd_HM==0
    if option.Load_dwi
        [S uu,  bb] = nhdr_diff_multiB(PATH.S);
    else
        S=[];
        uu=[];
        bb=[];
    end
    
elseif (option.use_modified_nhrd_HM==1 | option.use_modified_nhrd_HM==3)
    if option.debug_tendestim
        system(['tend estim  -i '  PATH.S '  -B kvp -knownB0 0' ' -o ' PATH.base '/diff/' aa(i_,1:3) '_' aa(i_,5:7) '_' aa(i_,9:11)     '_out_tend_estim.nhdr']);
    end
    
    %tend estim -i 015_NAA_008-dwi-Ed.nhdr -B kvp -knownB0 0 -eb testb0.nhdr -o testooo.nhdr
    %fnb0='/rfanfs/pnl-zorro/INTRuST/data_processing/015_NAA_008/diff/testooo.nhdr';
    fnb0=[PATH.base '/diff/' aa(i_,1:3) '_' aa(i_,5:7) '_' aa(i_,9:11)     '_out_tend_estim.nhdr'];
    [S, uu, bb, voxel___, Sm____, s0___] = nhdr_diff_multi_HM(PATH.S,fnb0,option);
elseif option.use_modified_nhrd_HM==2
    if option.debug_tendestim
        system(['tend estim  -i '  PATH.S '  -B kvp -knownB0 0'  ...
            ' -eb '   PATH.base '/diff/' aa(i_,1:3) '_' aa(i_,5:7) '_' aa(i_,9:11)     '_out_tend_estim_eb.nhdr' ...
            ' -o ' PATH.base '/diff/' aa(i_,1:3) '_' aa(i_,5:7) '_' aa(i_,9:11)     '_out_tend_estim.nhdr']);
    end
    
    %tend estim -i 015_NAA_008-dwi-Ed.nhdr -B kvp -knownB0 0 -eb testb0.nhdr -o testooo.nhdr
    %fnb0='/rfanfs/pnl-zorro/INTRuST/data_processing/015_NAA_008/diff/testooo.nhdr';
    fnb0=[PATH.base '/diff/' aa(i_,1:3) '_' aa(i_,5:7) '_' aa(i_,9:11)     '_out_tend_estim_eb.nhdr'];
    [S, uu, bb, voxel___, Sm____, s0___] = nhdr_diff_multi_HM(PATH.S,fnb0,option);
    
end

All_dwi(i_).S=S;
All_dwi(i_).uu=uu;
All_dwi(i_).bb=bb;
All_dwi(i_).PATH_S=PATH.S;



%PATH.tensor_mask=[PATH.base '/diff/'  taveling_subject_cases_V2{site_num}  prefix_sites{site_num}   '-tensor-mask.nhdr'];
All_dwi(i_).gm=[];
All_dwi(i_).PATH_label_map_dwi=[];
All_dwi(i_).PATH_tensor_mask=PATH.tensor_mask;
All_dwi(i_).aa=aa;
%All_dwi(i_).handmess_age_updated=handmess_age_updated;

%---save updatedLabelMap
% based on /projects/schiz/Collaborators/hengameh/Codes/sub_script_201508_freesuferCorrection.m


% Num_total_Steps=5;
% multiWaitbar( 'CloseAll' );
% multiWaitbar( 'Please Wait',    0/Num_total_Steps, 'Color', [0.2 0.9 0.3] );
% multiWaitbar( '', 0/7, 'Color', [1.0 0.4 0.0] );


PATH.label_map_dwi=[];
PATH.S=All_dwi(i_).PATH_S;
PATH.tensor_mask=All_dwi(i_).PATH_tensor_mask;
[IMG]=sub_201506_read_S_gm_otherInf(PATH,option);

option.name=[ 'before_' All_dwi(i_).aa ];
PATH.TBSS=[Inputs.Image_Harmonized_dir    All_dwi(i_).aa filesep];
mkdir(PATH.TBSS)
subSaveLsBeforeAfterRef(IMG,PATH,option);


%--- now perform image registration of these saved inf to the templates ...
fix=[PATH.TBSS     'L2/'  option.name '.nii.gz'];
mov=[PATH.Templates 'Median3_site' num2str(num_selected_sites) '_1.nii.gz'];

system(['/projects/schiz/software/ANTS-git-build/bin/antsRegistrationSyNQuick.sh -d 3 -f' fix  ' -m '  mov  ' -o '  PATH.TBSS  'Pi_'  All_dwi(i_).aa   ]);

['s4 ' fix ' ' mov ' ' PATH.TBSS  'Pi_'  All_dwi(i_).aa 'Warped.nii.gz'];

for T_number=0:4
    mov=[PATH.Templates 'Delta3Median_site' num2str(num_selected_sites) '_L' num2str(T_number+1) '.nii.gz'];
    fix=[PATH.TBSS     'L'  num2str(T_number+1) '/'  option.name '.nii.gz'];
    t_img1=[PATH.TBSS  'Pi_'  All_dwi(i_).aa '1Warp.nii.gz'];
    t_img2=[PATH.TBSS  'Pi_'  All_dwi(i_).aa  '0GenericAffine'];%MY017_NAA_024_L100GenericAffine;
    mov_warped=[PATH.TBSS   'Median3_site' num2str(num_selected_sites) '_' num2str(T_number) '_'   All_dwi(i_).aa  '.nii.gz'];
    r_img=fix;
    system(['antsApplyTransforms -d 3 -i '  mov ' -o ' mov_warped ' -r  '  r_img '   -t '  t_img1 '    -t '  t_img2 '.mat']);
end



mapped_Cs=[];
for i=1:5
    i2_=i;
    Norm1= (sum((IMG.Cs(IMG.shs_same_leve(i,1):IMG.shs_same_leve(i,2) ,:).^2),1));
    
    %bin_mask=IMG.mask;%(1-double(IMG.gm==-1));
    %temLs=temLs(:).*bin_mask(:);
    %temLs(temLs>th)=th;
    %temLs=(temLs)./max(temLs(:));%median(temLs(temLs>0));
    %Ls=reshape(temLs,size(IMG.gm)).*(1-double(IMG.gm==-1));%nz ny nx
    mov_warped=[PATH.TBSS   'Median3_site' num2str(num_selected_sites) '_' num2str(i-1) '_'   All_dwi(i_).aa  '.nii.gz'];
     
    mri=MRIread_modified(mov_warped);
    % ([PATH.All_sites 'Inv_delta_'...
    %  par_to_load{1}   '_' ee(subject_num,:)  '_L' num2str(i)  '.nii.gz'] );
    
    %imagesc(mri.vol(:,:,33));colorbar
    
    %Norm2=mapped_L0246(:,i2_)';
    Norm2=Norm1+(mri.vol(:))';
    sum(Norm2(:)<0)./(128*128*73);
    
    Norm2(Norm2<0)=0;
    
    
    for SH_levels=[IMG.shs_same_leve(i2_,1):IMG.shs_same_leve(i2_,2)]
        clear tem
        tem =IMG.Cs(SH_levels,:);%
        %mapped_Cs=[mapped_Cs ;   ((sum(Norm2)./(eps+sum(Norm1(IND_specific_label)))).^(.5)).*tem(IND_specific_label)];
        mapped_Cs=[mapped_Cs ;   ( (  ((Norm2)./(eps+Norm1)   )  ).^(.5)).*tem];
    end
    
    %if i2_<3
    %showScaleAtVoxels=( (  ((Norm2)./(eps+(Norm1))   )  ).^(.5));
    %showScaleAtVoxels=reshape(showScaleAtVoxels,size(IMG.gm));
    %                       IND=find(IMG.gm==3011);
    %
    %                       showScaleAtVoxels(IND)
    %
    %                       diff_fa=fa_mapped_Cs-IMG.fa_estimated_S_using_Cs;
    %                       diff_fa=reshape(diff_fa,size(IMG.gm));
    %
    %                       diff_fa(IND)
    % end
    % for jk=1:73
    %   gcf; imagesc(Ls(:,:,jk));
    %
    %end
    %cat_Ls=cat(4,cat_Ls,Ls);
    %mkdir(['/rfanfs/pnl-zorro/home/hengameh/Save_For_ANTs/MyImgs/site' num2str(num_selected_sites)])
    %             PATH.saveNewFA=['/rfanfs/pnl-zorro/home/hengameh/Save_For_ANTs/MyImgs/All_sites/'  ee(subject_num,:) ];% '.nhdr'
    %
    %             mat2nhdrHM(Ls,[ PATH.saveNewFA  '_L'  num2str(i)],'custom',IMG.Sm,IMG.So);
    %
    %             system(['ConvertBetweenFileFormats  '  PATH.saveNewFA  '_L'  num2str(i)   '.nhdr   '    PATH.saveNewFA  '_L'  num2str(i) '.nii.gz'  ])
    %
    %             system(['rm  ' PATH.saveNewFA  '_L'  num2str(i)   '.nhdr'])
    %             system(['rm  '  PATH.saveNewFA  '_L'  num2str(i)   '.raw.gz'])
end
Estimated_S_using_mapped_Cs= single(((IMG.Y(IMG.ind_bb_750_1050,:)*mapped_Cs))');
%Estimated_S_using_mapped_Cs= single(( (Y(ind_bb_750_1050,:)*(mapped_Cs)))');

option.compute_eigvec=0;

[fa_mapped_Cs,eig_vec_mapped_Cs]=sub_to_compute_FA(IMG.uu(IMG.ind_bb_750_1050,:), IMG.bb(IMG.ind_bb_750_1050,:), Estimated_S_using_mapped_Cs,option);
%else
%Estimated_S_using_mapped_Cs=IMG.Estimated_S_using_Cs;
%fa_mapped_Cs=IMG.fa_estimated_S_using_Cs;
%end
% write FA after harmonization
fa_3D_reshape=reshape(fa_mapped_Cs,size(IMG.gm));
%mat2nhdrHM(fa_3D_reshape,[ PATH.TBSS   'after_fa_' All_dwi(i_).aa ],'custom',IMG.Sm,IMG.So,[ 'after_fa_' All_dwi(i_).aa]);

mapped_S_3D=Estimated_S_using_mapped_Cs;
IMG2=IMG;
IMG2.Estimated_S_using_Cs=Estimated_S_using_mapped_Cs;
IMG2.Cs=mapped_Cs;
IMG2.fa_estimated_S_using_Cs=fa_mapped_Cs;

clear dwi
dwi =loadNrrdStructureMultiB(PATH.S);
dwi2=struct('gradients',dwi.gradients,'bvalue',dwi.bvalue(1,1),'data',dwi.data,'spacedirections',dwi.spacedirections,'spaceorigin',dwi.spaceorigin);

mapped_S_3D_re=reshape(mapped_S_3D,[IMG.nx IMG.ny IMG.nz size(IMG.ind_bb_750_1050,1)]);
mapped_S_3D_re=repmat(IMG.So,[1 1 1 size(mapped_S_3D_re,4)]).*mapped_S_3D_re;%
%dwi2.gradients=[IMG.uu(1:size(mapped_S_3D_re,4)/2,:); 0 0 0];
dwi2.gradients=[IMG.uu(IMG.ind_bb_750_1050(1:size(mapped_S_3D_re,4)/2),:); 0 0 0];

dwi2.data=cat(4,mapped_S_3D_re(:,:,:,1:size(mapped_S_3D_re,4)/2),IMG.So);
%dwi2.bvalue=[IMG.bb(1) ];
mat2DWInhdr([ 'after_'  All_dwi(i_).aa ],[PATH.TBSS ],dwi2,'uint16');



