function x=inv_ulaw(y,u)
%INV_ULAW		the inverse of u-law nonlinearity
%X=INV_ULAW(Y,U)	X=normalized output of the u-law nonlinearity.

% 将均匀量化的数据进行u律压缩

% todo:
% u律扩张的反函数
x = signum(y) .* (((1 + u) .^(abs(y)) - 1) ./ u);

end