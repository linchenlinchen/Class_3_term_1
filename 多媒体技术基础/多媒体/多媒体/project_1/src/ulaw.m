function [z]=ulaw(y,u)
%		u-law nonlinearity for nonuniform PCM
%		X=ULAW(Y,U).
%		Y=input vector.

% 先将源信号进行u律扩张

% todo:
% u律扩张公式
z = signum(y) .* (log(1 + u * abs(y)) / log(1 + u));

end