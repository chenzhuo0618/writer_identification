function y = tdfbdec(x, n, dfbtype, fname)
% TDFBDEC   Directional Filterbank Reconstruction in Time domain, use in
% the dual DFB 
%	y = tdfbdec(x, n, dfbtype,fname)
%
% Input:
%   x:      input image
%   n:      number of decomposition tree levels
%   dfbtype:   'primal' or 'dual', correspond to the type of the dual pdfb
%   fname:  filter name to be called by DFILTERS
%
% Output:
%   y:	    subband images in a cell vector of length 2^n
%
% Note:
%   This is the general version that works with any FIR filters
%
% See also: TDFBREC, FBDEC, DFILTERS
% Note : The function is based on the dfbdec fuction of the contourlet toolbox
%
if (n ~= round(n)) | (n < 0)
    error('Number of decomposition levels must be a non-negative integer');
end

if ~exist('fname','var')
    fname = 'meyer'; % default implementation by the frequency method
end

if n == 0
    % No decomposition, simply copy input to output
    y{1} = x;
    return;
end

% Get the diamond-shaped filters
[h0, h1] = dfilters(fname, 'd');

% Fan filters for the first two levels
%   k0: filters the first dimension (row)
%   k1: filters the second dimension (column)
k0 = modulate2(h0, 'c');
k1 = modulate2(h1, 'c');

% Tree-structured filter banks
if n == 1
    % Simplest case, one level
    [y{1}, y{2}] = fbdec(x, k0, k1, 'q', '1r', 'per');
else
    % For the cases that n >= 2
    if strcmp(dfbtype, 'dual')
        [g0, g1] = dfilters('meyerh2', 'd');
        [g2, g3] = dfilters('meyerh3', 'd');

        % First level
        % remove aliasing on the high frequency 
        %[x0, x1] = fbdec(x, [k0; zeros(2,size(k0,2))], [k1, zeros(size(k1,1),2)] , 'q', '1r', 'per'); 
        
        % complex filter
        [x0, x1] = fbdec(x, [zeros(size(k0,1),2) , k0 ], [zeros(2,size(k1,2)); k1] , 'q', '1r', 'per');


        % Second level
        y = cell(1, 4);
        [y{1}, y{2}] = fbdec(x0, g0, g1, 'q', '2c', 'qper_col');
        [y{3}, y{4}] = fbdec(x1, g2, g3, 'q', '2c', 'qper_col');
            
    else
        % First level
        [x0, x1] = fbdec(x, k0, k1, 'q', '1r', 'per');

        % Second level
        y = cell(1, 4);
        [y{1}, y{2}] = fbdec(x0, k0, k1, 'q', '2c', 'qper_col');
        [y{3}, y{4}] = fbdec(x1, k0, k1, 'q', '2c', 'qper_col');
    end
    
    y{4} = circshift(y{4}, [1, 0]);

    % Fan filters from diamond filters
    [f0, f1] = ffilters(h0, h1);
    % Now expand the rest of the tree
    for l = 3:n
        % Allocate space for the new subband outputs
        y_old = y;
        y = cell(1, 2^l);
        
        % The first half channels use R1 and R2
        for k = 1:2^(l-2)
            i = mod(k-1, 2) + 1;
            [y{2*k-1}, y{2*k}] = fbdec(y_old{k}, f0{i}, f1{i}, 'pq', i, 'per');
            % circlular shift to make the subband has minimum delay 
            for inl = 4:l

                if mod(k-1, 2^(inl-2)) < 2^(inl-3)
                    y{2*k} = circshift(y{2*k}, [0 2^(inl-4)]);
                else
                    y{2*k} = circshift(y{2*k}, [0 -2^(inl-4)]);
                end

            end
            

        end

        % The second half channels are transposed
        for k = 2^(l-2)+1:2^(l-1)
            i = mod(k-1, 2) + 1;
            [y{2*k-1}, y{2*k}] = fbdec(y_old{k}.', f0{i}, f1{i}, 'pq', i, 'per');

            % circlular shift to make the subband has minimum delay
            for inl = 4:l

                if mod(k-1, 2^(inl-2)) < 2^(inl-3)
                    y{2*k} = circshift(y{2*k}, [0 2^(inl-4)]);
                else
                    y{2*k} = circshift(y{2*k}, [0 -2^(inl-4)]);
                end

            end

            % transpose back
            y{2*k-1} = y{2*k-1}.';
            y{2*k} = y{2*k}.';
        end
    end
end

% Back sampling (so that the overal sampling is separable)
% to enhance visualization
y = backsamp(y);

% Flip the order of the second half channels
y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

