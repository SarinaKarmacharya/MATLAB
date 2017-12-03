caselist=('/rfanfs/pnl-zorro/Collaborators/Petra/raw_data/conn_matrices/caselist.txt')
CaseList=textread(caselist, '%s');
N=numel(CaseList);

tic
for i=1:N
    
    Bse=('/rfanfs/pnl-zorro/Collaborators/Petra/raw_data/conn_matrices/');
    m=load([Bse, CaseList{i} '_connmat_Finsler.txt']);
    x=26;y=26;
    newmatrix=zeros(x, y);
    
    mat=[ 1 7 14 15 17 18 19 23 28 29 30 33 34 35 41 48 49 51 52 53 57 62 63 64 67 68];
    mat2=mat';
    
    n=numel(mat);
    for ii =1:n
       num=mat2(ii);
        for u=1:n
        
        hj=mat(u);
        newmatrix(ii,u)=m(num,hj);
        FinalResult=dataset(newmatrix(:,:));
        
        save([CaseList{i} '_connmat_Finsler_graph.mat'], 'newmatrix');
    end
    end
    
    

end
toc










