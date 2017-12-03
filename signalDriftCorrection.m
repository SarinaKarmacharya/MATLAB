function signalDriftCorrection(file_path, data, output_name)

addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/ %% to open nii MRIread
addpath /rfanfs/pnl-zorro/software/SignalDropQCTool/nrrdFunctions/ %% this nrrd loadNrrdStructure

path=file_path;
dwi_data=data;

input_file_path=(filepath, data);

dwi = loadNrrdStructure(input_file_path);

bval = zeros(size(dwi.gradients, 1),1);
N=length(bval);

MeanSignalIntensity=zeros(size(dwi.gradients, 1),1);
MeanSignalIntensity_withGradients=zeros(size(dwi.gradients, 1),1);

for j=1:N
    
    bval(j) = dwi.bvalue * norm(dwi.gradients(j,:), 2)^2;
  
    if (bval(j)==0)
         data=dwi.data(:, :, :, j);
         MeanSignalIntensity(j,1)=mean(data(:));
         MeanSignalIntensity_withGradients(j,1)=mean(data(:));
    else
        data_with_gradients=dwi.data(:, :, :, j);
        MeanSignalIntensity(j,1)=NaN;
        MeanSignalIntensity_withGradients(j,1)=mean(data_with_gradients(:));
    end
end
    maxvalue=nanmax(MeanSignalIntensity);
    y= MeanSignalIntensity;
    
    difference =maxvalue-y;
    
    difference=round(difference);
    
    for j=1:N
        
        if (bval(j)==0)
             
        corrected_file = [(dwi.data(:, :, :, j)+difference(j))];
       
        dwi.data(:,:,:,j)=corrected_file;
        
        
        end
     
    end
    plot(corrected_file)
    
    mat2DWInhdr(output_name, '/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/scannerDrift/', dwi, 'uint16');
