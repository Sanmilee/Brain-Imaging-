clc
clear
close all
grayImage = imread('origz.png');
grayImage=wiener2(grayImage,[5,5]);
binaryImage = grayImage > 20;
% Fill the image
binaryImage = imfill(binaryImage, 'holes');
% Erode away 15 layers of pixels.
se = strel('disk', 14, 0);
% figure, imshow(se, []);
binaryImage = imerode(binaryImage, se);
% Mask the gray image
finalImage = grayImage; % Initialize.
finalImage(~binaryImage) = 0;
% % imshow(finalImage, []);
% % title('Skull stripped Image');

% imshow(grayImage, [])
% title('Denoised Skull stripped Image');
% figure, imshow(finalImage, []);
% title('Denoised Skull stripped Image');

img=finalImage;
I=double(finalImage);
X = I(:);
s=size(I);


% % GMM function
[indpixel,label,imgg1,imgg2,imgg3,imgg4]=GMM(s,I);


ncluster=4;
% % FCM function
[I2,MF,Cent,Obj]=sFCM(img,ncluster)   



% % % % IfElse function
% % [k,I3,label2]=IfElse(indpixel,label,I2,s);
% % k



% % function [k,I3,label2]=IfElse(indpixel,label,I2,s)

I3=I2;
label2=label;
k=0;
for i=1:s(1)
    for j=1:s(2)
        if  ((((I2(i,j)==1) && (label(i,j)~= 2)) || ((I2(i,j)==2) && (label(i,j)~= 3)) || ((I2(i,j)==3) && (label(i,j)~=4))) && (indpixel(i,j) <= 0.8))

            k = k + 1;
             label2(i,j)=I2(i,j);   
        end
    end
end  

k




figure, imshow(label2, [])
title('FGA4Clusters');
% % imwrite (label2,'FGA4clusters.png');

image11 = label2;
image22 = label2;
image33 = label2;
image44 = label2;

% % for i=1:s(1),
% %     for j=1:s(2);
% %         if(label2(i,j)~=1)
% %             image11(i,j)=0;
% %         end
% %     end
% % end
% % figure;
% % imshow(image11);
% % title('FGM Shii');

for i=1:s(1),
    for j=1:s(2);
        if(label2(i,j)~=2)
            image22(i,j)=0;
        end
    end
end
figure;
imshow(image22);
title('FGA CSF');
% % imwrite (image22,'FGAcsf.png');

for i=1:s(1),
    for j=1:s(2);
        if(label2(i,j)~=3)
            image33(i,j)=0;
        end
    end
end
figure;
imshow(image33);
title('FGA GM');
% % imwrite (image33,'FGAgm.png');

for i=1:s(1),
    for j=1:s(2);
        if(label2(i,j)~=4)
            image44(i,j)=0;
        end
    end
end
figure;
imshow(image44);
title('FGA WM');
% % imwrite (image44,'FGAwm.png');
