function [a_quan]=u_pcm(a,n)
%U_PCM  	uniform PCM encoding of a sequence
%       	[A_QUAN]=U_PCM(A,N)
%       	a=input sequence.
%       	n=number of quantization levels (even).
%		a_quan=quantized output before encoding.

% todo:
a_quan = zeros(1, length(a));
% �������
delv = (max(a) - min(a)) / n;
for i = 1: length(a)
    %����ֵ���Ϊ1��ʱ�����
    if a(i) == 1 
        a_quan(i) = delv * (floor(a(i) / delv) - 1/2);
    %�����������
    else  
        a_quan(i) = delv * (floor(a(i) / delv) + 1/2);
    end
end
            
end
