%��ȡͼƬ�ļ�·������
str = input('image:','s');
%��ȡtest2�õ��ĺڰ�ͼƬ,�����롰result_2.jpg��
gray_image = imread(str);
%���ƻҶ�ֱ��ͼ
subplot(3,1,1);
imhist(gray_image);

%�Ҷ����죬����ͼƬ�����ƻҶ�ֱ��ͼ
result1 = imadjust(gray_image,[0.2 0.6],[0 1]);
imwrite(result1,'result_3_1.jpg');
subplot(3,1,2);
axis([0 255 0 24000])%������������ָ�������䣻
imhist(result1);

%ֱ��ͼ���⻯������ͼƬ�����ƻҶ�ֱ��ͼ
result2 = histeq(gray_image);
imwrite(result2,'result_3_2.jpg');
subplot(3,1,3);
imhist(result2);