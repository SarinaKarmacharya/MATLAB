function check_Bvalue(filename, directory)

name=filename
directory_path=directory

input_file_path=fullfile(directory_path, name)

dwi = loadNrrdStructure(input_file_path);
bval = zeros(size(dwi.gradients, 1),1);
N=length(bval);

for j =1:N
     bval(j) = dwi.bvalue * norm(dwi.gradients(j,:), 2)^2;
     if (bval(j)==0)
         disp(['B0 file']);
         bvalue=num2str(bval(j));
         disp(bvalue);
        
     else
        disp(['Gradient Direction'])
        bvalue_1=num2str(bval(j));
        disp(bvalue_1);
     end
end
