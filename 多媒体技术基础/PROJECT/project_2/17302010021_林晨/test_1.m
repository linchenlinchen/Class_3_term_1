%��ȡͼƬ�ļ�·������
str = input('image:','s');
%��ȡ���������x��y
x = input("x:");
y = input("y:");
%��ȡͼƬ����ȡͼƬ�ߴ�����
image = imread(str);
[r,c,m] = size(image);
%�ж��Ƿ�Խ�磬���Խ������ʾ�������������
while(x <= 1 || x >= r || y <= 1 || y >= c)
    fprintf("\nError input for out of bound!\n input again:\n")
    x = input("x:");
    y = input("y:");
end
%ѭ����ӡ�������Χ����rgbֵ
for a = (x-1):(x+1)
    for b = (y-1) : (y+1)
        R = image(a,b,1);
        G = image(a,b,2);
        B = image(a,b,3);
        fprintf("("+a+","+b+"):");
        fprintf("("+R+","+G+","+B+")\n");
    end
end

