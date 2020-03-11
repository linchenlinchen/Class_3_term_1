%Example 3.30
%
echo off
clf;
figure(gcf)
setfsize(600,250);
deg2rad = pi/180;
rand('seed',24792483);
echo on
clc
%    INITFF   - 初始化前向网络
%    TRAINCON - 训练神经网络控制器
%    SIMUFF    - 对神经网络进行仿真
pause % 键入任意键继续
clc
load appcs2d

pause %
clc
%(vel = 0, demand = angle).
 %angle = [-10:40:190]*deg2rad;
 %vel = [-90:36:90]*deg2rad;
 %demand = [-180:40:180]*deg2rad;
 %angle2 = [-10:10:190]*deg2rad;
 %Pc = [combvec(angle,vel,demand) [angle2; zeros(size(angle2)); angle2]];
pause
clc
 %timestep = 0.05;
 %Q = length(Pc);
 %Tc = zeros(2,Q);
 %for i=1:Q
  % [ode_time,ode_state] = ode23('plinear',0,timestep,Pc(:,i));
  % Tc(:,i) = ode_state(length(ode_state),1:2)' - Pc(1:2,i);
 %end
 %save appcs2d Q timestep Pc Tc mW1 mb1 mW2 mb2

pause % 键入任意键，开始设计神经网络控制器
clc
S1 = 8;
[cW1,cb1,cW2,cb2] = initff(Pc,S1,'tansig',1,'purelin');
pause %键入任意键，开始训练神经网络..
clc
df = 5;              % 训练过程的显示频率
me = 600;            % 最多训练600步
eg = (0.002^2)*Q*2;  % 误差指标
mu = 1e-5;           %
tp = [df me eg NaN mu];
 [cW1,cb1,cW2,cb2,ep,tr] = traincon(cW1,cb1,cW2,cb2,mW1,mb1,mW2,mb2,Pc,Tc,tp);
pause %
clc
appcs2b
