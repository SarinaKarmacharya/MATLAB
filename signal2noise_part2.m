
bval=round(bval);
num_bval=length(unique(bval));
bvalues=unique(bval);
store=zeros(N,2);
g=zeros(N,num_bval)
index=zeros(N,num_bval);
for k=1:num_bval
    l=find(bval==bvalues(k,:));
    index=l(:);
end

for i =1:N
    for k=1:num_bval
    bval=dwi.bvalue*norm(dwi.gradients(i, :),2)^2;
    bval=round(bval);
    store(i,1)=bval;
    %if isequal(bvalues(k,:), bval);
        data_bval=dwi.data(:,:,:,i);
        data_bval=double(data_bval);
        store(i,2)=std(data_bval(:));
    %end
    end
end

       %[truefalse index]= ismember(bvalues,bval(1))
       %bvalues(index)
        
       
%figure(2)
%hold on 
%subplot(1,2,ii)