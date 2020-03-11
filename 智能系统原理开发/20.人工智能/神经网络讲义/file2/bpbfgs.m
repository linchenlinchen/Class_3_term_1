% Example 3.13_3
% 运用 BFGS quasi-Newton 算法来训练BP网络
%
clf;
figure(gcf)
setfsize(500,200);
echo on
clc
pause
clc
P = -1:.1:1;
T = [-.9602 -.5770 -.0729  .3771  .6405  .6600  .4609 ...
      .1336 -.2013 -.4344 -.5000 -.3930 -.1647  .0988 ...
      .3072  .3960  .3449  .1816 -.0312 -.2189 -.3201];
pause
clc
plot(P,T,'+');
title('Training Vectors');
xlabel('Input Vector P');
ylabel('Target Vector T');
pause
clc
net=newff(minmax(P),[5 1],{'tansig' 'purelin'},'trainbr','learngdm','sse');
net.iw{1,1}
net.b{1}
net.lw{2,1}
net.b{2}
pause
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [3.5000; 3.5000; 3.5000; 3.5000; 3.5000];
  net.b{1} = [-2.8562; 1.0774; -0.5880; 1.4083; 2.8722];
  net.lw{2,1} = [0.2622 -0.2375 -0.4525 0.2361 -0.1718];
  net.b{2} = [0.1326];
end
echo on
clc
%net.performFcn='msereg';
%net.performParam.ratio=0.5;
net.trainParam.epochs=8000;
net.trainParam.show=10;
net.trainParam.goal=0.02;
net.trainParam.lr=0.01;
[net,tr]=train(net,P,T);
pause
A=sim(net,P);
plot(P,T,'+');
hold on
plot(P,A)
hold off
p = 0.5;
a = sim(net,p)
echo off
