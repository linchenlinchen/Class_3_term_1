%读取图片文件路径名称
str = input('image:','s');
%获取像素坐标点x，y
x = input("x:");
y = input("y:");
%读取图片，获取图片尺寸数据
image = imread(str);
[r,c,m] = size(image);
%判断是否越界，如果越界则提示重新输入坐标点
while(x <= 1 || x >= r || y <= 1 || y >= c)
    fprintf("\nError input for out of bound!\n input again:\n")
    x = input("x:");
    y = input("y:");
end
%循环打印坐标点周围像素rgb值
for a = (x-1):(x+1)
    for b = (y-1) : (y+1)
        R = image(a,b,1);
        G = image(a,b,2);
        B = image(a,b,3);
        fprintf("("+a+","+b+"):");
        fprintf("("+R+","+G+","+B+")\n");
    end
end

