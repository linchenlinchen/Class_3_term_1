%Example 3.25
%
clf;
figure(gcf)
setfsize(300,300);
echo on
clc
%    SOLVEHOP  - 设计Hopfield网络
%    SIMUHOP   - 对Hopfield网络进行仿真
pause % Strike any key to define the problem...
clc
T = [+1 -1;
     -1 +1];
plot(T(1,:),T(2,:),'r*')
axis([-1.1 1.1 -1.1 1.1])
title('Hopfield Network state Space')
xlabel('a(1)')
ylabel('a(2)')
pause % Strike any key to design the network...
clc
net=newhop(T);
net.lw{1,1}
net.b{1}
pause % Strike any key to simulate the network...
clc
a = sim(net,2,[],T)
pause % Strike any key to simulate the network again...
clc
a={rands(2,1)};
[aa,pf,Af]=sim(net,{1 50},[],a);
aa=[cell2mat(a) cell2mat(aa)];
hold on
plot(aa(1,1),aa(2,1),'bx',aa(1,:),aa(2,:))
pause
hold on
color = 'rgbmy';
for i=1:25
   a={rands(2,1)};
   aa=sim(net,{1 20},[],a);
   aa=[cell2mat(a) cell2mat(aa)];
   plot(aa(1,1),aa(2,1),'bx',aa(1,:),aa(2,:),color(rem(i,5)+1))
   drawnow
end
echo off
