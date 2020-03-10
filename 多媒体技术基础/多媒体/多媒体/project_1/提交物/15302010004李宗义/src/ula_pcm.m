function [a_quan]=ula_pcm(a,n,u)
%ULA_PCM 	u-law PCM encoding of a sequence
%       	[A_QUAN]=MULA_PCM(X,N,U).
%       	X=input sequence.
%       	n=number of quantization levels (even).     	
%		a_quan=quantized output before encoding.
%       U the parameter of the u-law

% todo:
%�Ƚ�Դ�źŽ���u������
[ulaw_output] = ulaw(a, u);
%�����ź�����ݽ��о�������
[u_output] = u_pcm(ulaw_output, n);
%���������������ݽ���u��ѹ��
[a_quan] = inv_ulaw(u_output, u);

end
