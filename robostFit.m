
filename='/rfanfs/pnl-zorro/home/sarina/neonate/Neonate_1/diff/upsampledFA/results/FA.csv'

Data=importdata(filename);
G=findgroups(Data.data(1,:)

Space=zeros(13,1)
N=numel(Data.colheaders)
for i= 10:N
    j=i-10+1:9
    %[b,stats] = robustfit(Data.data(j,:),Data.data(10,:))
    m=varfun(fitlm(Data.data(j,:), Data.data(i,:),'RobustOpts','on'))
    s=anova(m,'summary')
    space(j, 1)=s.pValue(2)
end
