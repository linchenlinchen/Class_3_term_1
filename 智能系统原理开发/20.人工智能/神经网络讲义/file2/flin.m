%Example 3.27
%
clf;
figure(gcf)
setfsize(600,300);
echo on
clc
%    SOLVELIN - 设计一个线性层Solves for a linear layer.
%    SIMULIN   - 对线性层进行仿真
pause % 键入任意键继续
clc
time = 0:0.025:5;  %
T = sin(time*4*pi);
%function P = delaysig(T,1,5);
d2=5;
d1=1;
[r,c]=size(T);
P=zeros(r*(d2-d1+1),c);
for i=0:(d2-d1)
   P((1:r)+r*i,(i+d1+1):c)=T(:,1:(c-i-d1));
end
pause % 键入任意键，可以察看信号波形.
clc
plot(time,T)
%alabel('Time','Target Signal','Signal to be Predicted')
title('Signal to be predicted')
xlabel('Time')
ylabel('Target Signal')

pause % 键入任意键开始设计网络...
clc
%    函数SOLVELIN用于确定适当的权值和阈值，使得网络能够逼近系统
%[w,b] = solvelin(P,T)
net=newlind(P,T);
net.iw{1,1}
net.b{1}
pause % 键入任意键开始检验网络的性能
clc
a = sim(net,P);
plot(time,a,time,T,'+')
%alabel('Time','Output _  Target +','Output and Target Signals')
title('Output and Target Signals')
xlabel('Time')
ylabel('Output _ Target +')
pause % 键入任意键，可以察看误差信号波形
e = T-a;
plot(time,e)
hold on
plot([min(time) max(time)],[0 0],':r')
hold off
%alabel('Time','Error','Error Signal')
title('Error Signal')
xlabel('Time')
ylabel('Eorror')
echo off
