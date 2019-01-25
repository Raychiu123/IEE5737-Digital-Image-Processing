a = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\input1.bmp');
a1 = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\input1_ori.bmp');

g1 = fspecial('gaussian',35);
b1 = zeros(683,1024);
b1(1:18,1:18) = g1(18:35,18:35);
b1(1:18,1008:1024) = g1(18:35,1:17);
b1(667:683,1:18) = g1(1:17,18:35);
b1(667:683,1008:1024) = g1(1:17,1:17);

f = fft2(a);
%f = fftshift(f);
fb1 = fft2(b1);
%fb1 = fftshift(fb1);
filter = (1./fb1).*((abs(fb1).^2)./((abs(fb1).^2)));

new = f.*filter;
inv = ifft2(new);
inv = uint8(inv);
psnr(uint8(inv(:,:,1)),a1(:,:,1))+psnr(uint8(inv(:,:,2)),a1(:,:,2))+psnr(uint8(inv(:,:,3)),a1(:,:,3))
psnr(a(:,:,1),a1(:,:,1))+psnr(a(:,:,2),a1(:,:,2))+psnr(a(:,:,3),a1(:,:,3))
figure(1),imshow(inv),title('reconstructed Image') 
figure(2), imshow(a1)