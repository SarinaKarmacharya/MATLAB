caselist=('/rfanfs/pnl-zorro/Collaborators/Petra/raw_data/conn_matrices/caselist.txt')
CaseList=textread(caselist, '%s');
N=numel(CaseList);

Space=zeros(N,16);

for i=1:N
    
    Bse=('/rfanfs/pnl-zorro/Collaborators/Petra/raw_data/conn_matrices/');
    m=load([Bse, CaseList{i} '_connmat_Finsler.txt'])
    
% inferior parietal left and right
Space(i,1)=m(7,41);
% % % %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%parsopercularis left OR pars triangularis left OR pars orbitalis left AND
%pars opercularis right OR pars triangularis right OR parsorbitalis right

Space(i,2)=(m(17,51)+m(17,52)+m(17,53)+m(18,51)+m(18,52)+m(18,53)+m(19,51)+m(19,52)+m(19,53))/9;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% left: orbitalfrontal OR pars orbitalis OR pars triangularis OR
% parsopercularis AND temporal lobe

Space(i,3)=(m(11,32)+m(19,32)+m(18,32)+m(17,32))/4;


% RIGHT: orbitalfrontal OR pars orbitalis OR pars triangularis OR
% parsopercularis AND temporal lobe


Space(i,4)=(m(45,66)+m(53,66)+m(52,66)+m(51,66))/4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% left: lateral occipital OR inferior parietal OR supra marginal AND caudal
% middle frontal OR rostral middle frontal

Space(i,5)=(m(10,3)+m(10,26)+m(7,3)+m(7,26)+m(30,3)+m(30,26))/6;

% RIGHT: lateral occipital OR inferior parietal OR supra marginal AND caudal
% middle frontal OR rostral middle frontal

Space(i,6)=(m(44,37)+m(44,60)+m(41,37)+m(41,60)+m(64,37)+m(64,60))/6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left: Lateral occipital OR inferior parietal OR supramarginal AND pars
%orbitalis OR pars triangularis OR pars opercularis

Space(i,7)=(m(10,19)+m(10,18)+m(10,17)+m(7,19)+m(7,18)+m(7,17)+m(30,19)+m(30,18)+m(30,17))/9;

%RIGHT: Lateral occipital OR inferior parietal OR supramarginal AND pars
%orbitalis OR pars triangularis OR pars opercularis

Space(i,8)=(m(44,53)+m(44,52)+m(44,51)+m(41,53)+m(41,52)+m(41,51)+m(64,53)+m(64,52)+m(64,51))/9;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left: pars orbitalis OR pars triangulairs OR parsopercularis OR caudal
%middle frontal OR rostral middle frontal OR precentral AND superior
%temporal OR middle temporal

Space(i,9)=(m(19,29)+m(18,29)+m(17,29)+m(3,29)+m(26,29)+m(23,29)+m(19,14)+m(18,14)+m(17,14)+m(3,24)+m(26+14)+m(23,14))/12;

%RIGHT: pars orbitalis OR pars triangulairs OR parsopercularis OR caudal
%middle frontal OR rostral middle frontal OR precentral AND superior
%temporal OR middle temporal

Space(i,10)=(m(53,63)+m(52,63)+m(51,63)+m(37,63)+m(60,63)+m(57,63)+m(53,48)+m(52,48)+m(51,48)+m(37,48)+m(60,48)+m(57,48))/12;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Left pars opercularis OR pars triangularis AND superior frontal
Space(i,11)=(m(17,27)+m(19,27))/2;

%RIGHT pars opercularis OR pars triangularis AND superior frontal
Space(i,12)=(m(51,61)+m(53,61))/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left: parstriangularis AND inferior parietal OR supramarginal
Space(i,13)=(m(19,7)+m(19,30))/2;

%RIGHT: parstriangularis AND inferior parietal OR supramarginal

Space(i,14)=(m(53,41)+m(53,64))/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%left: pars triangularis AND superior temporal OR bankssuperiortemporal OR
%middle temporal OR inferior temporal

Space(i,15)=(m(19,29)+m(19,1)+m(19,14)+m(19,8))/4;

%Right: pars triangularis AND superior temporal OR bankssuperiortemporal OR
%middle temporal OR inferior temporal
Space(i,16)=(m(53,63)+m(53,35)+m(53,48)+m(53,42))/4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

data=[CaseList,num2cell(Space)]
header={'caselist','tract1','tract2','tract3','tract4','tract5','tract6','tract7','tract8','tract9','tract10','tract11','tract12','tract13','tract14','tract15','tract16'};
FinalResult=dataset({data,header{:}});
exportname=([Bse,'ConnMat_Finsler_Final_output.csv'])
export(FinalResult,'file',exportname,'Delimiter','comma')










