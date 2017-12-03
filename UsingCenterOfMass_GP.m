
subject=load('/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/caselist.txt');
N=numel(subject);
minDistance_right=zeros(N,2);
%% right hemi
for i =1:N
    
name=num2str(subject(i));
GPname=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/STN_GP_ATLAS_in_DWI_SPACE/' name '_STN_dwispace.nii']);
FaceLabel=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/Face_motor_VTK_to_labelmap_right_nii/' name '_labelmap_right.nii']);
minDistance_right(i,2)=centerOfMass_GP(FaceLabel,GPname,'right');
minDistance_right(i,1)=subject(i);
end

header={'subject', 'MinDistance_right_GP'};
% 
 ds=dataset({minDistance_right, header{:}});
 export(ds, 'file', 'CENTER_OF_MASS_Minimum_Distance_right_GP.csv');
%% left hemi
minDistance_left=zeros(N,2);
for i =1:N
    
name=num2str(subject(i));
GPname=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/STN_GP_ATLAS_in_DWI_SPACE/' name '_STN_dwispace.nii']);
FaceLabel=(['/rfanfs/pnl-zorro/home/sarina/WORKING_DIR_HCP/DISTANCE/Face_motor_VTK_to_labelmap_left_nii/' name '_labelmap_left.nii']);
minDistance_left(i,2)=centerOfMass_GP(FaceLabel,GPname,'left');
minDistance_left(i,1)=subject(i);

end

header={'subject', 'MinDistance_left_GP'};
% 
 ds=dataset({minDistance_left, header{:}});
 export(ds, 'file', 'CENTER_OF_MASS_Minimum_Distance_left_GP.csv');
%% stem plot

x=[minDistance_right, minDistance_left];% first right and left
xx=find(minDistance_right>=0);

figure(2),stem(xx,x, 'filled')
title(['Minimum Distance: Center of mass between GP and FaceMotor Cortex '],....
    'fontsize', 50, 'fontweight', 'bold')
xlabel('Subjects 1:21','fontsize', 50, 'fontweight','bold');
ylabel('Distance in mm', 'fontsize',50,'fontweight','bold');
legend({'Right Hemisphere', 'Left Hemisphere'},'fontsize', 12,'location','northeast');
%  
%% histogram of the right hemi
x_r=x(:,1);
 hist(x_r)
 title(['Histogram: Using Center of Mass Right Hemisphere  '],....
    'fontsize', 50, 'fontweight', 'bold')
xlabel('Distance of the FaceMotor with the Globus Pallidus','fontsize', 50, 'fontweight','bold');
ylabel('Number of Subjects', 'fontsize',50,'fontweight','bold');
 
%% histogram of the left hemi
x_l=x(:,2);
hist(x_l)
 title(['Histogram: Using Center of Mass Left Hemisphere  '],....
    'fontsize', 50, 'fontweight', 'bold')
xlabel('Distance of the FaceMotor with the Globus Pallidus','fontsize', 50, 'fontweight','bold');
ylabel('Number of Subjects', 'fontsize',50,'fontweight','bold');

mean_right=mean(x_r)
mean_left=mean(x_l)
sd_right=std(x_r)
sd_left=std(x_l)
 