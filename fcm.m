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

imshow(grayImage, [])
title('Denoised Skull stripped Image');
figure, imshow(finalImage, []);
% title('Denoised Skull stripped Image');


img=grayImage;
I=double(finalImage);
X = I(:);
s=size(I);



[center,member]  = fcm(X,3);
[center,cidx]=sort(center);
member=member';
member=member(:,cidx);
[maxmember,lbl]=max(member,[],2);
% maxmax= reshape(maxmember, size(I));

I2 = reshape(lbl,size(I));

% % I3=I2;
% % % Generate image of all the four clusters labelled in different colors
figure, imshow(I2, [])
title('FCM 4 Clusters');
% % imwrite (I2,'fcm4.png');

img1 = I2;
img2 = I2;
img3 = I2;
img4 = I2;


for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=1)
            img1(i,j)=0;
        end
    end
end
figure;
imshow(img1);
title('FCM CSF');
%  imwrite (img1,'fcmcsf.png');

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=2)
            img2(i,j)=0;
        end
    end
end
figure;
imshow(img2);
title('FCM Grey Matter');
%  imwrite (img2,'fcmgm.png');

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=3)
            img3(i,j)=0;
        end
    end
end
figure;
imshow(img3);
title('FCM White Matter');
%  imwrite (img3,'fcmwm.png');

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=4)
            img4(i,j)=0;
        end
    end
end
figure;
imshow(img4);
title('FCM Shii');
% % %  imwrite (img4,'fcmshii.png');

