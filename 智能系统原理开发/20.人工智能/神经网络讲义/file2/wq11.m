% Example 3.11
%
clf;
figure(gcf)
setfsize(400,300);
echo on
clc
pause

time = 1:0.0025:5;
P = sin(sin(time).*time*10);
T = P * 2 + 2;
plot(time,P,time,T,'--')
title('Input and Target Signals')
xlabel('Time')
ylabel('Input ___  Target _ _')
pause

net=newlin(minmax(P),1,[0],0.01);
net.inputWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
net.iw{1,1}
net.b{1}
pause
%net.adaptParam.passes=100;
lp.lr=0.01;
[net,a,e]=adapt(net,P,T);

net.iw{1,1}
net.b{1}
pause
plot(time,a,time,T,'--')
pause
title('Output and Target Signals')
xlabel('Time')
ylabel('Output ___  Target _ _')
pause
plot(time,e)
hold on
plot([min(time) max(time)],[0 0],':r')
hold off
title('Error Signal')
xlabel('Time')
ylabel('Error')
echo off
