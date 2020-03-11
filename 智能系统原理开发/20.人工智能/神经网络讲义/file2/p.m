% Example 3.1
% 
clf reset
figure(gcf)
setfsize(300,300);
echo on

%NEWP —— 建立一个感知器神经元
%INIT —— 对感知器神经元初始化
%TRAIN —— 训练感知器神经元
%SIM —— 对感知器神经元仿真
pause % 敲任意键继续
clc
% P为输入矢量
P = [-0.5 -0.5 +0.3 +0.0;
     -0.5 +0.5 -0.5 +1.0];
% T为目标矢量
T = [1 1 0 0];
pause
clc
% 绘制输入矢量图
plotpv(P,T);
pause
clc
% 定义感知器神经元并对其初始化  
net=newp([-0.5 0.5;-0.5 1],1);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [-0.8161  0.3078];
  net.b{1} = [-0.1680];
end
echo on
plotpc(net.iw{1,1},net.b{1})
pause
% 训练感知器神经元
net=train(net,P,T);
pause
% 绘制结果分类曲线
plotpv(P,T)
plotpc(net.iw{1,1},net.b{1});
pause
% 利用训练完的感知器神经元分类
p = [-0.5; 0];
a = sim(net,p)
echo off
