% Example 3.6
%
clf reset
figure(gcf)
setfsize(300,300);
echo on
clc
%NEWP �� ����һ����֪����Ԫ
%INIT  �� �Ը�֪����������г�ʼ��
%SIM    �� �Ը�֪����������з���
%TRAIN  �� ѵ����֪��������
pause % �������������
clc
P = [-0.5 -0.5 +0.3 -0.1 -0.8;
     -0.5 +0.5 -0.5 +1.0 +0.0];
T = [1 1 0 0 0];
plotpv(P,T)  
pause 
clc
%creat preprocessing 
net=newp([-1.0 0.5;-0.5 1.0],1);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
net=train(net,P,T);
pause
clc
plotpv(P,T)
plotpc(net.iw{1,1},net.b{1})
echo off
