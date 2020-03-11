% π„“ÂªÿπÈÕ¯¬Á
%
clf;
figure(gcf);
setfsize(300,300);
echo on
clc

P=[1 2 3 4 5 6 7 8];
T=[0 1 2 3 2 1 2 1];
plot(P,T,'.','markersize',20);
axis([0 9 -1 4]);
pause

net=newgrnn(P,T,0.7);
A=sim(net,P);
hold on
plot(P,A,'.','markersize',15,'color',[1 0 0]);
hold off
pause

plot(P,T,'.','markersize',20)
p1=3.5;
a1=sim(net,p1);
hold on
plot(p1,a1,'.','markersize',15,'color',[1 0 0]);
hold off
pause

p2=0:.1:9;
a2=sim(net,p2);
plot(P,T,'.','markersize',20);
hold on
plot(p2,a2,'linewidth',2,'color',[1 0 0]);
echo off
