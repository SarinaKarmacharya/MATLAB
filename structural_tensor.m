clear
I=imread('1.tif');
k=imread('BAMBAM/BAMBAM8.png');
[a,b,c]=size(I);
l=imresize(k, [a,b]);

%o=imshowpair(I, l, 'blend');
%h_im=imshow(l);

figure(1), imagesc(I)

%next step

h=imfreehand(); 

binaryImage=h.createMask();
%numberOfPixel1=sum(binaryImage(:));
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1};
x=xy(:, 2);y=xy(:, 1);
hold on;
%formula to calculate luminance 0.299 * R + 0.587 * G + 0.114 *
grayImage=rgb2gray(I);

blackMaskedImage = double(grayImage); %turning image into black and white
blackMaskedImage(~binaryImage)=nan; 
blackMaskedImage(blackMaskedImage==0)=nan;
blackMaskedImage(blackMaskedImage>240)=nan;
%now crop the image
topLine=min(x);bottomLine=max(x);leftColumn = min(y);rightColumn =max(y);
width= bottomLine -topLine + 1;height = rightColumn -leftColumn +1;
croppedImage=imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);



[FX, FY]=gradient(croppedImage);

fsize=10;
g = fspecial('gaussian',[1 fsize],fsize/6);
im = convn(croppedImage,g,'same');
im = convn(im,g','same');

%gx = conv(g,[-1 0 1]);
gx = gx./sum(gx);
gy = gx';
Fx = convn(im,gx,'same');
Fy = convn(im,gy,'same');
Fxx = convn(Fx,gx,'same');
Fxy = convn(Fx,gy,'same');
Fyx = convn(Fy,gx,'same');
Fyy = convn(Fy,gy,'same');

alpha = 2;
Txx = Fx.*Fx + alpha*Fxx;
Tyy = Fy.*Fy + alpha*Fyy;
Txy = Fx.*Fy + alpha*Fxy;
Tyx = Fy.*Fx + alpha*Fyx;
figure(10); imagesc(Txx+Tyy);

[Fxx,Fyx]=gradient(FX);
[Fxy, Fyy]=gradient(FY);
hessianF=sqrt(Fxx.^2 + Fyx.^2 + Fxy.^2 + Fyy.^2);
%namblaF=abs(FX)+abs(FY);
namblaF=sqrt(FX.^2 + FY.^2);

structureF=(2*hessianF) + namblaF;
alpha = 60;
structureF=sqrt(abs(FX.^2 + FY.^2 + alpha*(Fxx + Fyy)));

TotalvariationForROI-1.7=nansum(namblaF(:));
TotalvariationForROI

%minIntensity=nanmin(croppedImage(:));
% find mean intensity 
%meanIntensity=nanmean(croppedImage(:));
% max intensuty
%maxIntensity=nanmax(croppedImage(:));