% Example 3.7
%
clf reset
figure(gcf)
setfsize(300,300);
echo on
clc
%NEWP �� ����һ����֪��������
%INIT �� �Ը�֪����������г�ʼ��
%SIM �� �Ը�֪����������з���
%TRAIN �� ѵ����֪��������
pause % �������������
clc
P = [-0.5 -0.5 +0.3 -0.1 -0.8;
     -0.5 +0.5 -0.5 +1.0 +0.0];
T = [1 1 0 0 0];
plotpv(P,T);
pause
clc

%creat preprocessing layer
net1=newp([-1.0 0.5;-0.5 1.0],20);
net1.initFcn='initlay';
net1.layers{1}.initFcn='initwb';
net1.inputWeights{1,1}.initFcn='rands';
net1.layerWeights{1,1}.initFcn='rands';
net1.biases{1}.initFcn='rands';
net1=init(net1);
net1.iw{1,1}
net1.b{1}
pause
a1 = sim(net1,P);

%creat learning layer
net2=newp(minmax(a1),1);
net2.initFcn='initlay';
net2.layers{1}.initFcn='initwb';
net2.inputWeights{1,1}.initFcn='rands';
net2.layerWeights{1,1}.initFcn='rands';
net2.biases{1}.initFcn='rands';
net2=init(net2);
net2 = train(net2,a1,T);
net2.iw{1,1}
net2.b{1}
pause
clc
p = [0.7; 1.2];
a1 = sim(net1,p);    % ������ʸ��Ԥ����
a2 = sim(net2,a1)    % ����
echo off
