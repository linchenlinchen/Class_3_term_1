%Example 3.26
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
T = [+1 +1;
     -1 +1;
     -1 -1];
plot3(T(1,:),T(2,:),T(3,:),'r*')
axis([-1 1 -1 1 -1 1])
xlabel('a(1)')
ylabel('a(2)')
zlabel('a(3)')
title('Hopfield Network state Space')
set(gca,'box','on')
view([37.5 30])
pause % Strike any key to design the network...
clc
net=newhop(T);
net.lw{1,1}
net.b{1}
pause % Strike any key to simulate the network...
clc
%a = rands(3,1);
%[a,aa] = simuhop(a,W,b,50);
%ts=50;
%aa=zeros(3,ts+1);
%aa(:,1)=a(:,1);
%for t=1:ts
 %  a=sim(net,1,[],a);
  % aa(:,t+1)=a(:,1);
  %end
a={rands(3,1)};
aa=sim(net,{1 50},[],a);
aa=[cell2mat(a) cell2mat(aa)];
hold on
plot3(aa(1,1),aa(2,1),aa(3,1),'kx',aa(1,:),aa(2,:),aa(3,:))
pause % Strike any key to simulate the network some more...
clc
hold on
color = 'rgbmy';
for i=1:5
  a = {rands(3,1)};
  %[a,aa] = simuhop(a,W,b,20);
  %ts=20;
  %aa=zeros(3,ts+1);
  %aa(:,1)=a(:,1);
  %for t=1:ts
   %  a=sim(net,1,[],a);
    % aa(:,t+1)=a(:,1);
    %end
  aa=sim(net,{1,20},[],a);
  aa=[cell2mat(a) cell2mat(aa)];  
  plot3(aa(1,1),aa(2,1),aa(3,1),'kx',aa(1,:),aa(2,:),aa(3,:),color(i))
  drawnow
end
pause % Strike any key to see more simulations...
clc
P = [ 1.0  -1.0  -0.5  1.00  1.00  0.0;
      0.0   0.0   0.0  0.00  0.01 -0.2;
     -1.0   1.0   0.5 -1.01 -1.00  0.0]
hold off
for i=1:6
   a = {P(:,i)};
   [s,q]=size(a);
  %[a,aa] = simuhop(a,W,b,100);
  %ts=100;
  %aa=zeros(s,ts+1);
  %aa(:,1)=a(:,1);
  %for t=1:ts
   %  a=sim(net,q,[],a);
    % aa(:,t+1)=a(:,1);
    %end
  aa=sim(net,{q 100},[],a);
  aa=[cell2mat(a) cell2mat(aa)];
  plot3(T(1,:),T(2,:),T(3,:),'r*',aa(1,1),aa(2,1),aa(3,1),'kx', ...
        aa(1,:),aa(2,:),aa(3,:),'g',aa(1,101),aa(2,101),aa(3,101),'o')
  axis([-1.1 1.1 -1.1 1.1 -1.1 1.1])
  xlabel('a(1)')
  ylabel('a(2)')
  zlabel('a(3)')
  title('Hopfield Network State Space')
  set(gca,'box','on')
  view([37.5 30])
  pause
end
echo off
