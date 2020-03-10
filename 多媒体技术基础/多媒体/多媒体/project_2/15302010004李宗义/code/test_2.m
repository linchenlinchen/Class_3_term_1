%�õ������ļ�������������ͼ��
filename = input('image:', 's');
I = imread(filename);

%�õ��ļ���С
[x_max, y_max, z_max] = size(I);

%=grayͼ����
I2 = uint8(zeros(x_max, y_max));    

%��ԭͼ�е�ÿ�����ص���б��������ݻҶ�ת����ʽ�����ص���RGBת��grey
for i = 1 : x_max
    for j = 1 : y_max
        I2(i, j) = 0.29900 * I(i, j, 1) + 0.58700 * I(i, j, 2)+ 0.11400 * I(i, j, 3);
    end
end

%���ͼƬ
imwrite(I2, 'test_2_grey.jpg');

%����Ҷ�ͼƬ�ķ���
str = sprintf('��ͼƬ�ķ���Ϊ��%f', std2(I2));
fprintf('%s\n', str);
