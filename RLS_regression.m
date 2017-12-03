group={'Ctrl','Play'};
s=numel(group);

for po=1:s

BrainArea={'ACG', 'PCG', 'LTEMP', 'PWM'};
H=numel(BrainArea);

    for op =1:H
        
    % to change the raw data change the folder path in the filename
    
    filename=['RawData/MRSData_Met_FW_Mask_' BrainArea{op} '_' group{po} '.csv'];
    Data=readtable(filename);

    Metabolite={['Met_' BrainArea{op} '_cr_pcrf'],['Met_' BrainArea{op} '_glu_glnf'],['Met_' BrainArea{op} '_gluf'],['Met_' BrainArea{op} '_gpc_pchf'],['Met_' BrainArea{op} '_gshf'],['Met_' BrainArea{op}  '_insf'],['Met_' BrainArea{op} '_naa_naagf']};
    N=numel(Metabolite);

    Diffusion={['FW_' BrainArea{op} '_Mask'],['FW_' BrainArea{op} '_Mask_TCor_axial'],['FW_' BrainArea{op} '_Mask_TCor_FA'],['FW_' BrainArea{op} '_Mask_TCor_radial'],['FW_' BrainArea{op} '_Mask_TCor_trace']};
    n=numel(Diffusion);

    pvalues=zeros(N, n);
    t = zeros(N, n);
    corr=zeros(N, n);

        for i= 1:N

            for j=1:n

                    FW=Diffusion{j};
                    Met=Metabolite{i};
                    naa=['Met_' BrainArea{op} '_naa_naagf'];
                    naa_name=['Met_' BrainArea{op} '_naa__naagf'];
                    tbl = table(Data.Age,  Data.(Met), Data.(naa), Data.(FW),'VariableNames',{'Age', Met, naa_name, FW});
                    %tbl = table(  Data.(Met),  Data.(FW),'VariableNames',{ Met, FW});
                    m=fitlm(tbl,'linear','RobustOpts','on');
                    pvalues(i, j)=[(m.Coefficients.pValue(2))];
                    t(i,j) =m.Coefficients.tStat(2);
                    
%                     K=anova(m,'summary');
%                     DF=K.DF(3);
%                     RSquared = (t^2/(t^2 + DF))
%                     CorrCoeff=sqrt(RSquared)*sign(t)
                    
%                     [B,C]=robustfit(Data.(Met), Data.(FW))
%                     corr(Data.(FW),B(1)+B(2)*Data.(Met))^2
%                     sse = C.dfe * C.robust_s^2
                    

%                 if ((m.Coefficients.Estimate(2))<0)    
%                     p=[abs(RSquared)];
%                     p=sqrt(p);
%                     p=p*-1;
%                     corr(i, j)=p;
%                 else
%                     corr(i, j)=[sqrt(RSquared)];
%                 end
%                 
%                 if(m.Rsquared.Adjusted<0)
%                     h= m.Rsquared.Ordinary;
%                     disp(FW);disp(Met);
%                     disp(['the value is negative and it is : ' ])
%                     disp(h);
%                 else
%                     disp(['it is positive'])
%                 end

           end
          
        end
        Metabolite=(Metabolite');
        PvalueTable=[Metabolite,num2cell(pvalues)];
        
        header={'test', ['FW_' BrainArea{op} '_Mask'],['FW_' BrainArea{op} '_Mask_TCor_axial'],['FW_' BrainArea{op} '_Mask_TCor_FA'],['FW_' BrainArea{op} '_Mask_TCor_radial'],['FW_' BrainArea{op} '_Mask_TCor_trace']};
        PvalueExportName=dataset({ PvalueTable, header{:}});
        
        % to change the export path change the path in exportname and fileName_coeff
        
        exportname=['FinalResults/WithNAA_AGE_Covariance/Data_Met_FW_Mask_' BrainArea{op} '_' group{po} '_Pvalue-NAA-Age_cov.csv'];

        export(PvalueExportName,'file',exportname,'Delimiter','comma');

 

        coeffTable=[Metabolite,num2cell(t)];

        coeff=dataset({coeffTable, header{:}});

        fileName_coeff=['FinalResults/WithNAA_AGE_Covariance/Data_Met_FW_Mask_' BrainArea{op} '_' group{po} '_tstat-NAA-Age_cov.csv'];

        export(coeff,'file',fileName_coeff,'Delimiter','comma');

    end
end





