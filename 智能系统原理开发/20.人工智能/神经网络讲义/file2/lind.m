% Example 3.8
%
clf;
figure(gcf)
setfsize(500,200);
echo on
clc

%NEWLIND ���� ����һ������������ 
%SIM ���� ���������������
pause
clc
P = [1.0 -1.2];
T = [0.5 1.0];
pause

%�����������
w_range = -1:0.1:1;
b_range = -1:0.1:1;
ES = errsurf(P,T,w_range,b_range,'purelin');
plotes(w_range,b_range,ES);
pause

%���һ������������
net=newlind(P,T);
W=net.iw{1,1}
b=net.b{1}
pause

%����������
A = sim(net,P);
E = T - A;
SSE = sumsqr(E)
%����������ϻ���Ȩ��ƫ���λ��
plotep(W,b,SSE)

p = -1.2;
a = sim(net,p)
echo off
