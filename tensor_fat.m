
clear
addpath /projects/schiz/software/Matlab/nrrdUtilities/
addpath /rfanfs/pnl-zorro/software/
addpath /projects/schiz/pi/lipeng/matlab/routines/toolbox_matlab_nifti/
addpath /rfanfs/pnl-zorro/software/SignalDropQCTool/nrrdFunctions/

bse_label='/projects/schiz/NFL/freesurfer_processed/destrieux_labelmaps2DWI/'
cd(bse_label);
LabelDir=dir('01*');
Subjects=numel(LabelDir);
tic
bse_fw='/projects/schiz/NFL/FW';
bse='/projects/schiz/NFL/Heterogeneity/FW_mat/'

%% 
label=[11109,11110];
  l=numel(label);
  %% 
    meanFa=zeros(Subjects,l);
    meantrace=zeros(Subjects,l);
    meanAD=zeros(Subjects,l);
    meanRD=zeros(Subjects,l);

for kk=1:Subjects
    sub_name=LabelDir(kk).name
    fn = sprintf([bse, sub_name  '_FW.mat']);
        load(fn);
        
        dti = 1e-3*squeeze(D);
        clear D;
        fw = 1-squeeze(f);        
        clear f;
        labelmap=(['/projects/schiz/NFL/freesurfer_processed/destrieux_labelmaps2DWI/' sub_name '/boundary_sulcus_gyrus_label.nhdr']);
        gm=nrrdZipLoad(labelmap);   
 
    for jj=1:numel(label)
      id =  find(gm == label(jj));
        
      [n, nx, ny, nz] = size(dti);
      dti=reshape(dti,[n nx*ny*nz]);
      T = reshape(dti([1 4 5 4 2 6 5 6 3], id), 3, 3, []);
      %fw = fw(id);

        [~, ~, N] = size(T);
        E = zeros(4,N);

        for j = 1:N
         if any(isnan(T(:,:,j))) 
             continue; 
         end
         t = squeeze(T(:,:,j));
         T_ = trace(t)/3; % trace = sum of diagonal values
         
         % A=[2,-4;-1,-2] | ||A||=[2^2+(-1)^2+(-4)^2+(-2)2]^1/2=5

         if norm(t,'fro') > 1e-6 % ||A||F=sqrt(m sum i=1(n sum j=1 |Aij|^2)) ; sqrt(trace(A*A) % Forbenius Norm of matrix
           fa = sqrt(3/2) * norm((t - T_*eye(3)),'fro') / norm(t,'fro'); %% eye is a identity matrix with 1 as diagonal, fro is Frobenius method 
         else
           fa = 0;
         end
     
         [S, tmp] = eigs(t);   
         
         % eigs is a subset of EigenValues and EigenVectors; returns a vector of the six largest magnitude eigenvalues of matrix t.
         % tmp is the diagonal matrix containing the eigenvalues on the main diagonal;
         % s is the matrix whose columns are the corresponding eigenvectors
         
         tmp(tmp<1e-4)=1e-4;

         %fa,trace,ad,rd,
         E(:,j) = [fa;T_;tmp(1,1); .5*(tmp(2,2)+tmp(3,3))];
       
         meanFa(kk,jj)=mean(E(1,:));
         meantrace(kk, jj)=mean(E(2,:));
         meanAD(kk,jj)=mean(E(3,:));
         meanRD(kk,jj)=mean(E(4,:));
         clear id
    end
 end
end
%% 


header={'cingul-Post-dorsal_left','cingul-Post-ventral_left'}

FA=dataset({meanFa, header{:}});
trace=dataset({meantrace, header{:}});
AD=dataset({meanAD, header{:}});
RD=dataset({meanRD, header{:}});
export(FA, 'file', 'Sulcus_gyrus_boundaries_FA.csv');
export(trace, 'file', 'Sulcus_gyrus_boundaries_trace.csv');
export(AD, 'file', 'Sulcus_gyrus_boundaries_AD.csv');
export(RD, 'file', 'Sulcus_gyrus_boundaries_RD.csv');    
