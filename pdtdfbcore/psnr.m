function [gamma] = psnr(x,y)
% Takes two 8-bit IMAGES and computes peak-to-peak signal to noise ratio:
% gamma = 10 log (255^2/MSE)
% x and y must be the same dimension and may be 2D arrays or vectors.

sx = size(x);
sy = size(y);

if sx == sy
dd = x(:) - y(:);
gg = (dd' * dd)/prod(sx);
rr = 255^2./gg;
gamma = 10 * log10(rr);
else
fprintf ('\n Input image dimensions not consistent.');
gamma = NaN;
end
