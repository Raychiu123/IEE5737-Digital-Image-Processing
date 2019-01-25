a = imread('D:\DIP\DIP_HW2\DIP_HW2\input1.bmp');
r1 = histeq(a(:,:,1));
g1 = histeq(a(:,:,2));
b1 = histeq(a(:,:,3));
a1 = cat(3,r1,g1,b1);

figure, imshow(a1);