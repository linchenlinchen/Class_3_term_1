% Example 3.8
%
clf;
figure(gcf)
setfsize(500,200);
echo on
clc

%NEWLIND —— 建立一个线性神经网络 
%SIM —— 对线性神经网络仿真
pause
clc
P = [1.0 -1.2];
T = [0.5 1.0];
pause

%绘制误差曲面
w_range = -1:0.1:1;
b_range = -1:0.1:1;
ES = errsurf(P,T,w_range,b_range,'purelin');
plotes(w_range,b_range,ES);
pause

%设计一个线性神经网络
net=newlind(P,T);
W=net.iw{1,1}
b=net.b{1}
pause

%计算输出误差
A = sim(net,P);
E = T - A;
SSE = sumsqr(E)
%在误差曲面上绘制权和偏差的位置
plotep(W,b,SSE)

p = -1.2;
a = sim(net,p)
echo off
