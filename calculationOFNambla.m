clear
clc
I=imread('7.tif');
k=imread('CB_Atlas_194_GABBY/7_194_CB.png');
[a,b,c]=size(I);
IG=rgb2gray(k);
CB=((IG==133)==1);
CB(~IG==133)=0;
binaryImage=bwareaopen(CB,18);

binaryImage2=imresize(binaryImage, [a,b]);
%o=imshowpair(I, binaryImage2, 'blend');
structBoundaries = bwboundaries(binaryImage2);
xy=structBoundaries{1};
x=xy(:, 2);y=xy(:, 1);
hold on;
%formula to calculate luminance 0.299 * R + 0.587 * G + 0.114 *
grayImage=rgb2gray(I);

blackMaskedImage = double(grayImage); %turning image into black and white
blackMaskedImage(~binaryImage2)=nan; 
%blackMaskedImage(blackMaskedImage==0)=nan;
%blackMaskedImage(blackMaskedImage>240)=nan;
%now crop the image
topLine=min(x);bottomLine=max(x);leftColumn = min(y);rightColumn =max(y);
width= bottomLine -topLine + 1;height = rightColumn -leftColumn +1;
croppedImage=imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
figure(1), imagesc(croppedImage);

[FX, FY]=gradient(croppedImage);
namblaF=sqrt(FX.^2 +FY.^2);
TotalvariationForROI=nanmean(namblaF(:));
figure(2), imagesc(namblaF)
TotalvariationForROI
