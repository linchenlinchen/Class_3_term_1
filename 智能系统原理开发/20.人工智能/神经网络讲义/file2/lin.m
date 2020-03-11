% Example 3.10
%
clf;
setfsize(400,300);
echo on
clc

%NEWLIN —建立一个线性神经网络
%INIT —初始化线性神经网络
%TRAIN — 对神经网络进行训练
%SIM — 对神经网络进行仿真

pause
clc

P = [+1.0 +1.5 +1.2 -0.3
     -1.0 +2.0 +3.0 -0.5
     +2.0 +1.0 -1.6 +0.9];
T = [+0.5 +3.0 -2.2 +1.4
     +1.1 -1.2 +1.7 -0.4
     +3.0 +0.2 -1.8 -0.4
     -1.0 +0.1 -1.0 +0.6];
pause
  
net=newlin(minmax(P),4);
net.initFcn='initlay';
net.inputWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [+1.9978 -0.5959 -0.3517;
                 +1.5543 +0.0531 +1.3660;
                 -1.0672 +0.3645 -0.9227;
                 -0.7747 +1.3839 -0.3384];
  net.b{1} = [+0.0746; -0.0642; -0.4256; -0.6433];
end
net.iw{1,1}
net.b{1}
pause

echo on
net.trainFcn='trainwb';
net.inputWeights{1,1}.learnFcn='learnwh';
net.biases{1}.learnFcn='learnwh';
net.trainParam.epochs=1200;
net.trainParam.goal=0.001;
net=train(net,P,T);
pause
bar(T-sim(net,P))
pause

p = [1; -1; 2];
a = sim(net,p)
echo off
