%Example 3.27
%
clf;
figure(gcf)
setfsize(600,300);
echo on
clc
%    SOLVELIN - ���һ�����Բ�Solves for a linear layer.
%    SIMULIN   - �����Բ���з���
pause % �������������
clc
time = 0:0.025:5;  %
T = sin(time*4*pi);
%function P = delaysig(T,1,5);
d2=5;
d1=1;
[r,c]=size(T);
P=zeros(r*(d2-d1+1),c);
for i=0:(d2-d1)
   P((1:r)+r*i,(i+d1+1):c)=T(:,1:(c-i-d1));
end
pause % ��������������Բ쿴�źŲ���.
clc
plot(time,T)
%alabel('Time','Target Signal','Signal to be Predicted')
title('Signal to be predicted')
xlabel('Time')
ylabel('Target Signal')

pause % �����������ʼ�������...
clc
%    ����SOLVELIN����ȷ���ʵ���Ȩֵ����ֵ��ʹ�������ܹ��ƽ�ϵͳ
%[w,b] = solvelin(P,T)
net=newlind(P,T);
net.iw{1,1}
net.b{1}
pause % �����������ʼ�������������
clc
a = sim(net,P);
plot(time,a,time,T,'+')
%alabel('Time','Output _  Target +','Output and Target Signals')
title('Output and Target Signals')
xlabel('Time')
ylabel('Output _ Target +')
pause % ��������������Բ쿴����źŲ���
e = T-a;
plot(time,e)
hold on
plot([min(time) max(time)],[0 0],':r')
hold off
%alabel('Time','Error','Error Signal')
title('Error Signal')
xlabel('Time')
ylabel('Eorror')
echo off
