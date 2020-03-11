% Example 3.2
%
clf reset
figure(gcf)
setfsize(300,300)
echo on
clc
%NEWP �� ����һ����֪��
%INIT �� ��ʼ����֪����Ԫ
%SIM �� �Ը�֪����Ԫ����
%TRAIN �� ѵ����֪����Ԫ
pause % �������������
clc
P = [-1 +1 -1 +1 -1 +1 -1 +1;
     -1 -1 +1 +1 -1 -1 +1 +1;
     -1 -1 -1 -1 +1 +1 +1 +1];
T = [0 1 0 0 1 1 0 1];
pause %�����������������ʸ��
plotpv(P,T);
pause %�������������һ����֪���񾭲������ʼ��Ȼ����Ƴ�ʼ��������
net=newp([-1 1;-1 1;-1 1],1);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
plotpc(net.iw{1,1},net.b{1})
pause % �����������ѵ����֪����Ԫ
clc
net.trainParam.show=1;
net = train(net,P,T);
pause %���ƽ����������
clc
figure
setfsize(300,300)
plotpv(P,T);
plotpc(net.iw{1,1},net.b{1});
pause %����ѵ����ĸ�֪����Ԫ����
clc
p = [0.7; 1.2; -0.2];
a = sim(net,p)
echo off
