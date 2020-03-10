%得到输入文件名并读出输入图像
filename = input('image:', 's');
I = imread(filename);

%得到文件大小
[x_max, y_max, z_max] = size(I);

%输入所求点
x = input('x:');
y = input('y:');

%分别检查x,y,z的边界
if x <= 1 || x >= x_max
    fprintf('x超出边界!\n');
    return;
end
if y <= 1 || y >= y_max
    fprintf('y超出边界!\n');
    return;
end

%输出结果
fprintf('(%d,%d):(%d,%d,%d)\n', x - 1, y - 1, I(x - 1, y - 1, 1), I(x - 1, y - 1, 2), I(x - 1, y - 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x, y - 1, I(x, y - 1, 1), I(x, y - 1, 2), I(x, y - 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x + 1, y - 1, I(x + 1, y - 1, 1), I(x + 1, y - 1, 2), I(x + 1, y - 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x - 1, y, I(x - 1, y, 1), I(x - 1, y, 2), I(x - 1, y, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x, y, I(x, y, 1), I(x, y, 2), I(x, y, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x + 1, y, I(x + 1, y, 1), I(x + 1, y, 2), I(x + 1, y, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x - 1, y + 1, I(x - 1, y + 1, 1), I(x - 1, y + 1, 2), I(x - 1, y + 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x, y + 1, I(x, y + 1, 1), I(x, y + 1, 2), I(x, y + 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x + 1, y + 1, I(x + 1, y + 1, 1), I(x + 1, y + 1, 2), I(x + 1, y + 1, 3));
