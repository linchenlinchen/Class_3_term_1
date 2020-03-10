function [a_quan]=ula_pcm(a,n,u)
%ULA_PCM 	u-law PCM encoding of a sequence
%       	[A_QUAN]=MULA_PCM(X,N,U).
%       	X=input sequence.
%       	n=number of quantization levels (even).     	
%		a_quan=quantized output before encoding.
%       U the parameter of the u-law

% todo:
%先将源信号进行u律扩张
[ulaw_output] = ulaw(a, u);
%将扩张后的数据进行均匀量化
[u_output] = u_pcm(ulaw_output, n);
%将均匀量化的数据进行u律压缩
[a_quan] = inv_ulaw(u_output, u);

end
