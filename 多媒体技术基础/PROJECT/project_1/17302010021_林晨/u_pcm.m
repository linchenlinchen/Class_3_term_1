function [a_quan]=u_pcm(a,n)
%U_PCM  	uniform PCM encoding of a sequence
%       	[A_QUAN]=U_PCM(A,N)
%       	a=input sequence.
%       	n=number of quantization levels (even).离散的数量
%		a_quan=quantized output before encoding.离散输出

% todo:
a_max = max(abs(a));%最大绝对值
a_quan = a ./ a_max;%归一化，虽然是这个例子里面可以认为就是1
format long 
d = 2/n;%取量化间隔
for i=-1:d:1
    a_quan(a_quan>=i & a_quan <i+d) = (2*i+d)/2;%调整各个区间内点到量化值
end


end
