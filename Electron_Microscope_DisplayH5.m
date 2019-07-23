info = hdf5info('ecs_test_pixel_half_valid_312_32_14500.h5');

%% Find the address of the image

% The operation must be done manually and the position inside the structure

% could be variable depending on the structure itself

address_data_1 = info.GroupHierarchy.Datasets(1).Name;

%% Query the database

image1 =hdf5read('ecs_test_pixel_half_valid_312_32_14500.h5',address_data_1);

%% Plot the image

figure

imagesc(image1)
[x y z]=size(image1);

for i=1:z
    
imshow(image1(:,:,i));pause(0.2)
end
