% Example 3.3
%
clf reset
figure(gcf)
setfsize(300,300)
echo on
clc
%NEWP �� ����һ����֪��
%INIT �� ��ʼ����֪����Ԫ
%SIM  �� �Ը�֪����Ԫ���з���
%TRAIN �� ѵ����֪��������
pause % �������������
clc
P = [+0.1 +0.7 +0.8 +0.8 +1.0 +0.3 +0.0 -0.3 -0.5 -1.5; ...
     +1.2 +1.8 +1.6 +0.6 +0.8 +0.5 +0.2 +0.8 -1.5 -1.3];
T = [1 1 1 0 0 1 1 1 0 0;
     0 0 0 0 0 1 1 1 1 1];
pause % �������������������ʸ��
plotpv(P,T);
pause % ���������������һ����֪����Ԫ�����Ƴ�ʼ��������
net=newp([-2 1;-2 2],2);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
 echo off
k = pickic;
if k == 2
  net.iw{1,1} = [-0.6926  0.6048; 0.1433 -0.9339];
  net.b{1}= [ 0.0689; -0.0030];
end
echo on
clc
plotpc(net.iw{1,1},net.b{1})
pause % �����������ѵ����֪����Ԫ
net=train(net,P,T);
pause % ��������������ƽ����������
clc
plotpv(P,T);
plotpc(net.iw{1,1},net.b{1});
pause %  ���������������ѵ����ĸ�֪����Ԫ
clc
p = [0.7; 1.2];
a = sim(net,p)
echo off
