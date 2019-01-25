clear;
clc;
he = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\2017 DIP HW5 for student\input1.jpg');
copy = he;
he = imgaussfilt(he, 0.6);
a1 = rgb2gray(he);

nrows = 405;
ncols = 600;

%k-means
a1 = reshape(a1,nrows*ncols,1);
nColors = 4;
%[cluster_idx, cluster_center] = kmeans(ab,nColors, 'distance','sqEuclidean','Replicates',3);
[cluster_idx, cluster_center] = kmeans(a1,nColors);
pixel_labels = reshape(cluster_idx,nrows,ncols);

%¤W¤U¥ª¥kboundary
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

% segmented_images = cell(1,3);
% rgb_label = repmat(pixel_labels,[1 1 3]);
%imwrite(he,'C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\2017 DIP HW5 for student\output.jpg');
figure(3),imshow(he)