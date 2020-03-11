% Example 3.13_1
% 应用动量BP算法训练BP网络
%
%clf reset;
%figure(gcf)
%setfsize(500,200);
echo on

%NEWFF — 建立一个BP网络
%TRAIN — 对网络进行训练
%SIM — 对网络进行仿真
pause
clc
P = [0 1 0 1;
     0 0 1 1];
% T为目标矢量

T = [0,1,1,0]
plotpv(P,T);
%plot(P,T,'+');
title('Training Vectors');
xlabel('Input Vector P');
ylabel('Target Vector T');
pause

net=newff(minmax(P),[2 1],{'tansig' 'purelin'},'traingdm','learngdm','sse');
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [3.5000; 3.5000; 3.5000; 3.5000; 3.5000];
  net.b{1} = [-2.8562; 1.0774; -0.5880; 1.4083; 2.8722];
  net.lw{2,1} = [0.2622 -0.2375 -0.4525 0.2361 -0.1718];
  net.b{2} = [0.1326];
end
net.iw{1,1}
net.b{1}
net.lw{2,1}
net.b{2}
pause
echo on

net.trainParam.mc=0.95;
net.trainParam.epochs=8000;
net.trainParam.show=10;
net.trainParam.goal=0.0002;
net.trainParam.lr=0.2;
[net,tr]=train(net,P,T);
pause
A=sim(net,P);
plot(P,T,'+');
hold on
plot(P,A)
hold off
p1 = [1;1];
a1 = sim(net,p1)
echo off
