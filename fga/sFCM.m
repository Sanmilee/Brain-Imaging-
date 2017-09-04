function [I2,MF,Cent,Obj]=sFCM(img,ncluster)  % ,max_iter,expo)

expo=2;
max_iter=100;
img=wiener2(img,5);
[rn,cn]=size(img);
imgsiz=rn*cn;
imgv=reshape(img,imgsiz,1);
imgv=double(imgv);

MF=initfcm(ncluster,imgsiz);

% Main loop
for i = 1:max_iter,
    [MF, Cent, Obj(i)] = stepfcm2dmf(imgv,[rn,cn],MF,ncluster,expo,...
        1,1,5);
    
    % check termination condition
	if i > 1,
		if abs(Obj(i) - Obj(i-1)) < 1e-2, break; end,
	end
end

[Cent,cidx]=sort(Cent);
mf=MF';
mf=mf(:,cidx);
[maxmember,lbl]=max(mf,[],2);
I2 = reshape(lbl,size(img));



s=size(I2);

%figure
imshow(img,[])
figure, imshow(I2, [])
% % imwrite (I2,'FCM4cluster.png');


img1 = I2;
img2 = I2;
img3 = I2;
img4 = I2;

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=4)
            img1(i,j)=0;
        end
    end
end
figure;
imshow(img1);
title('FCM WM');
% % imwrite (img1,'FCMwm.png');

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=2)
            img2(i,j)=0;
        end
    end
end
figure;
imshow(img2);
title('FCM CSF');
% % imwrite (img2,'FCMcsf.png');

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=3)
            img3(i,j)=0;
        end
    end
end
figure;
imshow(img3);
title('FCM GM');
% % imwrite (img3,'FCMgm.png');

for i=1:s(1),
    for j=1:s(2);
        if(I2(i,j)~=1)
            img4(i,j)=0;
        end
    end
end
figure;
imshow(img4);
title('FCM Shii');
% % imwrite (img4,'FCMshii.png');




function [U_new, center, obj_fcn] = stepfcm2dmf(data, dims, U, cluster_n,...
    expo, mfw, spw, nwin)
%STEPFCM One step in fuzzy c-mean image segmentation with spatial constraints;

mf = U.^expo;   % MF matrix after exponential modification

center = mf*data./((ones(size(data, 2),1)*sum(mf'))'); % new center

dist = distfcm(center, data);       % fill the distance matrix

obj_fcn = sum(sum((dist.^2).*mf));  % objective function

tmp = dist.^(-2/(expo-1));      % calculate new U, suppose expo != 1

U_new = tmp./(ones(cluster_n, 1)*sum(tmp));

tempwin=ones(nwin);
mfwin=zeros(size(U_new));

for i=1:size(U_new,1)
    tempmf=reshape(U_new(i,:), dims);
    tempmf=imfilter(tempmf,tempwin,'conv');
    mfwin(i,:)=reshape(tempmf,1,size(U_new,2));
end

mfwin=mfwin.^spw;
U_new=U_new.^mfw;

tmp=mfwin.*U_new;
U_new=tmp./(ones(cluster_n, 1)*sum(tmp));



