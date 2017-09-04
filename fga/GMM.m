function [indpixel,label,imgg1,imgg2,imgg3,imgg4]=GMM(s,I)

cluster_num = 4;
mu = (1:cluster_num)./(cluster_num + 1) * max(max(I));
sigma = mu;
pw = zeros(cluster_num,size(I,1)*size(I,2));
pc = rand(1,cluster_num);
pc = pc/sum(pc);
max_iter = 200;
iter = 1;


while iter <= max_iter
    %%%%-----Expectation-------%%%%
    for i = 1:cluster_num
        MU = repmat(mu(i),size(I,1)*size(I,2),1);
        temp = 1/sqrt(2*pi*sigma(i))*exp(-(I(:)-MU).^2/2/sigma(i));
        temp(temp<0.000001) = 0.000001;
        pw(i,:) = pc(i) * temp;
    end
 pw = pw./(repmat(sum(pw),cluster_num,1));
    

 %%%%-------Maximization-------%%%%
    for i = 1:cluster_num
         pc(i) = mean(pw(i,:));
         mu(i) = pw(i,:)*I(:)/sum(pw(i,:));
         sigma(i) = pw(i,:)*((I(:)-mu(i)).^2)/sum(pw(i,:));
    end
 
    
 %%%%%--------show-result---------%%%%%
   indpix= max(pw); 
   indpixel= reshape (indpix, size(I));
   
   
    [~,label] = max(pw);
    label = reshape(label,size(I));
    imshow(label, [])
    title(['Iterations = ',num2str(iter)]);

    
    pause(0.1);
    M(iter,:) = mu;
    S(iter,:) = sigma;
    iter = iter + 1;
end


%%%%%-------Tissue Clusters Display------%%%%%
imgg1 = label;
imgg2 = label;
imgg3 = label;
imgg4 = label;

% % imwrite (label,'GMM4Clusters.png');


for i=1:s(1),
    for j=1:s(2);
        if(label(i,j)~=2)
            imgg2(i,j)=0;
        end
    end
end
figure;
imshow(imgg2);
title('GMM CSF');
% % imwrite (imgg2,'GMMcsf.png');


for i=1:s(1),
    for j=1:s(2);
        if(label(i,j)~=3)
            imgg3(i,j)=0;
        end
    end
end
figure;
imshow(imgg3);
title('GMM GM');
% % imwrite (imgg3,'GMMgm.png');


for i=1:s(1),
    for j=1:s(2);
        if(label(i,j)~=4)
            imgg4(i,j)=0;
        end
    end
end
figure;
imshow(imgg4);
title('WM');
% % imwrite (imgg4,'GMMwm.png');


for i=1:s(1),
    for j=1:s(2);
        if(label(i,j)~=1)
            imgg1(i,j)=0;
        end
    end
end
figure;
imshow(imgg1);
title('GMM shii');
% % imwrite (imgg1,'GMMshii.png');
