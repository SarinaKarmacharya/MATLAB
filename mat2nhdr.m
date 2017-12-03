

FileName=textread('/rfanfs/pnl-zorro/projects/ADHD/caselist.txt', '%s');
N=length(FileName);

for i=1:N

mkdir (['/rfanfs/pnl-zorro/projects/ADHD/MultiGaussian_NoV2016/all_files/' FileName{i}]);
InputFile=(['/rfanfs/pnl-zorro/projects/ADHD/MultiGaussian_NoV2016/finalmat/' FileName{i} '_stat.mat']);
ExportName=(['/rfanfs/pnl-zorro/projects/ADHD/MultiGaussian_NoV2016/all_files/' FileName{i} '/' FileName{i}]);
%if exist(['/rfanfs/pnl-zorro/projects/ADHD/' FileName{8} '/diff/reference_b0_mask.nrrd'])
mask_name=(['/rfanfs/pnl-zorro/projects/ADHD/' FileName{i} '/diff/reference_b0_mask.nrrd']);
%else
    
MultiGaussian_Mat2Nhdr(InputFile,ExportName,mask_name);

end