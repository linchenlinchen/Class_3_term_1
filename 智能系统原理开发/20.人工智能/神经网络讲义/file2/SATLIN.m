%Example 3.19
%
clf reset;
figure(gcf)
setfsize(300,250);
echo on
clc
%    SATLIN  - 饱和线性传递函数
%    LEARNIS - Instar学习规则
pause
clc
V = [0.4082; 0.8165; -0.4082];
%    在原型矢量中加入噪声，新得到200个输入矢量，并将所有的输入矢量归一化
Q = 200;
P = randn(3,Q)*0.1 + V*ones(1,Q);
P = normc(P);
pause
clc
hold on
[x,y,z] = sphere(10);
h = surf(x*0.9,y*0.9,z*0.9,x.^2.*y.^2.*z.^2);
%set(h,'face','interp')
plot3(P(1,:)*0.99,P(2,:)*0.99,P(3,:)*0.99,'.k','markersize',10)
view([160 -20])
colormap(cool)
title('Normalized input vectors')
pause
clc
W = [-0.8133    0.1474   -0.5628];
plot3(W(1),W(2),W(3),'w+','markersize',10,'erasemode','none')
pause
clc
A = satlin(W*V)
pause
clc
lp.lr = 0.05;

for q = 1:Q
  p = P(:,q);
  a = satlin(W*p);
  dW = learnis(W,p,[],[],a,[],[],[],[],[],lp,[]);
  W = W + dW;
  plot3(W(1),W(2),W(3),'r.','markersize',10,'erasemode','none');
end
plot3(W(1),W(2),W(3),'w+','markersize',10,'erasemode','none')
W = normr(W);
pause
clc
A = satlin(W*V)
echo off
