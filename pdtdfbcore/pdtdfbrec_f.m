function im = pdtdfbrec_f(y2, F2, alpha, res)
% PDTDFBREC_F   Pyramid Dual Tree Directional Filterbank Reconstruction 
% using FFT at the multresolution FB and the first two level of dual DFB
% tree
%
%	im = pdtdfbrec_f(y2, F2, alpha, res)
%
% Input:
%   y:      a cell vector of length n+1, one for each layer of
%           subband images from DFB, y{1} is the low band image
%   F2:     [optional] Precomputed F window 
%   alpha:  [optional] Parameter for F2 window, incase F2 is not pre-computed
%   res :   [optional] Boolean value, specify weather existing residual
%           band
%
% Output:
%   IM:      reconstructed image
%
% Note : PDTDFB data structure y{resolution}{1}{1-2^n} : primal branch
%                              y{resolution}{2}{1-2^n} : dual branch
%

Sz = size(y2{1});
L = length(y2);

if ~exist('res','var')
  res = 0 ; % default implementation
end

if xor(~iscell(y2{end}), res)
    disp('wrong residual parameter');
    return
end

x = [0 0; 1 1; 0 1; 1 0];
im0 = y2{1};

if ~exist('alpha','var')
    alpha = 0.3;
end

if ~exist('F2','var')
    F2 = pdtdfb_win(2^(L-1)*Sz, alpha, L-1);
    disp('Precalculated window function will run much faster')
end

for in = 2:(L-res)

    n = log2(length(y2{in}{1}));

    % --------------------------------------------------------------------
    if (n>2)

        % Ladder filter
        fname = 'pkva';
        if isstr(fname)
            f = ldfilter(fname);
        end

        % Recombine subband outputs to the next level
        % primal branch ------------------------------------
        y = y2{in}{1};

        % Flip back the order of the second half channels
        y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

        % Undo backsampling
        y = rebacksamp(y);

        for l = n:-1:3
            y_old = y;
            y = cell(1, 2^(l-1));
            % The first half channels use R1 and R2
            % circlular shift to make the subband has minimum delay
            for l2 = l:-1:4
                for inl = 1:2:2^(l-2);
                    csh = cshift(l2,abs(2^(l-2)-inl) );
                    y_old{inl} = circshift(y_old{inl}, [0 -csh]);
                end
                for inl = 2^(l-2)+1:2:2^(l-1);
                    csh = cshift(l2,abs(2^(l-2)-inl) );
                    y_old{inl} = circshift(y_old{inl}, [0 csh]);
                end
                for inl = 2^(l-1)+1:2:3*2^(l-2);
                    csh = cshift(l2,abs(3*2^(l-2)-inl));
                    y_old{inl} = circshift(y_old{inl}, [-csh 0]);
                end
                for inl = 3*2^(l-2)+1:2:2^(l);
                    csh = cshift(l2,abs(3*2^(l-2)-inl));
                    y_old{inl} = circshift(y_old{inl}, [csh 0]);
                end
            end

            for inl = 1:4:2^(l-1)
                y_old{inl} = circshift(y_old{inl}, [0 -1]);
            end
            for k = 1:2^(l-2)
                i = mod(k-1, 2) + 1;
                y{k} = fbrec_l(y_old{2*k}, y_old{2*k-1}, f, 'p', i, 'per');
            end

            % circlular shift to make the subband has minimum delay
            for inl = 2^(l-1)+1:4:2^(l)
                y_old{inl} = circshift(y_old{inl}, [-1 0]);
            end
            % The second half channels use R3 and R4
            for k = 2^(l-2)+1:2^(l-1)
                i = mod(k-1, 2) + 3;
                y{k} = fbrec_l(y_old{2*k}, y_old{2*k-1}, f, 'p', i, 'per');
            end
        end

        y2{in}{1} = y;

        % dual branch ------------------------------------

        y = y2{in}{2};

        % Flip back the order of the second half channels
        y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

        % Undo backsampling
        y = rebacksamp(y);

        for l = n:-1:3
            y_old = y;
            y = cell(1, 2^(l-1));
            % The first half channels use R1 and R2
            % circlular shift to make the subband has minimum delay
            for l2 = l:-1:4
                for inl = 1:2:2^(l-2);
                    csh = cshift(l2,abs(2^(l-2)-inl) );
                    y_old{inl} = circshift(y_old{inl}, [0 -csh]);
                end
                for inl = 2^(l-2)+1:2:2^(l-1);
                    csh = cshift(l2,abs(2^(l-2)-inl) );
                    y_old{inl} = circshift(y_old{inl}, [0 csh]);
                end
                for inl = 2^(l-1)+1:2:3*2^(l-2);
                    csh = cshift(l2,abs(3*2^(l-2)-inl));
                    y_old{inl} = circshift(y_old{inl}, [-csh 0]);
                end
                for inl = 3*2^(l-2)+1:2:2^(l);
                    csh = cshift(l2,abs(3*2^(l-2)-inl));
                    y_old{inl} = circshift(y_old{inl}, [csh 0]);
                end
            end

            for inl = 1:4:2^(l-1)
                y_old{inl} = circshift(y_old{inl}, [0 -1]);
            end
            for k = 1:2^(l-2)
                i = mod(k-1, 2) + 1;
                y{k} = fbrec_l(y_old{2*k}, y_old{2*k-1}, f, 'p', i, 'per');
            end

            % circlular shift to make the subband has minimum delay
            for inl = 2^(l-1)+1:4:2^(l)
                y_old{inl} = circshift(y_old{inl}, [-1 0]);
            end
            % The second half channels use R3 and R4
            for k = 2^(l-2)+1:2^(l-1)
                i = mod(k-1, 2) + 3;
                y{k} = fbrec_l(y_old{2*k}, y_old{2*k-1}, f, 'p', i, 'per');
            end
        end

        y2{in}{2} = y;

    end
    % --------------------------------------------------------------------
    
    s = 2^(in-1)*Sz;
    [sy, sx] = meshgrid(0:1/s(2):(1-1/s(2)),0:1/s(1):(1-1/s(1)));
    sx = 2*pi*sx;    
    sy = 2*pi*sy;

    F = F2{in-1};
    
    
    im0f = kron(ones(2),fft2(im0));
    im1f = kron(ones(2),fft2(y2{in}{1}{1}+j*y2{in}{2}{1}));
    im2f = exp(-j*(sx+sy)).*kron(ones(2),fft2(y2{in}{1}{2}+j*y2{in}{2}{2}));
    im3f = exp(-j*(sy)).*kron(ones(2),fft2(y2{in}{1}{3}+j*y2{in}{2}{3}));
    im4f = exp(-j*(sx)).*kron(ones(2),fft2(y2{in}{1}{4}+j*y2{in}{2}{4}));

    imf = im0f.*F{1} + im1f.*conj(F{2}) + im2f.*conj(F{3}) + ...
        + im3f.*conj(F{4}) + im4f.*conj(F{5});
    
    if  in < (L-res)
        im0 = real(ifft2(imf));
    else
        if res
            % transform to FFT domain
            imfres = fft2(y2{end});
            % residual band
            imf2 = imfres.*F2{end};
            % inverse fft
            im = real(ifft2(imf+imf2));
        else
            im = real(ifft2(imf));
        end
    end

end


% im = im0;

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
    csh = 2*tmp;
    else
        csh = 0;
    end
end
