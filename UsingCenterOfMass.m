
subject=load('/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/caselist.txt');
N=numel(subject);
minDistance_right=zeros(N,1);
%% right hemi
for i =1:N
    
name=num2str(subject(i));
GPname=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/STN_GP_ATLAS_in_DWI_SPACE/' name '_STN_dwispace.nii']);
FaceLabel=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/Face_motor_VTK_to_labelmap_right_nii/' name '_labelmap_right.nii']);
minDistance_right(i,1)=centerOfMass_GP(FaceLabel,GPname,'right');

end
%% left hemi
minDistance_left=zeros(N,1);
for i =1:N
    
name=num2str(subject(i));
GPname=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/STN_GP_ATLAS_in_DWI_SPACE/' name '_STN_dwispace.nii']);
FaceLabel=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/Face_motor_VTK_to_labelmap_left_nii/' name '_labelmap_left.nii']);
minDistance_left(i,1)=centerOfMass_GP(FaceLabel,GPname,'left');


end

% header={'subject', 'MinDistance_right_GP'};
% 
% ds=dataset({minDistance, header{:}});
% export(ds, 'file', 'Minimum_Distance_right_GP.csv');
%% stem plot

x=[minDistance_right, minDistance_left];% first right and left
xx=find(minDistance_right>=0);

figure(2),stem(xx,x, 'filled')
title(['Minimum Distance using center of mass between GP and FaceMotor Cortex '],....
    'fontsize', 18, 'fontweight', 'bold')
xlabel('Subjects 1:21','fontsize', 20, 'fontweight','bold');
ylabel('Distance in mm', 'fontsize',20,'fontweight','bold');
legend({'Right Hemisphere', 'Left Hemisphere'},'fontsize', 12,'location','northeast');
%  
%% histogram of the right hemi
x_r=x(:,1);
 hist(x_r)
 title(['Histogram: Using Center of Mass: Right Hemisphere  '],....
    'fontsize', 18, 'fontweight', 'bold')
xlabel('Distance of the FaceMotor with the Globus Pallidus','fontsize', 20, 'fontweight','bold');
ylabel('Number of Subjects', 'fontsize',20,'fontweight','bold');
 
%% histogram of the left hemi
x_l=x(:,2);
hist(x_l)
 title(['Histogram: Using Center of Mass Left Hemisphere  '],....
    'fontsize', 18, 'fontweight', 'bold')
xlabel('Distance of the FaceMotor with the Globus Pallidus','fontsize', 20, 'fontweight','bold');
ylabel('Number of Subjects', 'fontsize',20,'fontweight','bold');

mean_right=mean(x_r)
mean_left=mean(x_l)
sd_right=std(x_r)
sd_left=std(x_l)
 