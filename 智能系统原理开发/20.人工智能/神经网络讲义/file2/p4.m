% Example 3.4
clf reset
figure(gcf)
setfsize(300,300)
echo on
%NEWP �� ����һ����֪��
%INIT �� ��ʼ����֪����Ԫ
%SIM �� �Ը�֪����������з���
%TRAIN �� ѵ����֪��������
pause % �������������
clc
P = [-0.5 -0.5 +0.3 -0.1 -80;
     -0.5 +0.5 -0.5 +1.0 100];
T = [1 1 0 0 1];
pause %�����������
clc
plotpv(P,T);
pause
clc
net=newp([-100 1;-1 100],1);
net.iw{1,1} = [-0.8997 -0.7783];
net.b{1} = [-0.0575];
pause
clc
plotpc(net.iw{1,1},net.b{1});
pause
clc
net=train(net,P,T);
 pause
clc
plotpv(P,T);
plotpc(net.iw{1,1},net.b{1});
pause
clc
p = [0.7; 1.2];
a = sim(net,p)
echo off
