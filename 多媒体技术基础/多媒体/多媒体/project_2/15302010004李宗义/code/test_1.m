%�õ������ļ�������������ͼ��
filename = input('image:', 's');
I = imread(filename);

%�õ��ļ���С
[x_max, y_max, z_max] = size(I);

%���������
x = input('x:');
y = input('y:');

%�ֱ���x,y,z�ı߽�
if x <= 1 || x >= x_max
    fprintf('x�����߽�!\n');
    return;
end
if y <= 1 || y >= y_max
    fprintf('y�����߽�!\n');
    return;
end

%������
fprintf('(%d,%d):(%d,%d,%d)\n', x - 1, y - 1, I(x - 1, y - 1, 1), I(x - 1, y - 1, 2), I(x - 1, y - 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x, y - 1, I(x, y - 1, 1), I(x, y - 1, 2), I(x, y - 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x + 1, y - 1, I(x + 1, y - 1, 1), I(x + 1, y - 1, 2), I(x + 1, y - 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x - 1, y, I(x - 1, y, 1), I(x - 1, y, 2), I(x - 1, y, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x, y, I(x, y, 1), I(x, y, 2), I(x, y, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x + 1, y, I(x + 1, y, 1), I(x + 1, y, 2), I(x + 1, y, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x - 1, y + 1, I(x - 1, y + 1, 1), I(x - 1, y + 1, 2), I(x - 1, y + 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x, y + 1, I(x, y + 1, 1), I(x, y + 1, 2), I(x, y + 1, 3));
fprintf('(%d,%d):(%d,%d,%d)\n', x + 1, y + 1, I(x + 1, y + 1, 1), I(x + 1, y + 1, 2), I(x + 1, y + 1, 3));
