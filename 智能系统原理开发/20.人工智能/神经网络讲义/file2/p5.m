% Example 3.5
%
clf reset
figure(gcf)
setfsize(300,300);
echo on
clc
%NEWP — 建立一个感知器神经元
%INIT — 初始化感知器神经元
%SIM — 对感知器神经元进行仿真
%TRAIN — 训练感知器神经元
pause % 键入任意键继续
clc
P = [-0.5 -0.5 +0.3 -0.1 -80;
     -0.5 +0.5 -0.5 +1.0 100];
T = [1 1 0 0 1];
pause
clc
plotpv(P,T);
pause
clc
pause
clc
net=newp([-80 0.5;-0.5 100],1,'hardlim','learnpn');
net.iw{1,1} = [-0.8997 -0.7783];
net.b{1} = [-0.0575];
pause
clc
plotpv(P,T)
plotpc(net.iw{1,1},net.b{1})
pause
clc
net=train(net,P,T);
pause
clc
plotpv(P,T);
plotpc(net.iw{1,1},net.b{1});
pause
clc
p = [0.7; 1.2];
a = sim(net,p)
echo off
