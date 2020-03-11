% Example 3.2
%
clf reset
figure(gcf)
setfsize(300,300)
echo on
clc
%NEWP — 建立一个感知器
%INIT — 初始化感知器神经元
%SIM — 对感知器神经元仿真
%TRAIN — 训练感知器神经元
pause % 键入任意键继续
clc
P = [-1 +1 -1 +1 -1 +1 -1 +1;
     -1 -1 +1 +1 -1 -1 +1 +1;
     -1 -1 -1 -1 +1 +1 +1 +1];
T = [0 1 0 0 1 1 0 1];
pause %敲任意键，绘制上述矢量
plotpv(P,T);
pause %敲任意键，建立一个感知器神经并对其初始化然后绘制初始分类曲线
net=newp([-1 1;-1 1;-1 1],1);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
plotpc(net.iw{1,1},net.b{1})
pause % 键入任意键，训练感知器神经元
clc
net.trainParam.show=1;
net = train(net,P,T);
pause %绘制结果分类曲线
clc
figure
setfsize(300,300)
plotpv(P,T);
plotpc(net.iw{1,1},net.b{1});
pause %利用训练完的感知器神经元分类
clc
p = [0.7; 1.2; -0.2];
a = sim(net,p)
echo off
