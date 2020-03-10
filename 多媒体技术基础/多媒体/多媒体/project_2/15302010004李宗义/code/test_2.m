%得到输入文件名并读出输入图像
filename = input('image:', 's');
I = imread(filename);

%得到文件大小
[x_max, y_max, z_max] = size(I);

%=gray图矩阵
I2 = uint8(zeros(x_max, y_max));    

%对原图中的每个像素点进行遍历，根据灰度转换公式将像素点由RGB转成grey
for i = 1 : x_max
    for j = 1 : y_max
        I2(i, j) = 0.29900 * I(i, j, 1) + 0.58700 * I(i, j, 2)+ 0.11400 * I(i, j, 3);
    end
end

%输出图片
imwrite(I2, 'test_2_grey.jpg');

%输出灰度图片的方差
str = sprintf('该图片的方差为：%f', std2(I2));
fprintf('%s\n', str);
