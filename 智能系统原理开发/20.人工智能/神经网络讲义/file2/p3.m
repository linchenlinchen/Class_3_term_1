% Example 3.3
%
clf reset
figure(gcf)
setfsize(300,300)
echo on
clc
%NEWP — 建立一个感知器
%INIT — 初始化感知器神经元
%SIM  — 对感知器神经元进行仿真
%TRAIN — 训练感知器神经网络
pause % 键入任意键继续
clc
P = [+0.1 +0.7 +0.8 +0.8 +1.0 +0.3 +0.0 -0.3 -0.5 -1.5; ...
     +1.2 +1.8 +1.6 +0.6 +0.8 +0.5 +0.2 +0.8 -1.5 -1.3];
T = [1 1 1 0 0 1 1 1 0 0;
     0 0 0 0 0 1 1 1 1 1];
pause % 键入任意键，绘制上述矢量
plotpv(P,T);
pause % 键入任意键，定义一个感知器神经元并绘制初始分类曲线
net=newp([-2 1;-2 2],2);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
 echo off
k = pickic;
if k == 2
  net.iw{1,1} = [-0.6926  0.6048; 0.1433 -0.9339];
  net.b{1}= [ 0.0689; -0.0030];
end
echo on
clc
plotpc(net.iw{1,1},net.b{1})
pause % 键入任意键，训练感知器神经元
net=train(net,P,T);
pause % 键入任意键，绘制结果分类曲线
clc
plotpv(P,T);
plotpc(net.iw{1,1},net.b{1});
pause %  键入任意键，检验训练后的感知器神经元
clc
p = [0.7; 1.2];
a = sim(net,p)
echo off
