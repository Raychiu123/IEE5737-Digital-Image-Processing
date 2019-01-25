clear;
clc;
he = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\2017 DIP HW5 for student\input1.jpg');
copy = he;
he = imgaussfilt(he, 1.5);
a = rgb2gray(he);

nrows = 405;
ncols = 600;

a = double(reshape(a,nrows*ncols,1));
mu1 = randperm(255,1);
mu2 = randperm(255,1);
mu3 = randperm(255,1);
mu4 = randperm(255,1);

indx = zeros(243000,1);
%K-means

% for i=1:243000
%     if mu1-a(i)<mu2-a(i) 
%         if mu1-a(i)<mu3-a(i)
%             if mu1-a(i)<mu4-a(i)
%             indx(i)=1;
%             end
%         end
%     end
%     if mu2-a(i)<mu1-a(i) && mu2-a(i)<mu3-a(i) 
%     elseif mu2-a(i)<mu4-a(i)
%         indx(i)=2;
%     end
%     if mu3-a(i)<mu1-a(i) && mu3-a(i)<mu2-a(i) 
%     elseif mu3-a(i)<mu4-a(i)
%         indx(i)=3;
%     end
%     if mu4-a(i)<mu1-a(i) && mu4-a(i)<mu2-a(i) 
%     elseif  mu4-a(i)<mu3-a(i)
%         indx(i)=4;
%     end
% 
%     
% end

% for i=1:243000
%     if mu1-a(i)<mu2-a(i) 
%         if mu1-a(i)<mu3-a(i)
%             if mu1-a(i)<mu4-a(i)
%             indx(i)=1;
%             
%             end
%         end
%     elseif mu2-a(i)<mu1-a(i) 
%         if mu2-a(i)<mu3-a(i)
%             if mu2-a(i)<mu4-a(i)
%             indx(i)=2;
%            
%             end
%         end
%     elseif mu3-a(i)<mu1-a(i) 
%         if mu3-a(i)<mu2-a(i)
%             if mu3-a(i)<mu4-a(i)
%             indx(i)=3;
%             
%             end
%         end
%     elseif mu4-a(i)<mu1-a(i) 
%         if mu4-a(i)<mu2-a(i)
%             if mu4-a(i)<mu3-a(i)
%             indx(i)=4;
%             
%             end
%         end
%     end
% end
x=1;
while x<50
    for i=1:243000
        min = abs(mu1-a(i));
        indx(i)=1;
        if abs(mu2-a(i))<min
            indx(i)=2;
            min = abs(mu2-a(i));
        end
        if abs(mu3-a(i))<min
            indx(i)=3;
            min = abs(mu3-a(i));
        end
        if abs(mu4-a(i))<min
            indx(i)=4;
            min = abs(mu4-a(i));
        end
    end
    
    indx1 = indx;
    m= (indx1 == 1);
    mu1=mean(double(m).*a);
    
    m= (indx1 ==2);
    mu2=mean(double(m).*a);
   
    m=(indx1 ==3);
    mu3=mean(double(m).*a);
    
    m=(indx1 ==4);
    mu4=mean(double(m).*a);
    
    x=x+1;
end

%¤W¤U¥ª¥kboundary
pixel_labels = reshape(indx,nrows,ncols);
he = copy;
for i = 1:nrows
   for j = 1:ncols
       if j ~= ncols
           if (pixel_labels(i,j) ~= pixel_labels(i,j+1)) %&& (pixel_labels(i,j) ~= pixel_labels(i,j+1)+1) && (pixel_labels(i,j) ~= pixel_labels(i,j+1)+2))
               he(i,j,1)=255;
               he(i,j,2)=0;
               he(i,j,3)=0;
           end
       end
   end
end

for i = 1:ncols
   for j = 1:nrows
       if j ~= nrows
           if pixel_labels(j,i) ~= pixel_labels(j+1,i)
               he(j,i,1)=255;
               he(j,i,2)=0;
               he(j,i,3)=0;
           end
       end
   end
end
imshow(he);
        
    

