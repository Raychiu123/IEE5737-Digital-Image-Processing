a = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\input2.bmp');
a1 = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\input2_ori.bmp');
size = 8.5;
asize = 52;
g1 = fspecial('gaussian',35); %gaussian filter(double)
%將filter放大成683 x 1024
b1 = zeros(683,1024);
b2 = zeros(284,273);
% b1(1:27,1:27) = g1(26:52,26:52);
% b1(1:27,1000:1024) = g1(26:52,1:25);
% b1(659:683,1:27) = g1(1:25,26:52);
% b1(659:683,1000:1024) = g1(1:25,1:25);

% b1(1:asize/2,1:asize/2) = g1(asize/2+1:asize,asize/2+1:asize);
% b1(1:asize/2,1024-asize/2+1:1024) = g1(asize/2+1:asize,1:asize/2);
% b1(683-asize/2+1:683,1:asize/2) = g1(1:asize/2,asize/2+1:asize);
% b1(683-asize/2+1:683,1024-asize/2+1:1024) = g1(1:asize/2,1:asize/2);

b2(1:18,1:18) = g1(18:35,18:35);
b2(1:18,257:273) = g1(18:35,1:17);
b2(268:284,1:18) = g1(1:17,18:35);
b2(268:284,257:273) = g1(1:17,1:17);

%wiener filter
f = fft2(a);
fb1 = fft2(b1);
fb1 = fftshift(fb1);
filter = (1./fb1).*((abs(fb1).^2)./((abs(fb1).^2)+0.001));
fb2 = fft2(b2);
fb2 = fftshift(fb2);
filter2 = (1./fb2).*((abs(fb2).^2)./((abs(fb2).^2)+0.1));

new = f.*filter2;
inv = ifft2(new);
inv = uint8(inv);
%imwrite(inv,'C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW4\output2.bmp');
psnr(uint8(inv(:,:,1)),a1(:,:,1))+psnr(uint8(inv(:,:,2)),a1(:,:,2))+psnr(uint8(inv(:,:,3)),a1(:,:,3))
psnr(a(:,:,1),a1(:,:,1))+psnr(a(:,:,2),a1(:,:,2))+psnr(a(:,:,3),a1(:,:,3))
figure(1),imshow(inv),title('reconstructed Image') 
figure(2), imshow(uint8(ifft2(f)))
% figure(3),imshow(uint8(inv)),title('reconstructed Image') 
% figure(4), imshow(uint8(ifft2(f)))
% while size <=56
% i1 = wiener2(a(:,:,1),[size,size]);
% i2 = wiener2(a(:,:,2),[size,size]);
% i3 = wiener2(a(:,:,3),[size,size]);
% i = cat(3,i1,i2,i3);
% size = size+1;
% n=n+1;
% figure(n), imshow(i);
% end
% new = f.*filter2;
% inv = ifft2(new);
% figure(1),imshow(uint8(inv)),title('reconstructed Image') 
% figure(2), imshow(uint8(ifft2(f)))
