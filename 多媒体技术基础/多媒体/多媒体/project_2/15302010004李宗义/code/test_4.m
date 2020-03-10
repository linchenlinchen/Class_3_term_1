%�õ������ļ�������������ͼ��
filename = input('image:', 's');
I = imread(filename);

%�õ��ļ���С
[x_max, y_max, z_max] = size(I);

%��ͼƬתΪ�ڰ�ͼƬ
I = rgb2gray(I);

% �����ܶ�Ϊ0.04�Ľ�������
I1=imnoise(I,'salt & pepper',0.04); 
%���ͼƬ
imwrite(I1, 'test_4_noise.jpg'); 

%��ֵ,���ڴ�СΪ3��3
I2=medfilt2(I1,[3 3]);
%���ͼƬ
imwrite(I2, 'test_4_mid.jpg'); 

%��ֵ,���ڴ�СΪ3��3
h = fspecial('average',[3 3]);
I3 = imfilter(I1 ,h);
%���ͼƬ
imwrite(I3, 'test_4_avg.jpg'); 
