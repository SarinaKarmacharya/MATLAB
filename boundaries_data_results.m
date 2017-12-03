clear

addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
addpath /rfanfs/pnl-zorro/software/SignalDropQCTool/nrrdFunctions/
bse_label='/projects/schiz/NFL/freesurfer_processed/destrieux_labelmaps2DWI/'
cd(bse_label);
LabelDir=dir('01*');
Subjects=numel(LabelDir);
tic
bse_fw='/projects/schiz/NFL/FW/';

%% 

ROIs=[11109,11110,11111,11112,11113,11114,11115,11116,11117,11118,11119,11120,11121,11122,11123,11124,11125,11126,11127,11128,11129,11130,11131,11132,11133,11134,.... 
    11135,11136,11137,11138,11172,11173,11174,11139,11140,11141,11145,11146,11147,11148,11149,11150,11151,11152,11153,11154,11155,11156,11157,11158,11159,11160,.... 
    11161,11162,11163,11164,11165,11166,11167,11168,11169,11170,11171,12109,12110,12111,12112,12113,12114,12115,12116,12117,12118,12119,12120,12121,12122,12123,12124,12125,....
    12126,12127,12128,12129,12130,12131,12132,12133,12134,12135,12136,12137,12138,12172,12173,12174,12139,12140,12141,12145,12146,12147,12148,12149,12150,12151,...
    12152,12153,12154,12155,12156,12157,12158,12159,12160,12161,12162,12163,12164,12165,12166,12167,12168,12169,12170,12171];

bn=numel(ROIs);

%% 
N=length(LabelDir);
meanDiffusion=zeros(N,bn);


for kk=1:Subjects
sub_name=LabelDir(kk).name;
mri_image=([bse_fw '/' sub_name '_FW.nhdr']); %% this is where the MRI volume is loaded

MRIimage=loadNrrdStructure(mri_image);
labelmap=(['/projects/schiz/NFL/freesurfer_processed/destrieux_labelmaps2DWI/' sub_name '/boundary_sulcus_gyrus_label.nhdr']);
atlas=loadNrrdStructure(labelmap);

        id=[];
        
        for jj=1:numel(ROIs)
            id = [id; find(atlas.data == ROIs(jj))];
        
        
        diffusion_value=MRIimage.data(id);
        meanDiffusion(kk,jj)=mean(diffusion_value);
        end
end

toc
%% 

header={'cingul-Post-dorsal_left','cingul-Post-ventral_left','cuneus_left','front_inf-Opercular_left','front_inf-Orbital_left','front_inf-Triangul_left','front_middle_left',.....
    'front_sup_left_gyrus','Ins_land_S_cent_ins_left','insular_short_left','occipital_middle_left','occipital_sup_left','oc-temp_lat-fusifor_left','oc-temp_med-Lingual_left', ....
    'oc-temp_med-Parahip_left','orbital_left','pariet_inf-Angular_left','pariet_inf-Supramar_left','parietal_sup_left','postcentral_left_gyrus','precentral_left',.....
    'precuneus_left','rectus_left','subcallosal_left','temp_sup-T_transv_left','temp_sup-Lateral_left','temp_sup-Plan_polar_left','temp_sup-Plan_tempo_left',.....
    'temporal_inf_left_gyrus','temporal_middle_left','subparietal_left','temporal_inf_left','temporal_sup_left','Lat_Fis-ant-Horizont_left','Lat_Fis-ant-Vertical_left',.....
    'Lat_Fis-post_left','calcarine_left','central_left','cingul-Marginalis_left','circular_insula_ant_left','circular_insula_inf_left','circular_insula_sup_left',.....
    'collat_transv_ant_left','collat_transv_post_left','front_inf_left','front_middle_left_sulcus','front_sup_left','interm_prim-Jensen_left','intrapariet_and_P_trans_left',.....
    'oc_middle_and_Lunatus_left','oc_sup_and_transversal_left','occipital_ant_left','oc-temp_lat_left','oc-temp_med_and_Lingual_left','orbital_lateral_left', .....
    'orbital_med-olfact_left','orbital-H_Shaped_left','parieto_occipital_left','pericallosal_left','postcentral_left','precentral-inf-part_left','precentral-sup-part_left',.....
    'suborbital_left','cingul-Post-dorsal_right','cingul-Post-ventral_right','cuneus_right','front_inf-Opercular_right','front_inf-Orbital_right','front_inf-Triangul_right',....
    'front_middle_right','front_sup_right','Ins_land_S_cent_ins_right','insular_short_right','occipital_middle_right','occipital_sup_right','oc-temp_lat-fusifor_right',.....
    'oc-temp_med-Lingual_right','oc-temp_med-Parahip_right','orbital_right','pariet_inf-Angular_right','pariet_inf-Supramar_right','parietal_sup_right','postcentral_right',...
    'precentral_right','precuneus_right','rectus_right','subcallosal_right','temp_sup-T_transv_right','temp_sup-Lateral_right','temp_sup-Plan_polar_right','temp_sup-Plan_tempo_right',....
    'temporal_inf_right_gyrus','temporal_middle_right','subparietal_right','temporal_inf_right','temporal_sup_right','Lat_Fis-ant-Horizont_right','Lat_Fis-ant-Vertical_right', .....
    'Lat_Fis-post_right','calcarine_right','central_right','cingul-Marginalis_right','circular_insula_ant_right','circular_insula_inf_right','circular_insula_sup_right',.....
    'collat_transv_ant_right','collat_transv_post_right','front_inf_right_sulcus','front_middle_right_sulcus','front_sup_right_sulcus','interm_prim-Jensen_right_sulcus','intrapariet_and_P_trans_right', ..... 
    'oc_middle_and_Lunatus_right','oc_sup_and_transversal_right','occipital_ant_right','oc-temp_lat_right','oc-temp_med_and_Lingual_right','orbital_lateral_right','orbital_med-olfact_right',.....
    'orbital-H_Shaped_right','parieto_occipital_right','pericallosal_right','postcentral_right_sulcus','precentral-inf-part_right','precentral-sup-part_right','suborbital_right'};


ds=dataset({meanDiffusion, header{:}});

export(ds, 'file', 'Sulcus_gyrus_boundaries_FW.csv');
