function y=signum(x)
%SIGNUM	finds the signum of a vector.
%	Y=SIGNUM(X)
%	X=input vector

% 将整个序列输入，返回他们的符号函数值
y=x;
y(find(x>0))=ones(size(find(x>0)));
y(find(x<0))=-ones(size(find(x<0)));
y(find(x==0))=zeros(size(find(x==0)));

end