function [a_quan]=ula_pcm(a,n,u)
%ULA_PCM 	u-law PCM encoding of a sequence
%       	[A_QUAN]=MULA_PCM(X,N,U).
%       	X=input sequence.
%       	n=number of quantization levels (even).     	
%		a_quan=quantized output before encoding.
%       U the parameter of the u-law

% todo:
after_u_law = ulaw(a,u);%���ݷǾ������������õ�ÿ��0.0001������ֵ��
quantized = u_pcm(after_u_law,n);%�������ֵ�������ֻ������޸�ֵ��
a_quan=inv_ulaw(quantized,u);%���Ǿ��������õ�ԭ���ġ�
end
