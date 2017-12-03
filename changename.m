files=dir('*.nii.gz');

N=length(files);

for i= 1:N
    initialName=files(i).name
    %name=files(i).name (1:3);
    newname=['E_', initialName];
    %oldnamepart=files(i).name (4:end)
    %finalNewName=[newname, oldnamepart]
    system(['mv ' '  ' initialName '  ' newname])
end

