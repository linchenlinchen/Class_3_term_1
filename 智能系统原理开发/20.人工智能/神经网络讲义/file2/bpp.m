% Example 3.13
%
clf;
figure(gcf)
setfsize(500,200);
echo on

%NEWFF — 建立一个BP网络
%TRAIN — 对网络进行训练
%SIM — 对网络进行仿真
pause
P = -1:.1:1;
T = [-.9602 -.5770 -.0729  .3771  .6405  .6600  .4609 ...
      .1336 -.2013 -.4344 -.5000 -.3930 -.1647  .0988 ...
      .3072  .3960  .3449  .1816 -.0312 -.2189 -.3201];
plot(P,T,'+');
title('Training Vectors');
xlabel('Input Vector P');
ylabel('Target Vector T');
pause
net=newff(minmax(P),[5 1],{'tansig' 'purelin'},'traingd','learngd','sse');
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [3.5000; 3.5000; 3.5000; 3.5000; 3.5000];
  net.b{1} = [-2.8562; 1.0774; -0.5880; 1.4083; 2.8722];
  net.lw{2,1} = [0.2622 -0.2375 -0.4525 0.2361 -0.1718];
  net.b{2} = [0.1326];
end
net.iw{1,1}
net.b{1}
net.lw{2,1}
net.b{2}
pause
echo on

me=8000;
net.trainParam.show=10;
net.trainParam.goal=0.02;
net.trainParam.lr=0.01;
A=sim(net,P);
sse=sumsqr(T-A);
for i=1:me/100
   if sse<net.trainparam.goal,i=i-1;break,end
   net.trainParam.epochs=100;
   [net,tr]=train(net,P,T);
   trp((1+100*(i-1)):(max(tr.epoch)+100*(i-1)))=tr.perf(1:max(tr.epoch));
   A=sim(net,P);
   sse=sumsqr(T-A);
   plot(P,T,'+');
   hold on
   plot(P,A)
   hold off
   pause
end
message=sprintf('Traingd, Epoch %%g/%g, SSE %%g\n',me);
fprintf(message,(max(tr.epoch)+100*(i-1)),sse)
plot(trp)
[i,j]=size(trp);
hold on
plot(1:j,net.trainParam.goal,'r--')
hold off
title('Error Signal')
xlabel('epoch')
ylabel('Error')
p = 0.5;
a = sim(net,p)
echo off
