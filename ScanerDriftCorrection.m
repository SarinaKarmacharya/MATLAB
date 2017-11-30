

addpath /rfanfs/pnl-zorro/software/
input_file_path = ('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/scannerDrift/dwi-Ed.nhdr');
dice_path = ('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/scannerDrift/tmp');
% system(['unu dice -i ' ' ' input_file_path ' ' ' -a 3 ' ' ' '-o tmp/Diffusion-G'])

    dwi = loadNrrdStructure(input_file_path);
    % cd tmp
    files = dir('*.nrrd');
    bval = zeros(size(dwi.gradients, 1),1);
    N=length(files);
    MeanSignalIntensity=zeros(size(dwi.gradients, 1),1);
    MeanSignalIntensity_withGradients=zeros(size(dwi.gradients, 1),1);
  
    for j=1:N
        
        nrrdFile = fullfile(files(j).name);
        niiFile = fullfile( strrep(files(j).name,'nrrd','nii.gz'));
        matrixFile = fullfile(strrep(files(j).name,'nrrd','txt'));
        % system(['ConvertBetweenFileFormats ' ' ' nrrdFile ' ' niiFile ]);
        CaseName{j} =sprintf(files(j).name);
    
        bval(j) = dwi.bvalue * norm(dwi.gradients(j,:), 2)^2;
    
    if (bval(j)==0)
         b0=nrrdLoad(CaseName{j});
         im=nrrdLoad('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/tensor_mask.nrrd');
         id=find(im==1);
         % MeanSignalIntensity(j)=mean(b0(:));
         MeanSignalIntensity(j,1)=mean(b0(id));
         MeanSignalIntensity_withGradients(j,1)=mean(b0(id));
         
    else
        
        MeanSignalIntensity(j,1)=NaN;
        gradient=nrrdLoad(CaseName{j});
        im=nrrdLoad('/rfanfs/pnl-zorro/Collaborators/CMA/DICOM/fDTI_50mins_R2/tensor_mask.nrrd');
        id2=find(im==1);
        MeanSignalIntensity_withGradients(j,1)=mean(gradient(id2));
       
    end
    
    end
        
    % LINEAR LEAST SQUARE FIT

    
    load  bo_intensity;
    
    x(1)=1
    x(2)=2
    x(3)=15
    
    for i=4:117
        x(i)=x(i-1)+13
    end
    
    x=x'
    
        MeanSignalIntensity=bo_intensity(:,1);
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
        plot(x, y, 'r.', x, polyval(m, x));
        plot(x, y2)
        
   MaxValue=max(y2) 
   load gradient_intensity;
   MeanSignalIntensity_withGradients=gradient_intensity;
   x1=(1:length(MeanSignalIntensity_withGradients))';
   
   y3 =m*x1 + b;
   
   MaxValue=max(y3);
   
   difference_values=zeros(size(x1));
   
   for i =1:length(x1)
       
        difference_values(i)= MaxValue-y3(i);
    
   end
    
    x=(MeanSignalIntensity(:))
    
    x= (1:N)'

    plot(MeanSignalIntensity(~isnan(MeanSignalIntensity)));
    
    
  
    
    
