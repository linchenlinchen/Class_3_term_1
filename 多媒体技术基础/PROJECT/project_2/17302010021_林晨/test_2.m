%读取图片文件路径名称
str = input('image:','s');
%读取图片
origin_image = imread(str);
%fprintf('variance1 is :%e',getvariance(origin_image));
%利用下方写的rgbimage2gray函数转化为黑白图像
imgray = rgbimage2gray(origin_image);
imshow(imgray);
fprintf('variance is :%f',(std2(imgray))^2);
%imshow(imgray);
%保存图片
imwrite(imgray,'result_2.jpg');

%获取图片每个坐标点rgb，转化为灰度，形成gray_image
function imgray=rgbimage2gray(imrgb)
    [m,n,~]=size(imrgb);
    for i=1:m
        for j=1:n
            imgray(i,j)=0.29900*imrgb(i,j,1)+0.58700*imrgb(i,j,2)+0.11400*double(imrgb(i,j,3));%加权实现从真彩到灰度的降维转换
        end
    end
end



