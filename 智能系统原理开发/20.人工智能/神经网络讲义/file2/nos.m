%Example 3.21
%
clf;
figure(gcf)
setfsize(120,300);
echo on
clc
pause
clc
P1 = [1 0];
P2 = [5  4;
     -2  1;
      3 -6];
pause
clc
W = zeros(3,1);
hintonw(W);
title('Original Weights');
pause
clc
A = purelin(W*1+0)
pause
clc
lp.lr = 1; % Ñ§Ï°ËÙÂÊ
for q=1:2
  p1 = P1(:,q);
  p2 = P2(:,q);
  a = purelin(W*P1+P2);
  dW = learnos(W,P1,[],[],a,[],[],[],[],[],lp,[]);
  W = W + dW;
end
hintonw(W)
title('Final Weights');
pause
clc
A = purelin(W*1+0)
echo off
