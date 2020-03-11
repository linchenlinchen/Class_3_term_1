% Example 3.6
%
clf reset
figure(gcf)
setfsize(300,300);
echo on
clc
%NEWP — 建立一个感知器神经元
%INIT  — 对感知器神经网络进行初始化
%SIM    — 对感知器神经网络进行仿真
%TRAIN  — 训练感知器神经网络
pause % 键入任意键继续
clc
P = [-0.5 -0.5 +0.3 -0.1 -0.8;
     -0.5 +0.5 -0.5 +1.0 +0.0];
T = [1 1 0 0 0];
plotpv(P,T)  
pause 
clc
%creat preprocessing 
net=newp([-1.0 0.5;-0.5 1.0],1);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
net=train(net,P,T);
pause
clc
plotpv(P,T)
plotpc(net.iw{1,1},net.b{1})
echo off
