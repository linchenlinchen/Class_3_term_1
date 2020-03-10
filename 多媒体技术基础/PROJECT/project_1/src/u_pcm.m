function [a_quan]=u_pcm(a,n)
%U_PCM  	uniform PCM encoding of a sequence
%       	[A_QUAN]=U_PCM(A,N)
%       	a=input sequence.
%       	n=number of quantization levels (even).��ɢ������
%		a_quan=quantized output before encoding.��ɢ���

% todo:
a_max = max(abs(a));%������ֵ
a_quan = a ./ a_max;%��һ������Ȼ������������������Ϊ����1
format long 
d = 2/n;%ȡ�������
for i=-1:d:1
    a_quan(a_quan>=i & a_quan <i+d) = (2*i+d)/2;%�������������ڵ㵽����ֵ
end


end
