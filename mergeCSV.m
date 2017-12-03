 
cd /rfanfs/pnl-zorro/Collaborators/Petra/raw_data/wmql_def/ALL_tracts/RESULTS/
files = dir('*.csv');  % Get list of files
out= readtable(files(1).name);  % First file
kup= horzcat(out(:,1), out(:,9), out(:,14), out(:,22), out(:,26), out(:,34));

 for i = 2:numel(files)
     
      new = readtable(files(i).name); 

      [row columns]=size(new);
  
      Brain_Area=char(files(i).name);
      
      Brain=Brain_Area(1:end-4);
      
      Brain=strrep(Brain, '.','_');
      
      
if (row == 88)
      HeaderName= new.Properties.VariableNames;
      
      N=numel(HeaderName);
      
      [row columns]=size(new);
      
      
      store=zeros(1,N);
      
      for k=1:N
          
          name=char(HeaderName(k));
          
          HeaderName(k)=cellstr(([name '_' Brain]));
          
          %store(:,k)=sprintf(newName);
          
      end
      
      new.Properties.VariableNames=HeaderName;
      
      
      kup= horzcat(kup, new(:,1), new(:,9), new(:,14), new(:,22), new(:,26), new(:,34));
  else
      disp(['the row does not match   '  Brain ' '  num2cell(row)])

end
  
 end
 
 writetable(kup,'/rfanfs/pnl-zorro/Collaborators/Petra/raw_data/wmql_def/ALL_tracts/All_Data.csv','Delimiter',',','QuoteStrings',true)
