t=0:0.0001:2*pi;
y=cos(t);

u_pcm_num = input('请输入均匀量化的量化级数：');
ula_pcm_num = input('请输入u律的量化级数：');
u = input('请输入u系数：');

% z1表示均匀量化，用红线表示
z1=u_pcm(y, u_pcm_num);
% z2表示非均匀量化，用绿线表示
z2=ula_pcm(y, ula_pcm_num, u);
plot(t,y,t,z1,'r',t,z2,'g');