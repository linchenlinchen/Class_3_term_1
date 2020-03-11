%Example 03.23
%
clf reset;
setfsize(400,400);
echo on
clc
pause
angles=0:0.5*pi/99:0.5*pi;
P=[sin(angles);cos(angles)];
plot(P(1,:),P(2,:),'*m');
pause
clc
net=newsom(minmax(P),[10],'gridtop','linkdist',0.9,1000,0.02,1);
net.iw{1,1}
pause
hold on
plotsom(net.iw{1,1},net.layers{1}.distances)
hold off
pause
net.trainParam.show=50;
net.trainParam.epochs=1000;
net=train(net,P);
net.iw{1,1}
pause
plot(P(1,:),P(2,:),'*m')
hold on
plotsom(net.iw{1,1},net.layers{1}.distances)
hold off
p=[1;0];
a=sim(net,p)
echo off