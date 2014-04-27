function y2 = pdtdfbdec_f(im, nlevs, F2, alpha, res)
% PDTDFBDEC_F   Pyramidal Dual Tree Directional Filter Bank Decomposition
% using FFT at the multresolution FB and the first two level of dual DFB
% tree
%
%	y2 = pdtdfbdec_f(im, nlevs, F2, alpha, res)
%
% Input:
%   x:      Input image
%   nlevs:  vector of numbers of directional filter bank decomposition levels
%           at each pyramidal level (from coarse to fine scale).
%           0 : Laplacian pyramid level
%           1 : Wavelet decomposition
%           n : 2^n directional PDTDFB decomposition
%   F2:     [optional] Precomputed F window 
%   alpha:  [optional] Parameter for F2 window, incase F2 is not pre-computed
%   res :   [optional] Boolean value, specify weather existing residual
%           band
%
% Output:
%   y:      a cell vector of length length(nlevs) + 1, where except y{1} is
%           the lowpass subband, each cell corresponds to one pyramidal
%           level and is a cell vector that contains bandpass directional
%           subbands from the DFB at that level.
%
% See also:	PDTDFBREC_F, PDTDFBDEC
%
% Note : PDTDFB data structure y{resolution}{1}{1-2^n} : primal branch
%                              y{resolution}{2}{1-2^n} : dual branch

% running time for 1024 image size [3]: 
%                                  [5]:  sec
%                             [4 7 7 5]  : sec
%

if ~exist('res','var')
    res = 0 ; % default implementation 
end

Sz = size(im);
L = length(nlevs);
x = [0 0; 1 1; 0 1; 1 0];

if ~exist('alpha','var')
    alpha = 0.3;
end

if ~exist('F2','var')
    F2 = pdtdfb_win(Sz, alpha, L);
    disp('Precalculated window function will run much faster')
end

% residual band
imf = fft2(im);

if res
    % residual band
    imf2 = imf.*F2{L+1};
    y2{L+2} = ifft2(imf2);
end

