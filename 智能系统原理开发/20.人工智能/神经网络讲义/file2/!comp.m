%Example 3.22
%
clf reset;
figrect = get(gcf,'Position');
set(gcf,'Position',[figrect(1:2) 300 300]);
rand('seed',43736218);
randn('seed',1.251983983e+09);
echo on
clc
X = [0 1; 0 1];
clusters = 8;
points = 6;
std_dev = 0.05;
P = nngenc(X,clusters,points,std_dev);

pause
clc
plot(P(1,:),P(2,:),'+r')
title('Input Vectors')
xlabel('p(1)')
ylabel('p(2)')

pause
clc
net=newc(minmax(P),8,0.1,0.001);
w=net.iw{1}
hold on
plot(w(:,1),w(:,2),'ob')
title('Input/Weight Vectors')
xlabel('p(1), w(1)')
ylabel('p(2), w(2)')
pause
clc
net.trainParam.show=20;
net.trainParam.epochs=500;
net=train(net,P);
w=net.iw{1}
hold on
plot(w(:,1),w(:,2),'ob')
pause
clc
p = [0; 0.2];
a=compet(-dist(w,p))
echo off
