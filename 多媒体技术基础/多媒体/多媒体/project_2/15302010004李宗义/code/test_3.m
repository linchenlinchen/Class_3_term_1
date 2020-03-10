%得到输入文件名并读出输入图像
filename = input('image:', 's');
I = imread(filename);

%得到文件大小
[x_max, y_max, z_max] = size(I);

%将图片转为黑白图片
I = rgb2gray(I);

%显示原图的灰度直方图
figure(1); 
imhist(I);

%灰度拉伸
J = imadjust(I, [0.2 0.6], [0 1]);
figure(2);
imhist(J);

%输出图片
imwrite(J, 'test_3_greyExt.jpg'); 

%直方图均衡化
K = histeq(I);
figure(3);
imhist(K);

%输出图片
imwrite(K, 'test_3_history.jpg'); 