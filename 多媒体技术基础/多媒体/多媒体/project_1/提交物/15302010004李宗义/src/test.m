t=0:0.0001:2*pi;
y=cos(t);

u_pcm_num = input('�������������������������');
ula_pcm_num = input('������u�ɵ�����������');
u = input('������uϵ����');

% z1��ʾ�����������ú��߱�ʾ
z1=u_pcm(y, u_pcm_num);
% z2��ʾ�Ǿ��������������߱�ʾ
z2=ula_pcm(y, ula_pcm_num, u);
plot(t,y,t,z1,'r',t,z2,'g');