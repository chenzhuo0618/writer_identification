function x = lprec(c, d, h, g, opt, mode)
% LPDEC   Pyramid Reconstruction
%
%	x = lprec(c, d, h, g, opt,mode)
%
% Input:
%   c:      coarse image at half size
%   d:      detail image at full size
%   h, g:   two one or two-dimesional  filter, depend on opt
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
%   x:      reconstructed image
%
% See also:	LPDEC, PDFBREC
%

if ~exist('opt')
    opt = 0;
end

% mode = 'per';
if ~exist('mode','var')
    mode = 'per';
end

if opt < 2 % h , g is 1-D filter  ----------------------------------------
    if opt % opt = 1 LP Burt-Andelson
        xhi = zeros(size(c));
    else % opt = 0 LP Framing Pyramid
        % First, filter and downsample the detail image
        xhi = sefilter2(d, h, h, mode);
        xhi = xhi(1:2:end, 1:2:end);
    end

    % Subtract from the coarse image, and then upsample and filter
    xlo = c - xhi;
    xlo = dup(xlo, [2, 2]);

    % Even size filter needs to be adjusted to obtain
    % perfect reconstruction with zero shift
    adjust = mod(length(g) + 1, 2);

    xlo = sefilter2(xlo, g, g, mode, adjust * [1, 1]);
    % Final combination
    x = xlo + d;
else % h , g is 2-D filter  ----------------------------------------
    % filtered
    x_u = kron(c, [1 0 ; 0 0]);
    x = efilter2(d, g,'sym') + efilter2(x_u, 2*h,'sym');
end
