function [a_quan]=ula_pcm(a,n,u)
%ULA_PCM 	u-law PCM encoding of a sequence
%       	[A_QUAN]=MULA_PCM(X,N,U).
%       	X=input sequence.
%       	n=number of quantization levels (even).     	
%		a_quan=quantized output before encoding.
%       U the parameter of the u-law

% todo:
after_u_law = ulaw(a,u);%根据非均匀量化函数得到每隔0.0001距离点的值。
quantized = u_pcm(after_u_law,n);%将上面的值进行数字化到有限个值。
a_quan=inv_ulaw(quantized,u);%反非均匀量化得到原来的。
end
