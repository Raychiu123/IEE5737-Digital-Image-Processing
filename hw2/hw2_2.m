a = imread('C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW2\DIP_HW2\input2.jpeg');
r = size(a,1);
c = size(a,2);
L = zeros(750,1000);
A = zeros(750,1000);
B = zeros(750,1000);
X1 = zeros(750,1000);
Y1 = zeros(750,1000);
Z1 = zeros(750,1000);
g = gamma(2)*gamma(2)/gamma(4);
%normalize linearRGB
a_nor = im2double(a).^(g);
r_linear = a_nor(:,:,1);
g_linear = a_nor(:,:,2);
b_linear = a_nor(:,:,3);
%transform RGB to CIEXYZ
x = 0.412453*r_linear + 0.357580*g_linear + 0.180423*b_linear;
y = 0.212671*r_linear + 0.715160*g_linear + 0.072169*b_linear;
z = 0.019334*r_linear + 0.119193*g_linear + 0.950227*b_linear;
%transform CIEXYZ to LAB
xn = 0.9515;
yn = 1.0000;
zn = 1.0886;
% function z = func1(t)
%     if t >0.008856
%         z = t^(1/3);
%     else 
%         z = 7.787*t +(16/116);
%     end
% end
%transform XYZ to LAB
for i=1:r
    for j=1:c
        if y(i,j)/yn >0.008856
            L(i,j) = 116*(y(i,j)/yn).^(1/3)-16;
            A(i,j) = 500*(func1(x(i,j)/xn)-func1(y(i,j)/yn));
            B(i,j) = 200*(func1(y(i,j)/yn)-func1(z(i,j)/zn));
        else
            L(i,j) = 903.3*(y(i,j)/yn);
            A(i,j) = 500*(func1(x(i,j)/xn)-func1(y(i,j)/yn));
            B(i,j) = 200*(func1(y(i,j)/yn)-func1(z(i,j)/zn));
        end
    end
end
L = L*0.92+10;
A = A*0.9+2.5 ;
B = B*0.95+1.5;
%transform LAB to XYZ
fy = (L+16)/116;
fx = fy + A/500;
fz = fy - B/200;
for i=1:r
    for j=1:c
        if fy(i,j) > 0.008856
            Y1(i,j) = yn * (fy(i,j).^3);
        else
            Y1(i,j) = ((fy(i,j)-16)/116)*3*(0.008865^2)*yn;
        end
    end
end
for i=1:r
    for j=1:c
        if fx(i,j) > 0.008856
            X1(i,j) = xn * (fx(i,j).^3);
        else
            X1(i,j) = ((fx(i,j)-16)/116)*3*(0.008865^2)*xn;
        end
    end
end
for i=1:r
    for j=1:c
        if fz(i,j) > 0.008856
            Z1(i,j) = zn * (fz(i,j).^3);
        else
            Z1(i,j) = ((fz(i,j)-16)/116)*3*(0.008865^2)*zn;
        end
    end
end
%transform XYZ to RGB(normalized,linear)
R = im2double((3.240479*X1  -1.537150*Y1 -0.498535*Z1)).^(1/g);
G = im2double((-0.969256*X1 +1.875992*Y1 +0.041556*Z1)).^(1/g);
B = im2double((0.055648*X1  -0.204043*Y1 +1.057311*Z1)).^(1/g);
%transform linearRGB to value:0-255
outR = im2uint8(R);
outG = im2uint8(G);
outB = im2uint8(B);

output = cat(3,outR,outG,outB);
figure,imshow(output);
imwrite(output,'C:\Users\gaexp\OneDrive\Documents\Digital Image Processing\Homework\HW2\hw2_0650736\trans.jpeg');