for in = L+1:-1:2
    
    F = F2{in-1};
    
    n = nlevs(in-1);
    
    s = (1/2^(L+1-in))*Sz;
    [sy, sx] = meshgrid(0:1/s(2):(1-1/s(2)),0:1/s(1):(1-1/s(1)));
    sx = 2*pi*sx;    
    sy = 2*pi*sy;

    % low pass band
    imf2 = imf.*F{1};
    imf3 = periodize(imf2,s/2);
    im = 0.25*ifft2(imf3);
    
    imf2 = imf.*F{2};
    imf3 = periodize(imf2,s/2);
    im1 = 0.25*ifft2(imf3);
    y2{in}{1}{1} = real(im1);
    y2{in}{2}{1} = imag(im1);

    imf2 = exp(j*(sx+sy)).*imf.*F{3};
    imf3 = periodize(imf2,s/2);
    im1 = 0.25*ifft2(imf3);
    y2{in}{1}{2} = real(im1);
    y2{in}{2}{2} = imag(im1);

    imf2 = exp(j*(sy)).*imf.*F{4};
    imf3 = periodize(imf2,s/2);
    im1 = 0.25*ifft2(imf3);
    y2{in}{1}{3} = real(im1);
    y2{in}{2}{3} = imag(im1);

    imf2 = exp(j*(sx)).*imf.*F{5};
    imf3 = periodize(imf2,s/2);
    im1 = 0.25*ifft2(imf3);
    y2{in}{1}{4} = real(im1);
    y2{in}{2}{4} = imag(im1);
    
    % transform to FFT domain for next level processing
    imf = fft2(im);

    % --------------------------------------------------------------------
    if (n>2)
    % Ladder filter
    fname = 'pkva';
    if isstr(fname)
        f = ldfilter(fname);
    end
    y = y2{in}{1};
    % Now expand the rest of the tree
    % primal branch
    for l = 3:n
        % Allocate space for the new subband outputs
        y_old = y;
        y = cell(1, 2^l);

        % The first half channels use R1 and R2
        for k = 1:2^(l-2)
            i = mod(k-1, 2) + 1;
            [y{2*k}, y{2*k-1}] = fbdec_l(y_old{k}, f, 'p', i, 'per');
        end

        % The second half channels use R3 and R4
        for k = 2^(l-2)+1:2^(l-1)
            i = mod(k-1, 2) + 3;
            [y{2*k}, y{2*k-1}] = fbdec_l(y_old{k}, f, 'p', i, 'per');
        end

        % circlular shift to make the subband has minimum delay
        for inl = 1:4:2^(l-1)
            y{inl} = circshift(y{inl}, [0 1]);
        end
        for inl = 2^(l-1)+1:4:2^(l)
            y{inl} = circshift(y{inl}, [1 0]);
        end

        for l2 = l:-1:4
            for inl = 1:2:2^(l-2);
                csh = cshift(l2,abs(2^(l-2)-inl) );
                y{inl} = circshift(y{inl}, [0 csh]);
            end
            for inl = 2^(l-2)+1:2:2^(l-1);
                csh = cshift(l2,abs(2^(l-2)-inl) );
                y{inl} = circshift(y{inl}, [0 -csh]);
            end
            for inl = 2^(l-1)+1:2:3*2^(l-2);
                csh = cshift(l2,abs(3*2^(l-2)-inl));
                y{inl} = circshift(y{inl}, [csh 0]);
            end
            for inl = 3*2^(l-2)+1:2:2^(l);
                csh = cshift(l2,abs(3*2^(l-2)-inl));
                y{inl} = circshift(y{inl}, [-csh 0]);
            end
        end
    end
    
    % Backsampling
    y = backsamp(y);
    % Flip the order of the second half channels
    y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));
    y2{in}{1} = y;

    % dual branch
    y = y2{in}{2};
    for l = 3:n
        % Allocate space for the new subband outputs
        y_old = y;
        y = cell(1, 2^l);

        % The first half channels use R1 and R2
        for k = 1:2^(l-2)
            i = mod(k-1, 2) + 1;
            [y{2*k}, y{2*k-1}] = fbdec_l(y_old{k}, f, 'p', i, 'per');
        end

        % The second half channels use R3 and R4
        for k = 2^(l-2)+1:2^(l-1)
            i = mod(k-1, 2) + 3;
            [y{2*k}, y{2*k-1}] = fbdec_l(y_old{k}, f, 'p', i, 'per');
        end

        % circlular shift to make the subband has minimum delay
        for inl = 1:4:2^(l-1)
            y{inl} = circshift(y{inl}, [0 1]);
        end
        for inl = 2^(l-1)+1:4:2^(l)
            y{inl} = circshift(y{inl}, [1 0]);
        end

        for l2 = l:-1:4
            for inl = 1:2:2^(l-2);
                csh = cshift(l2,abs(2^(l-2)-inl) );
                y{inl} = circshift(y{inl}, [0 csh]);
            end
            for inl = 2^(l-2)+1:2:2^(l-1);
                csh = cshift(l2,abs(2^(l-2)-inl) );
                y{inl} = circshift(y{inl}, [0 -csh]);
            end
            for inl = 2^(l-1)+1:2:3*2^(l-2);
                csh = cshift(l2,abs(3*2^(l-2)-inl));
                y{inl} = circshift(y{inl}, [csh 0]);
            end
            for inl = 3*2^(l-2)+1:2:2^(l);
                csh = cshift(l2,abs(3*2^(l-2)-inl));
                y{inl} = circshift(y{inl}, [-csh 0]);
            end
        end
    end
    
    % Backsampling
    y = backsamp(y);
    % Flip the order of the second half channels
    y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));
    y2{in}{2} = y;
    
    end

end

y2{1} = im;

%---------------------------------
function csh = cshift(l2, re)
if l2 == 4
    csh = 1;
else
    % if rem < 4
    %    csh = 0;
    % else
    %    csh = 2;
    % end
    if l2 == 5
        tmp = floor(re/4);
        csh = 2^(l2-4)*tmp;
    else
        csh = 0;
    end
end


