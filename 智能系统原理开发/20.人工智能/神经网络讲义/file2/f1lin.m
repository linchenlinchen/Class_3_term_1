%Example 3.29
%
clf;
figure(gcf)
setfsize(600,250);
echo on
clc
%    SOLVELIN - 设计一个线性层
%    SIMULIN   - 对线性层进行仿真
pause % 键入任意键继续
clc
time = 0:0.025:5;  %
X = sin(sin(time).*time*10);
%P = delaysig(X,0,2);
d2=2;
d1=0;
[S,Q]=size(X);
P=zeros(S*(d2-d1+1),Q);
for i=0:(d2-d1)
   P((1:S)+S*i,(i+d1+1):Q)=X(:,1:(Q-i-d1));
end 
T = filter([1 0.5 -1.5],1,X);
pause % 键入任意键可以察看信号图形
clc
plot(time,X)
%alabel('Time','Input Signal','Input Signal to the System')
title('Input Signal to the System')
xlabel('Time')
ylabel('Input Signal')
pause
clc
plot(time,T)
%alabel('Time','Output Signal','Output Signal of the System')
title('Output Signal of the System')
xlabel('Time')
ylabel('Output Signal')
pause % 键入任意键开始设计网络
clc
%[w,b] = solvelin(P,T)
net=newlind(P,T);
net.iw{1,1}
net.b{1}
pause % 键入任意键开始检验神经元模型
clc
a = sim(net,P);
plot(time,a,time,T,'+')
%alabel('Time','Network Output _ System Output +','Network and System Output Signals')
title('Network and System Output Signals')
xlabel('Time')
ylabel('Network Output _ System Output +')
pause % 键入任意键可以察看误差信号波形
clc
e = T-a;
plot(time,e,[min(time) max(time)],[0 0],':r')
%alabel('Time','Error','Error Signal')
title('Error Signal')
xlabel('Time')
ylabel('Eorror')
echo off
