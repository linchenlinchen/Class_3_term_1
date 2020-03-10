%得到输入文件名并读出输入图像
filename = input('image:', 's');
I = imread(filename);

%得到文件大小
[x_max, y_max, z_max] = size(I);

%将图片转为黑白图片
I = rgb2gray(I);

% 叠加密度为0.04的椒盐噪声
I1=imnoise(I,'salt & pepper',0.04); 
%输出图片
imwrite(I1, 'test_4_noise.jpg'); 

%中值,窗口大小为3×3
I2=medfilt2(I1,[3 3]);
%输出图片
imwrite(I2, 'test_4_mid.jpg'); 

%均值,窗口大小为3×3
h = fspecial('average',[3 3]);
I3 = imfilter(I1 ,h);
%输出图片
imwrite(I3, 'test_4_avg.jpg'); 
