function [z]=ulaw(y,u)
%		u-law nonlinearity for nonuniform PCM
%		X=ULAW(Y,U).
%		Y=input vector.

% �Ƚ�Դ�źŽ���u������

% todo:
% u�����Ź�ʽ
z = signum(y) .* (log(1 + u * abs(y)) / log(1 + u));

end