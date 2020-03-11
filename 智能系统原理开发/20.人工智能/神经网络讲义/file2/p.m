% Example 3.1
% 
clf reset
figure(gcf)
setfsize(300,300);
echo on

%NEWP ���� ����һ����֪����Ԫ
%INIT ���� �Ը�֪����Ԫ��ʼ��
%TRAIN ���� ѵ����֪����Ԫ
%SIM ���� �Ը�֪����Ԫ����
pause % �����������
clc
% PΪ����ʸ��
P = [-0.5 -0.5 +0.3 +0.0;
     -0.5 +0.5 -0.5 +1.0];
% TΪĿ��ʸ��
T = [1 1 0 0];
pause
clc
% ��������ʸ��ͼ
plotpv(P,T);
pause
clc
% �����֪����Ԫ�������ʼ��  
net=newp([-0.5 0.5;-0.5 1],1);
net.initFcn='initlay';
net.layers{1}.initFcn='initwb';
net.inputWeights{1,1}.initFcn='rands';
net.layerWeights{1,1}.initFcn='rands';
net.biases{1}.initFcn='rands';
net=init(net);
echo off
k = pickic;
if k == 2
  net.iw{1,1} = [-0.8161  0.3078];
  net.b{1} = [-0.1680];
end
echo on
plotpc(net.iw{1,1},net.b{1})
pause
% ѵ����֪����Ԫ
net=train(net,P,T);
pause
% ���ƽ����������
plotpv(P,T)
plotpc(net.iw{1,1},net.b{1});
pause
% ����ѵ����ĸ�֪����Ԫ����
p = [-0.5; 0];
a = sim(net,p)
echo off
