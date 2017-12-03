clear
I=imread('4.tif');
%k=imread('Nathan4.png');
%[a,b,c]=size(I);
%l=imresize(k, [a,b]);
%o=imshowpair(I, l, 'blend');
%h_im=imshow(I);
figure(1), imagesc(I)

%next step

h=imfreehand();  %this clear is manual stage. cropping the image

%automatic part
binaryImage=h.createMask();
%numberOfPixel1=sum(binaryImage(:));
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1};
x=xy(:, 2);
y=xy(:, 1);
hold on;
%formula to calculate luminance 0.299 * R + 0.587 * G + 0.114 *
grayImage1=rgb2gray(I);
j=imnoise(grayImage1, 'salt & pepper',0.03);
grayImage=medfilt2(j);
blackMaskedImage =double(grayImage); %turning image into black and white
blackMaskedImage(~binaryImage)=nan; 
blackMaskedImage(blackMaskedImage==0)=nan;
%now crop the image
topLine=min(x);
bottomLine=max(x);
leftColumn = min(y);
rightColumn =max(y);
width= bottomLine -topLine + 1;
height = rightColumn -leftColumn +1;
croppedImage=imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
 
% find minimum intensity
minIntensity=nanmin(croppedImage(:));
% find mean intensity 
meanIntensity=nanmean(croppedImage(:));
% max intensuty
maxIntensity=nanmax(croppedImage(:));
% calculating the optical density:

%beer-Lambert law Optical Density =A/L
%I=Ioe-acx
%optical density formula =-log(It/Io)

opticalDensityWithmean= -log(minIntensity./meanIntensity);

opticalDensityWithmean

opticalDensityWithmax= -log(minIntensity/maxIntensity);

opticalDensityWithmax
