function Q=setfsize(m,n)
%
figrect=get(gcf,'Position');
set(gcf,'Position',[figrect(1:2),m n]);