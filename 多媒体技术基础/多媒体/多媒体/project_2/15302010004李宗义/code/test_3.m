%�õ������ļ�������������ͼ��
filename = input('image:', 's');
I = imread(filename);

%�õ��ļ���С
[x_max, y_max, z_max] = size(I);

%��ͼƬתΪ�ڰ�ͼƬ
I = rgb2gray(I);

%��ʾԭͼ�ĻҶ�ֱ��ͼ
figure(1); 
imhist(I);

%�Ҷ�����
J = imadjust(I, [0.2 0.6], [0 1]);
figure(2);
imhist(J);

%���ͼƬ
imwrite(J, 'test_3_greyExt.jpg'); 

%ֱ��ͼ���⻯
K = histeq(I);
figure(3);
imhist(K);

%���ͼƬ
imwrite(K, 'test_3_history.jpg'); 