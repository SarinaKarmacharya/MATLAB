
addpath /rfanfs/pnl-zorro/projects/ADHD/ADHD_PreProcess/

caselist='/rfanfs/pnl-zorro/projects/ADHD/rsFMRI/scripts/rsfMRI_caselist.txt';
files=textread(caselist,'%s');

%dicom_path='/rfanfs/pnl-zorro/projects/ADHD/' filename{i} '/0_2015-07-06-17-17-28/4734849-843/2014.02.12-012Y-MR_Brain_w_o_Contrast-1455/SMS3_rs_fMRI-SMS3_rs_fMRI-19132'

N = numel(files);




for i=1:N
datapath='/rfanfs/pnl-zorro/projects/ADHD/'
%Example: 0_2014-08-22-11-32-26
%%%%%%%% 1

pattern = '[0-9]_([0-9]+-)+[0-9]+'
folder_list = FindFolderFromRegex(fullfile(datapath, files{i}), pattern);
caseDir.date_folder = cell2mat(folder_list);

if (length(folder_list) < 1)
    
    pattern = '[0-9]+-[0-9]+';
    
    folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder), pattern);
    caseDir.patient_number = cell2mat(folder_list);
    
    pattern = '([0-9]+.)+[0-9]+-[0-9]+Y-[a-zA-Z_0-9]+-[0-9]+';
    
    folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number), pattern);
    
    % STep 4
    caseDir.main_folder = cell2mat(folder_list);
    
    pattern = 'MoCo.*-.*fMRI.*-[0-9]+';
    
    folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number, caseDir.main_folder), pattern);
    
    if (length(folder_list) < 1)
        pattern = '.*-.*fMRI.*-[0-9]+';
        folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number, caseDir.main_folder), pattern);
    end
    
else
    pattern = '[0-9]+-[0-9]+';
    
    folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder), pattern);
    
    caseDir.patient_number = cell2mat(folder_list);
    
    % STEP 3 => the main folder
    % Example: 2014.07.01-009Y-MR_Functional_Imaging_Non_MD_60_Min-2105
    pattern = '([0-9]+.)+[0-9]+-[0-9]+Y-[a-zA-Z_0-9]+-[0-9]+';
    
    folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number), pattern);
    
    % STep 4
    caseDir.main_folder = cell2mat(folder_list);
    
    pattern = 'MoCo.*-.*fMRI.*-[0-9]+';
    
    folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number, caseDir.main_folder), pattern);
    
    if (length(folder_list) < 1)
        pattern = '.*-.*fMRI.*-[0-9]+';
        folder_list = FindFolderFromRegex(fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number, caseDir.main_folder), pattern);
    end
end

%%%%%%%% 2



    dicom_path = fullfile(datapath, files{i}, caseDir.date_folder, caseDir.patient_number, caseDir.main_folder, cell2mat(folder_list));
    output_dir = fullfile(datapath, files{i}, '/fMRI/');
    volume_name = ['fMRI_' files{i}];

    system(['dcm2niix -z n -o ' output_dir ' -f ' volume_name ' ' dicom_path])

end
