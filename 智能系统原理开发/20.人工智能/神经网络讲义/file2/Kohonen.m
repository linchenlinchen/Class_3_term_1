%Example 3.20
%
clf reset;
figure(gcf)
setfsize(300,250);
echo on
clc
%    HARDLIM - 一种非线性传递函数
%    LEARNK  - Kohonen学习规则
pause
clc
V = [0.4082; 0.8165; -0.4082];
Q = 200;
P = randn(3,Q)*0.1 + V*ones(1,Q);
P = normc(P);
pause
clc
hold on
[x,y,z] = sphere(10);
h = surf(x*0.9,y*0.9,z*0.9,x.^2.*y.^2.*z.^2);
%set(h,'face','interp')
plot3(P(1,:)*0.99,P(2,:)*0.99,P(3,:)*0.99,'.b','markersize',10)
view([160 -20])
colormap(cool)
title('Normalized input vectors')
pause
clc
W = randnr(1,3);     % 每个神经元有3个输入
b = -0.1;
W = [-0.8133  0.1474 -0.5628];
plot3(W(1),W(2),W(3),'w+',W(1),W(2),W(3),'r.','markersize',10)
pause
clc
A = hardlim(netsum(W*V,b))
pause
clc
lp.lr = 0.05; % 学习率
for q = 1:Q
  p = P(:,q);
  a = hardlim(netsum(W*p,b));  
  dW = learnk(W,p,[],[],a,[],[],[],[],[],lp,[]);
  W = W + dW;
  plot3(W(1),W(2),W(3),'r.','markersize',10,'erasemode','none');
end
plot3(W(1),W(2),W(3),'w+','markersize',10,'erasemode','none')
W = normr(W);
pause
clc
A = hardlim(netsum(W*V,b))
echo off
