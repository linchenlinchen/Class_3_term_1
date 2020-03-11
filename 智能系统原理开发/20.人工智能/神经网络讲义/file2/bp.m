% Example 3.12
%
clf;
figure(1)
setfsize(500,300);
echo on
clc
pause % 键入任意键继续
clc
P = [-3.0 +2.0];
T = [+0.4 +0.8];
pause
clc
wv = -4:0.4:7.6;
bv = -4:0.4:7.6;
es = errsurf(P,T,wv,bv,'logsig');
plotes(wv,bv,es,[60 30]);
pause
clc
net=newff(minmax(P),[1],{'logsig'},'traingd','learngd','sse');
net.iw{1,1}
net.b{1}
pause
echo off
k = pickic(1);
if k == 2
  net.iw{1,1} = -2.1617;
  net.b{1} = -1.7862;
elseif k == 3
   subplot(1,2,2);
   h=text(2,2,sprintf('Click on me'))
   [net.iw{1,1},net.b{1}] = ginput(1);
   delete(h)
end
echo on
clc

net.trainParam.show = 5;    % 学习过程显示频率
net.trainparam.goal = 0.01; % 误差指标
net.trainParam.lr = 2;% 学习率
me=100;
A=sim(net,P);
sse=sumsqr(T-A);
h=plotep(net.iw{1,1},net.b{1},sse)
for i=1:me
   if sse<net.trainParam.goal,i=i-1;break,end
   net.trainParam.epochs=1;
   figure(2)
   setfsize(50,50)
   [net,tr] = train(net,P,T);
   trp(i)=tr.perf(1,2);
   A=sim(net,P);
   sse=sumsqr(T-A);
   if rem(i,net.trainParam.show)==0
      figure(1)
      h=plotep(net.iw{1,1},net.b{1},sse,h);
   end
end
tr.p=trp(1:i);
message=sprintf('Train:%%g/%g epochs,sse=%%g.\n',me);
fprintf(message,i,sse)
figure(1)
plotep(net.iw{1,1},net.b{1},sse,h);
pause
subplot(1,2,2)
plot(1:i,tr.p)
hold on
plot(1:i,net.trainParam.goal,'r--')
hold off
title('Error Signals')
xlabel('Epochs')
ylabel('Error')
pause
p = -1.2;
a = sim(net,p)
echo off
