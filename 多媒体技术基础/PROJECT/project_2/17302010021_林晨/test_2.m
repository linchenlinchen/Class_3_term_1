%��ȡͼƬ�ļ�·������
str = input('image:','s');
%��ȡͼƬ
origin_image = imread(str);
%fprintf('variance1 is :%e',getvariance(origin_image));
%�����·�д��rgbimage2gray����ת��Ϊ�ڰ�ͼ��
imgray = rgbimage2gray(origin_image);
imshow(imgray);
fprintf('variance is :%f',(std2(imgray))^2);
%imshow(imgray);
%����ͼƬ
imwrite(imgray,'result_2.jpg');

%��ȡͼƬÿ�������rgb��ת��Ϊ�Ҷȣ��γ�gray_image
function imgray=rgbimage2gray(imrgb)
    [m,n,~]=size(imrgb);
    for i=1:m
        for j=1:n
            imgray(i,j)=0.29900*imrgb(i,j,1)+0.58700*imrgb(i,j,2)+0.11400*double(imrgb(i,j,3));%��Ȩʵ�ִ���ʵ��ҶȵĽ�άת��
        end
    end
end



