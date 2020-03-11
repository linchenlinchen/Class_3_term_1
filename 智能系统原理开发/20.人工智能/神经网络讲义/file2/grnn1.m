% Example 3.17
%
clc
figure(gcf)
setfsize(400,400);
P = -1:.1:1;
T = [-.9602 -.5770 -.0729  .3771  .6405  .6600  .4609 ...
      .1336 -.2013 -.4344 -.5000 -.3930 -.1647  .0988 ...
      .3072  .3960  .3449  .1816 -.0312 -.2189 -.3201];
% P为输入样本；T为目标输出。
plot(P,T,'+');
title('Training Vectors');
xlabel('Input Vector P');
ylabel('Target Vector T');
pause
p = -3:.1:3;
a = radbas(p);
plot(p,a)
title('Radial Basis Transfer Function');
xlabel('Input p');
ylabel('Output a');
pause
% 画出第三副图： 径向基函数图形
a2 = radbas(p-1.5);
a3 = radbas(p+2);
a4 = a + a2*1 + a3*0.5;
plot(p,a,'y--',p,a2,'y--',p,a3,'y--',p,a4,'m-')
title('Weighted Sum of Radial Basis Transfer Functions');
xlabel('Input p');
ylabel('Output a');
pause

net=newgrnn(P,T,0.04);
W1=net.iw{1,1}
b1=net.b{1}
W2=net.lw{2,1}
pause
plot(P,T,'+')
A=sim(net,P);
hold on
plot(P,A);
hold off
pause
% 画出第五副图: 误差曲线
p = 0.5;
a = sim(net,p)
