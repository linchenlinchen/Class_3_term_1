%读取图片文件路径名称
str = input('image:','s');
%读取待处理图片,请输入test_Noise.jpg
origin_image = imread(str);
%绘制图片
subplot(3,2,1);
imshow(origin_image);

%加入噪声，保存并绘制图片
result1 = imnoise(origin_image,'salt & pepper',0.04);
imwrite(result1,"result_Noise_1.jpg");
subplot(3,2,2);
imshow(result1);


%使用3*3临近均值去噪平滑，保存、绘制图片
w1 = [1 1 1;1 1 1;1 1 1]/9;%平均模板
result2 = imfilter(result1,w1,'corr','replicate');%平均平滑
imwrite(result2,"result_Noise_2.jpg");
subplot(3,2,3);
imshow(result2);


%使用3*3高斯平滑去噪，保存、绘制图片
w2=[1 2 1;2 4 2;1 2 1]/16;%高斯模板
result3 = imfilter(result1,w2,'corr','replicate');%高斯平滑
imwrite(result3,"result_Noise_3.jpg");
subplot(3,2,4);
imshow(result3);

%使用中值滤波去噪，由于medfilte2只支持二维，所以分为三个维度rgb，保存、绘制图片
result4(:,:,1) = medfilt2(result1(:,:,1));
result4(:,:,2) = medfilt2(result1(:,:,2));
result4(:,:,3) = medfilt2(result1(:,:,3));
imwrite(result4,"result_Noise_4.jpg");
subplot(3,2,5);
imshow(result4);
