%Example 3.14
%
clf;
figure(gcf)
setfsize(500,500);
echo on

%NEWFF — 建立一个BP网络
%TRAIN — 对网络进行训练
%SIM — 对网络进行仿真
pause

%定义输入矢量和目标矢量
P = [-6.0 -6.1 -4.1 -4.0 +5.0 +5.1 +6.0 +6.1];
T = [+0.0 +0.0 +.97 +.99 +.01 +.03 +1.0 +1.0];

%建立一个前向网络
net=newff(minmax(P),[1],{'logsig'},'traingdm','learngdm','sse');
echo off
k=pickic;
if k==2
   net.iw{1,1}=[-0.9];
   net.b{1}=[3.0];
end
echo on
net.iw{1,1}
net.b{1}
pause 

%对前向网络进行训练
net.trainParam.mc=0.95;
net.trainParam.epochs=300;
net.trainParam.show=10;
net.trainParam.lr=0.05;
net=train(net,P,T);
echo off



