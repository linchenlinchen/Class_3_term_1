%读取图片文件路径名称
str = input('image:','s');
%读取test2得到的黑白图片,请输入“result_2.jpg”
gray_image = imread(str);
%绘制灰度直方图
subplot(3,1,1);
imhist(gray_image);

%灰度拉伸，保存图片，绘制灰度直方图
result1 = imadjust(gray_image,[0.2 0.6],[0 1]);
imwrite(result1,'result_3_1.jpg');
subplot(3,1,2);
axis([0 255 0 24000])%设置坐标轴在指定的区间；
imhist(result1);

%直方图均衡化，保存图片，绘制灰度直方图
result2 = histeq(gray_image);
imwrite(result2,'result_3_2.jpg');
subplot(3,1,3);
imhist(result2);