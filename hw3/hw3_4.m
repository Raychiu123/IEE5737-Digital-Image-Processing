a = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW3\DIP2017_hw3\input4.bmp');
r = size (a,1);
c = size (a,2);
ah1 = uint8(zeros (r,c));
ah2 = uint8(zeros (r,c));
ah3 = uint8(zeros (r,c));
n = r*c;
f = zeros (256 ,1);
pdf = zeros (256,1);
out = zeros (256,1);
f1 = zeros (256 ,1);
pdf1 = zeros (256,1);
out1 = zeros (256,1);
f2 = zeros (256 ,1);
pdf2 = zeros (256,1);
out2 = zeros (256,1);

%在平滑處，算出雜訊的機率分布，來求得gaussian smoothing需要的mask大小
a1 = (mean(std(double(a(1,(1:25),:)))));
a1 = double(6*(uint8(a1))+1);             %fspecial的hsize必須為double
x1 = fspecial('gaussian',[a1,a1]);
%對histogram equlization後的值做gaussain smoothing，圖片周圍的地方，使用'same'的padding方法
i1 = uint8(filter2(x1,a(:,:,1),'same'));
i2 = uint8(filter2(x1,a(:,:,2),'same'));
i3 = uint8(filter2(x1,a(:,:,3),'same'));

% ah1--r
for i = 1 :r
    for j = 1 :c
        value = i1(i,j);
        f(value+1)= f(value+1)+1;
        pdf(value+1)= f(value+1)/n;
    end
end
sum = 0; L = 255;
for i = 1:size(pdf)
    sum = sum +pdf(i);
    cdf(i) = sum;
    out(i) = round(cdf(i)*L);
end
for i=1:r    
    for j = 1:c
        ah1(i,j) = out(i1(i,j)+1);
    end
end
%ah2--g
for i = 1 :r
    for j = 1 :c
        value = i2(i,j);
        f1(value+1)= f1(value+1)+1;
        pdf1(value+1)= f1(value+1)/n;
    end
end
sum = 0; L = 255;
for i = 1 : size(pdf1)
    sum = sum +pdf1(i);
    cdf1(i) = sum;
    out1(i) = round(cdf1(i)*L);
end
for i=1:r    
    for j = 1:c
        ah2(i,j) = out1(i2(i,j)+1);
    end
end
%ah3--b
for i = 1 :r
    for j = 1 :c
        value = i3(i,j);
        f2(value+1)= f2(value+1)+1;
        pdf2(value+1)= f2(value+1)/n;
    end
end
sum = 0; L = 255;
for i = 1 : size(pdf2)
    sum = sum +pdf2(i);
    cdf2(i) = sum;
    out2(i) = round(cdf2(i)*L);
end
for i=1:r    
    for j = 1:c
        ah3(i,j) = out2(i3(i,j)+1);
    end
end

ah = cat(3,ah1,ah2,ah3);
% bh = rgb2hsv(ah);
% bh1 = bh(:,:,1);
% bh2 = bh(:,:,2);
% bh3 = bh(:,:,3).^(1/2.2);
% bh = cat(3,bh1,bh2,bh3);
% bh = hsv2rgb(bh);
imwrite(ah,'C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW3\output5.bmp');
figure, imshow(ah)
