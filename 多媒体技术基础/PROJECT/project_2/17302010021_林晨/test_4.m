%��ȡͼƬ�ļ�·������
str = input('image:','s');
%��ȡ������ͼƬ,������test_Noise.jpg
origin_image = imread(str);
%����ͼƬ
subplot(3,2,1);
imshow(origin_image);

%�������������沢����ͼƬ
result1 = imnoise(origin_image,'salt & pepper',0.04);
imwrite(result1,"result_Noise_1.jpg");
subplot(3,2,2);
imshow(result1);


%ʹ��3*3�ٽ���ֵȥ��ƽ�������桢����ͼƬ
w1 = [1 1 1;1 1 1;1 1 1]/9;%ƽ��ģ��
result2 = imfilter(result1,w1,'corr','replicate');%ƽ��ƽ��
imwrite(result2,"result_Noise_2.jpg");
subplot(3,2,3);
imshow(result2);


%ʹ��3*3��˹ƽ��ȥ�룬���桢����ͼƬ
w2=[1 2 1;2 4 2;1 2 1]/16;%��˹ģ��
result3 = imfilter(result1,w2,'corr','replicate');%��˹ƽ��
imwrite(result3,"result_Noise_3.jpg");
subplot(3,2,4);
imshow(result3);

%ʹ����ֵ�˲�ȥ�룬����medfilte2ֻ֧�ֶ�ά�����Է�Ϊ����ά��rgb�����桢����ͼƬ
result4(:,:,1) = medfilt2(result1(:,:,1));
result4(:,:,2) = medfilt2(result1(:,:,2));
result4(:,:,3) = medfilt2(result1(:,:,3));
imwrite(result4,"result_Noise_4.jpg");
subplot(3,2,5);
imshow(result4);
