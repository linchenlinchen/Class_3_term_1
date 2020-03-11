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

net=newff(minmax(P),[2 1],{'logsig' 'logsig'},'trainlm');
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [0.0543 0.0579;-0.0291 0.0999];
  net.b{1} = [0.0703; 0.0939];
  net.lw{2,1} = [0.0801 -0.0605];
  net.b{2} = [0.0109];
end
net.iw{1,1}
net.b{1}
net.lw{2,1}
net.b{2}
pause
echo on

net.trainParam.mc=0.95;
net.trainParam.epochs=8000;
net.trainParam.show=100;
net.trainParam.goal=0.0002;
net.trainParam.lr=0.6;
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