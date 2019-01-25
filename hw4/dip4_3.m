a = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\input3.bmp');
a1 = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\input3_ori.bmp');
a2 = a1;
figure(2), imshow(a2)
j1=medfilt2(a(:,:,1));
j2=medfilt2(a(:,:,2));
j3=medfilt2(a(:,:,3));
j= cat(3,j1,j2,j3);

g1 = fspecial('gaussian',35);

b1 = zeros(768,1152);
b1(1:18,1:18) = g1(18:35,18:35);
b1(1:18,1136:1152) = g1(18:35,1:17);
b1(752:768,1:18) = g1(1:17,18:35);
b1(752:768,1136:1152) = g1(1:17,1:17);

f = fft2(j);
%f = fftshift(f);
fb1 = fft2(b1);
%fb1 = fftshift(fb1);
filter = (1./fb1).*((abs(fb1).^2)./((abs(fb1).^2)+0.1));

new = f.*filter;
inv = ifft2(new);
inv = uint8(inv);
inv1 = medfilt2(inv(:,:,1));
inv2 = medfilt2(inv(:,:,2));
inv3 = medfilt2(inv(:,:,3));
inv = cat(3,inv1,inv2,inv3);
psnr(uint8(inv(:,:,1)),a1(:,:,1))+psnr(uint8(inv(:,:,2)),a1(:,:,2))+psnr(uint8(inv(:,:,3)),a1(:,:,3))
psnr(a(:,:,1),a1(:,:,1))+psnr(a(:,:,2),a1(:,:,2))+psnr(a(:,:,3),a1(:,:,3))
figure(1),imshow(inv),title('reconstructed Image') 


imshow(j);