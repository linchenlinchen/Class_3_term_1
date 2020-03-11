%Example 3.28
%
clf;
figure(gcf)
setfsize(600,400);
echo on
clc
%    INITLIN  - 对线性层进行初始化
%    ADAPTWH  - 采用Widrow-Hoff规则对线性进行训练
pause % 键入任意键继续..
clc
time1 = 0:0.05:4;      % from 0 to 4 seconds
time2 = 4.05:0.024:6;  % from 4 to 6 seconds
time = [time1 time2];  % from 0 to 6 seconds
T = [sin(time1*4*pi) sin(time2*8*pi)];
%P = delaysig(T,1,5);
d2=5;
d1=1;
[S,Q]=size(T);
P=zeros(S*(d2-d1+1),Q);
for i=0:(d2-d1)
   P((1:S)+S*i,(i+d1+1):Q)=T(:,1:(Q-i-d1));
end 
pause % 键入任意键可以察看目标信号的波形..
clc
plot(time,T)
%alabel('Time','Target Signal','Signal to be Predicted')
title('signal to be predicted')
xlabel('Time')
ylabel('Target Signal')
pause % 键入任意键开始设计网络
clc
%[w,b] = initlin(P,T)
net=newlin(minmax(P),1,[0],0.1);
net.inputWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
net.iw{1,1}
net.b{1}
pause % 键入任意键开始对网络进行自适应训练..
clc
%lr = 0.1;
%[a,e,w,b] = adaptwh(w,b,P,T,lr);
[net,a,e]=adapt(net,P,T);
pause % 键入任意键可以察看输出波形.
clc
plot(time,a,time,T,'--')
%alabel('Time','Output ___  Target _ _','Output and Target Signals')
title('Output and Target Signals')
xlabel('Time')
ylabel('Output ___ Target _ _ ')
pause % 键入任意键可以察看误差信号波形
plot(time,e,[min(time) max(time)],[0 0],':r')
%alabel('Time','Error','Error Signal')
title('Error Signal')
xlabel('Time')
ylabel('Eorror')
echo off
