cd  /rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2
addpath /rfanfs/pnl-zorro/software/
input_file_path=('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/scannerDrift/dwi-Ed-drift_corrected.nhdr');
dice_path=('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/tmp');
%system(['unu dice -i ' ' ' j ' ' ' 3 ' ' ' '-o tmp/dwi'])



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
    x(1)=1;
    x(2)=2;
    x(3)=14;
    
    for i=4:117;
        x(i)=x(i-1)+13;
    end
    
    x=x';    
        y= MeanSignalIntensity(~isnan(MeanSignalIntensity));
        %x= (1:length(y))'
        n=numel(y)
        sumxi=sum(x)
        sumyi=sum(y)
        sumxiyi=sum(x.*y)
        sumxi2=sum(x.^2)
        sumyi2=sum(y.^2)
        
        m= (sumxi* sumyi - n*sumxiyi)/ (sumxi^2 -n*sumxi2)
        b= (sumxiyi * sumxi -sumyi *sumxi2 )/ (sumxi^2 -n *sumxi2)
        
        y2 =m*x + b
        %plot(x, y, 'r.', x, polyval(m, x));
        plot(x, y2)
        scatter(x,y)
        


    plot(MeanSignalIntensity(~isnan(MeanSignalIntensity)));
    