FileName=textread('/rfanfs/pnl-zorro/projects/ADHD/CaseList.txt', '%s');
N=numel(FileName);
%%
bse='/rfanfs/pnl-zorro/projects/ADHD/';
for i =1:N
    File_path=fullfile([bse, FileName{i} '/diff/Preprocessed_step_files/'])

    
    archive_path=fullfile([bse FileName{i}  '/diff/archive_preprocess.tar.gz'])
    cd ([bse FileName{i} '/diff/'])

    
    diffName='dwi-Aligned-Ed-Bet-Merged-Epi.nhdr';
    diffraw='dwi-Aligned-Ed-Bet-Merged-Epi.raw';
    diffMask='reference_b0_mask.nrrd';
    
        allFiles = dir( [bse '/diff' ]);
        n=length(allFiles);
        Name=zeros(n,1)
       for j=4:n
           
          system(['mv '  allFiles(j).name ' ' File_path]);
       end 
       
       if (exist(diffName) && exist(diffraw) && exist(diffMask))
           system(['cp ' diffName ' ' bse '/diff/']);
           system(['cp ' diffraw ' ' bse '/diff/']);
           system(['cp ' diffMask ' ' bse '/diff/']);
       else 
            disp(['its not there' ' ' allFiles(j).name]);
            
       end
       
     if (~exist(archive_path)) || (recreate ==1)
         command = ['tar -C ' File_path ' -cf ' archive_path ' .'];
         system(['rm -r Preprocessed_step_files'])
     else
         disp([' there is already a file']);
     end
     
end
