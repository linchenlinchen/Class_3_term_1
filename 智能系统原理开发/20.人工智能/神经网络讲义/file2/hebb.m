% Example 3.18
%
clf;
figure(gcf)
setfsize(300,250);
echo on
clc
%    HARDLIM - 阈值传递函数
%    LEARNH  - Hebb学习规则
pause
clc
P = [1 0 0;
     0 1 0;
     0 0 1;
     0 0 1;
     0 1 0];
pause
clc
[R,Q] = size(P); S = R;
W = eye(S);
b = -0.5 * ones(S,1);
pause
clc
hintonwb(W,b);
title('Original Biases and Weights');
pause
clc
P2 = eye(R);
A = hardlim(netsum(P2,concur(b,5)))
pause
clc
lp.lr = 1;
for q = 1:Q
   p = P(:,q);
   n=netsum(p,concur(b,1))
  a = hardlim(n);
  dW = learnh([],p,[],[],a,[],[],[],[],[],lp,[]);
  W = W + dW;
end
hintonwb(W,b)
title('Final Biases Weights');
pause
clc
P2 = eye(R);
A = hardlim(netsum(P2,concur(b,5)))
echo off
