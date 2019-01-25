a = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW2\DIP_HW2\input1.bmp');
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

% ah1--r
for i = 1 :r
    for j = 1 :c
        value = a(i,j,1);
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
        ah1(i,j) = out(a(i,j,1)+1);
    end
end
%ah2--g
for i = 1 :r
    for j = 1 :c
        value = a(i,j,2);
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
        ah2(i,j) = out1(a(i,j,2)+1);
    end
end
%ah3--b
for i = 1 :r
    for j = 1 :c
        value = a(i,j,3);
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
        ah3(i,j) = out2(a(i,j,3)+1);
    end
end

ah = cat(3,ah1,ah2,ah3);
figure, imshow(ah)