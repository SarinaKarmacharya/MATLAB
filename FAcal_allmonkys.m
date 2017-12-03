cd /projects/schiz/Monkey_Aging/atlas_files/
im= nrrdZipLoad('MGH_WM_Atlas_In_TemplateSpace_nonlinearReg.nrrd');%mgh
%im=nrrdZipLoad('WM_Atlas_In_TemplateSpace_nonlinearReg.nrrd'); %bu
%cd
cd /rfanfs/pnl-a/pnl/Collaborators/CMA/georgep/MONKEY-FreeWater/alldata/BAMBAM/template/ %MGH
%cd /projects/schiz/Monkey_Aging/data/JACKSON/template/ %bu%
FA=nrrdZipLoad('BAMBAM.faintemplate.nrrd');
%FA=nrrdZipLoad('GABBY.fatintemplate.nrrd');
FA=nrrdZipLoad('GABBY.fwintemplate.nrrd');
header ={'alic','CB', 'SLF-II-FAF', 'AC', 'CC', 'SLF_III', 'PLIC', 'AF'}

%fw=zeros(2,8);
%image_num= {87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57} %BAMBAM

image_num ={90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70} %GABBY 
%image_num ={131,132,133,134,135,136,137,138,139,140,141,142}; %penelope
%image_num ={133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150} %Jackson
%image_num ={128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145} %PIE%
%image_num ={87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69} %NATHAN

figure(1); imagesc(squeeze(FA(:,131,:)));% to view the images
figure(2); imagesc(squeeze(im(:,:,57))); %to view a label map

%im2=im(:, :, image_num);
%FA2=FA(:,:,image_num);
s = length(image_num);
s=1:146;
k=cell2mat(image_num);
fw=zeros(s,8);

for i=min(k):max(k)
 
im2=im(:, :, i);
FA2=FA(:,:, i);
    %for i=1:31
   
id=find(im2 == 36); %Alic
fw(i,1)=mean(FA2(id));
id2=find(im2 == 4); %CB
fw(i,2)=mean(FA2(id2));
id3=find(im2==20); %SLF-II-FAF
fw(i,3)=mean(FA2(id3));
id4=find(im2 ==40); %AC
fw(i,4)=mean(FA2(id4));
id5=find(im2 == 24); % CC
fw(i,5)=mean(FA2(id5));
id6=find(im2 == 12); %SLF III
fw(i,6)=mean(FA2(id6));
id7=find(im2==32); %PLIC
fw(i,7)=mean(FA2(id7));
id8=find(im2==2);%AF
fw(i,8)=mean(FA2(id8));

end
%cd /rfanfs/pnl-zorro/home/sarina/Histology/296/
ds=dataset({fw, header{:}});
export(ds, 'file', 'GABBY_FW.xls')



