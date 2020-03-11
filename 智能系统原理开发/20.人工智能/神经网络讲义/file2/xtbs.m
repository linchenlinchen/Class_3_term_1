%lyy33

clear all
Q=load ('lye_1_25.TXT');
d=size(Q)
t=Q(:,2);
y=Q(:,1);
y1=Q(:,3);
y2=Q(:,5);
u=0.25;


%
y=y(1:10:d);
t=t(1:10:d);
figure(1)
plot(t,y);
grid on
pause


y=y/400;

y11=y(3:173);
p1=y11';
T=y(4:174);
T=T';
load step1;
u=u(1:171);
p2=u';
P=[p1;p2];
k1=1:171;
S1=7;
P=[p1;p2];

net=newff(minmax(P),[S1 1],{'tansig' 'purelin'},'trainlm');
net.trainParam.show=50;
net.trainParam.epochs=18000;
net.trainParam.goal=1.3e-06;
net.trainParam.lr=0.06;
net.trainParam.mc=0.8;

%Training network;
[net,tr]=train(net,P,T);

 A=sim(net,P);
 e=T-A;
 %Plot final approximation
 

figure(4)
%hold on
plot(k1,T,'k');
title('Training Vectors','fontsize',20,'fontweight','bold');
xlabel('Input Vector k','fontsize',18,'fontweight','bold');
ylabel('Target Vector A-T','fontsize',18,'fontweight','bold');
hold on
plot(k1,A,'.K')
hold on
plot(k1,e,'.k')
grid on
echo off
