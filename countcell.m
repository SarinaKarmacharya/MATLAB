I=imread('/Users/Karmacharya/Documents/LN3_data/181bambamrawhistolgypictures/bambam1.png');
k=imread('/Users/Karmacharya/Documents/LN3_data/histology_with_atlas/BAMBAM/BAMBAM1.png');
I=im2double(I);
[a,b,c]=size(I);
l=imresize(k, [a,b]);
figure, imshowpair(I, l, 'blend');
 %figure(1);imshow(I)
rect = getrect;
rect=fix(rect);
patch=I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
figure(2);imshow(patch)

cd /rfanfs/pnl-zorro/home/sarina/Histology/181_BAMBAM/
clear
I=imread('2.tif');
I=imread('BAMBAM/BAMBAM2.png');
I=im2double(I);
[a,b,c]=size(I);
l=imresize(k, [a,b]);
o=imshowpair(I, l, 'blend');
%h_im=imshow(I);

h=imfreehand();%this clear is manual stage. cropping the image

%automatic part
binaryImage=h.createMask();
subplot(2,3,2);
imshow(binaryImage);
%numberOfPixel1=sum(binaryImage(:));
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1};
x=xy(:, 2);
y=xy(:, 1);
subplot(2, 3, 1);
hold on;
plot(x, y, 'LineWidth', 2);
burnedImage=I;
burnedImage(binaryImage)=255;
subplot(2, 3, 3);
imshow(burnedImage);
grayImage=rgb2gray(I);
blackMaskedImage =grayImage; %turning image into black and white
blackMaskedImage(~binaryImage)=255; 
subplot(2, 3, 4);
imshow(blackMaskedImage);
%now crop the image
topLine=min(x);
bottomLine=max(x);
leftColumn = min(y);
rightColumn =max(y);
width= bottomLine -topLine + 1;
height = rightColumn -leftColumn +1;
croppedImage=imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
subplot(2, 3, 6);
imshow(croppedImage); 

%adding noise and removing noise from image
noisyImage =imnoise(croppedImage, 'gaussian',0.1, 0.01); % might have to adjust based on Image to 0.1, 0.01
filt=fspecial('gaussian', [5 5], 2);
denoiseImage=imfilter(noisyImage, filt);
%color the black

BW = im2bw(denoiseImage, 0.6); %might have to adjust based on Image
subplot(2, 3, 4);
imshow(BW);
edgeImage =edge(uint8(BW), 'sobel');
labelImage= bwlabeln(edgeImage);
subplot(2 , 3, 5);
imshow(labelImage);
rgb2=label2rgb(labelImage, 'hsv', 'k' , 'shuffle'); %labeling in color
%figure, imshow(rgb2);
blobMeasurement =regionprops(labelImage, 'all');
%edge =find(edgeImage ~= 0);
numberofBlobs= size(blobMeasurement, 1); %counts the number of cells
numberofBlobs
%to calculate area covered by a ROI
clear
cd /rfanfs/pnl-zorro/projects/Kubicki_SCZ_R01/Monkey_AM034_LN3_Scans/
I=imread('9.tif');
k=imread('atlas/nathan9.png');
[a,b,c]=size(I);
l=imresize(k, [a,b]);
o=imshowpair(I, l, 'blend');
h=imfreehand();
%count areas by pixels
binaryImage=h.createMask();
numberOfPixel1=sum(binaryImage(:));
numberOfPixel1
%h=find(binaryImage == 1);
%area=length(h);

