addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
addpath /rfanfs/pnl-zorro/software/

input_file_path='/rfanfs/pnl-zorro/home/sarina/keystone/ep2d_diff_SliceAcc_connectome_cplx_run1/dwi_run1.nhdr';
input_mask_path='/rfanfs/pnl-zorro/home/sarina/keystone/ep2d_diff_SliceAcc_connectome_cplx_run1/tmp/dwi-signal-bet_mask.nhdr';
figure(1); clf reset; set(gcf,'units','normalized','position',[0 0 1 1]);
figure(2); clf reset; set(gcf,'units','normalized','position',[0 0 1 1])
[pathstr,name,ext]=fileparts(input_file_path);
[maskpathstr,maskname,maskext]=fileparts(input_mask_path);
%% 
if isequal(maskext, '.nii.gz') && isequal(ext, '.nii.gz')
    dwi=MRIread(input_file_path);
    mask=MRIread(input_mask_path);
else
    dwi=loadNrrdStructure(input_file_path);
    mask=loadNrrdStructure(input_mask_path);
end
%% 

bval = zeros(size(dwi.gradients, 1),1);
[nx ny nz nt]=size(dwi.data);

N=length(bval);

for j =1:N
    bval(j) = dwi.bvalue * norm(dwi.gradients(j,:), 2);
end

bval=round(bval);

std_signal=zeros(nt,1);
std_noise=zeros(nt, 1);
signal_to_noise=zeros(nt,1);

mask_data=mask.data;
se = strel('disk',8);
mask_data = imdilate(mask_data,se);
%% 
for i =1:N
    
signal=dwi.data(:,:,:,i);
signal=signal(mask.data==1);
signal=double(signal);
std_signal(i,:)=std(signal(:));


noise=dwi.data(:,:,:,i);
noise=noise(mask_data~=1);
noise=double(noise);
std_noise(i,:)=std(noise(:));

signal_to_noise(i,:)=std(signal(:))/std(noise(:));
end

%for i =1:nz
    %figure(3), imagesc(mask_data(:,:,i)); pause(0.1);
%end
%for x=1:nz
    %figure(4),imagesc(squeeze(dwi.data(:,:,x,:))); pause(0.1);
%end
    
%% 
figure(1);
hold on
plot(std_signal, '-', 'color', [1 0 1],'linewidth', 2);
plot(std_noise, '--', 'color', [122 16 228]/255,'linewidth', 2);
title([' Standard Deviation of noise and signal over the number of gradients :' num2str(nt)], ...
'fontsize',20,'fontweight','bold');
legend({'Standard Deviation Signal (Brain)', 'Standard Deviation Noise (Background)'}, ...
'fontsize', 15, 'location', 'southeast');
ylabel('Standard Deviation','fontsize',18,'fontweight','bold');
xlabel('Diffusion Weighted Image: gradient number','fontsize',18,'fontweight','bold');
box off

figure(2)
hold on 
plot(signal_to_noise, '-','color', [122 17 228]/255, 'linewidth', 2);
title(['SIGNAL TO NOISE'],.....
    'fontsize',20,'fontweight','bold');
xlabel('Gradients of diffusion image','fontsize', 18, 'fontweight','bold');
ylabel('Signal to Noise', 'fontsize',18,'fontweight','bold');
legend({'Signal to noise ratio'},'fontsize', 18,'location','southeast');

box off





