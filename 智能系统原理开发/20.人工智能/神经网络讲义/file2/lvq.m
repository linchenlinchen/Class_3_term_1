%Example 3.24
%
clf reset;
setfsize(400,400);
echo on
clc

P = [-3 -2 -2  0  0  0  0 +2 +2 +3;
      0 +1 -1 +2 +1 -1 -2 +1 -1  0];
C = [1 1 1 2 2 2 2 1 1 1];
T = ind2vec(C);
pause % Strike any key to plot these data points...
clc
colormap(hsv)
plotvec(P,C)
title('Input Vectors')
xlabel('P(1)')
ylabel('P(2)')

pause % Strike any key to create an LVQ network
clc
S = 4;
net=newlvq(minmax(P),S,[.6 .4],0.1,'learnlv2');
net.lw{2,1}
hold on
plot(net.iw{1,1}(1,1),net.iw{1,1}(1,2),'ow');
title('Input/Weight Vectors');
xlabel('P(1),W1(1)');
ylabel('P(2),W1(2)');

pause % Strike any key to train the LVQ network
clc
net.trainParam.show=20;
net.trainParam.epochs=1000;
net=train(net,P,T);
w1=net.iw{1,1}'
w2=net.lw{2,1}
w2=vec2ind(w2)
plotvec(w1,w2,'o');
hold off
pause % Strike any key to use competitive layer...
clc
p = [0; 0.2];
a1=compet(-dist(w1',p))
%a2=net.lw{2,1}*a1
a2=purelin(net.lw{2,1}*a1)
