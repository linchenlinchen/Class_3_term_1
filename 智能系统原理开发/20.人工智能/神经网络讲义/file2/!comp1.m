%Example 3.23
%
clf reset;
setfsize(300,300)
echo on
clc
%    INITC    - 对竞争层初始化
%    TRAINC   - 训练竞争层
%    SIMUC     - 仿真竞争层
pause
clc
P = 0.1 ./ [(1/11):0.001:1] - 0.1;
pause
clc
plot(P,P*0,'+r')
pause
clc
net=newc(minmax(P),6,0.02,0.001);
pause
hold on
plot(net.iw{1,1},net.iw{1,1}*0,'ob')
hold off
pause
clc
net.trainparam.show=50;
net.trainParam.epochs=3000;
net=train(net,P);
plot(P,P*0,'+r',net.iw{1,1},net.iw{1,1}*0,'ob')
pause
clc
p = 0.3;
a = sim(net,p)
echo off
