%Elman Application
%
clf
figure(gcf)
setfsize(500,500);
echo on

% MEWELM —— 建立一个Elman神经网络
% TRAIN —— 训练一个神经网络
% SIM —— 对一个神经网络进行仿真

pause  %Strik any key to creat a network
clc
P1=sin(1:20);
P2=sin(1:20)*2;
T1=ones(1,20);
T2=ones(1,20)*2;
P=[P1 P2 P1 P2];
T=[T1 T2 T1 T2];
Pseq=con2seq(P);
Tseq=con2seq(T);
R=1;    %1 input elemnt
s1=10;  %10 recurrent neurons in the frist layer
s2=1;   %1 layer 2 output neuron
net=newelm([-2 2],[s1 s2],{'tansig','purelin'},'traingdx');

pause   %Strike any key to train the network
net.trainParam.epochs=500;
net.trainParam.show=5;
net.trainParam.goal=0.1;
net.performFcn='sse';
[net,tr]=train(net,Pseq,Tseq);
%semilogy(tr.epoch,tr.perf);
hold on
title('Sum Squared Error of Elman Network')
xlabel('Epoch')
ylabel('Sum Squared Error')
hold off
pause

%Simulate the network
a=sim(net,Pseq)
time=1:length(P);
plot(time,T,'--',time,cat(2,a{:}))
title('Testing Amplitute Detection')
xlabel('Time Step')
ylabel('Target -- Outpt ---')
pause

%Network Generalization
P3=sin(1:20)*1.6;
P4=sin(1:20)*1.2;
T3=ones(1,20)*1.6;
T4=ones(1,20)*1.2;
Pg=[P3 P4 P3 P4];
Tg=[T3 T4 T3 T4];
Pgseq=con2seq(Pg);
a=sim(net,Pgseq)
time=1:length(Pg);
plot(time,Tg,'--',time,cat(2,a{:}))
axis([0 80 0.7 2])
title('Testing Generalization')
xlabel('Time Step')
ylabel('Target -- Outpt ---')
echo off
