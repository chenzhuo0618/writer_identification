function [c, d] = lpdec(x, h, g, opt, mode)
% LPDEC   Pyramid Decomposition
%
%	[c, d] = lpdec(x, h, g, opt, mode)
%
% Input:
%   x:      input image
%   h, g:   two one or two-dimesional filters, depend on opt.
%   opt :   Parameter define the mode of decomposition: 
%           0 : default, reconstructed by Do and Vetterli method.
%               See 'Framing Pyramids'
%           1 : reconstructed LP by the conventional (Burt-Andelson ) method
%               Not a tight frame reconstruction. See EUSIPCO 06 'On Aliasing ....'
%               h and g are 1-D filters
%           2 : no aliasing method, the lowpass filter h is nyquist 2  
%               g is the highpass filter, 0.25*h(w)^2+g(w)^2 = 1
%               h and g are 2-D filters
%               
%   mod :   Optional : 'sym' and 'per' specify the extension mode of the
%           low pass band
%
% Output:
%   c:      coarse image at half size
%   d:      detail image at full size
%
% See also:	LPREC, PDFBDEC

% Lowpass filter and downsample
if ~exist('mode','var')
    mode = 'per';
end

if ~exist('opt')
    opt = 0;
end

if opt < 2 % h , g is 1-D filter  ----------------------------------------
    xlo = sefilter2(x, h, h, mode);
    c = xlo(1:2:end, 1:2:end);

    % Compute the residual (bandpass) image by upsample, filter, and subtract
    % Even size filter needs to be adjusted to obtain perfect reconstruction
    adjust = mod(length(g) + 1, 2);

    xlo = zeros(size(x));
    xlo(1:2:end, 1:2:end) = c;
    d = x - sefilter2(xlo, g, g, mode, adjust * [1, 1]);
else % h , g is 2-D filter  ----------------------------------------
    % filtered
    d = efilter2(x, g,'sym');
    x_l = efilter2(x, 2*h,'sym');

    % decimation
    c = x_l(1:2:end,1:2:end);

end


