function y = dfbdec(x, fname, n)
% DFBDEC   Directional Filterbank Decomposition
%
%	y = dfbdec(x, fname, n)
%
% Input:
%   x:      input image
%   fname:  filter name to be called by DFILTERS
%   n:      number of decomposition tree levels
%
% Output:
%   y:	    subband images in a cell vector of length 2^n
%
% Note:
%   This is the general version that works with any FIR filters
%      
% See also: DFBREC, FBDEC, DFILTERS
% 
if (n ~= round(n)) | (n < 0)
    error('Number of decomposition levels must be a non-negative integer');
end

if n == 0
    % No decomposition, simply copy input to output
    y{1} = x;    
    return;
end

% Get the diamond-shaped filters
[h0, h1] = dfilters(fname, 'd');

if length(fname) > 5 %lat_optimx% in case of optimal lattice structure, 
    % the filter is already fan filter
    for i=1:4
        k0 = h0;
        k1 = h1;
    end
else
    % Fan filters for the first two levels
    %   k0: filters the first dimension (row)
    %   k1: filters the second dimension (column)
    k0 = modulate2(h0, 'c');
    k1 = modulate2(h1, 'c');
end

% Tree-structured filter banks
if n == 1
    % Simplest case, one level
    [y{1}, y{2}] = fbdec(x, k0, k1, 'q', '1r', 'per');
else
    % For the cases that n >= 2
    % First level
    [x0, x1] = fbdec(x, k0, k1, 'q', '1r', 'per');
    
    % Second level
    y = cell(1, 4);
    [y{1}, y{2}] = fbdec(x0, k0, k1, 'q', '2c', 'qper_col');
    [y{3}, y{4}] = fbdec(x1, k0, k1, 'q', '2c', 'qper_col');
    
    y{4} = circshift(y{4}, [1, 0]);
    
    % Fan filters from diamond filters
    [f0, f1] = ffilters(h0, h1);
    if strcmp(fname(1:3),'lat') % in case of lattice structure, dont use ffilters
        % because the filter is not LP
        for i=1:4
            f0{i} = k0;
            f1{i} = k1;
        end
    end
    % Now expand the rest of the tree
    for l = 3:n
        % Allocate space for the new subband outputs
        y_old = y;
        y = cell(1, 2^l);

        % The first half channels use R1 and R2
        for k = 1:2^(l-2)
            % i is 1 or 2
            i = mod(k-1, 2) + 1;
            [y{2*k-1}, y{2*k}] = fbdec(y_old{k}, f0{i}, f1{i}, 'pq', i, 'per');
            if l > 3
                if mod(k-1, 4) < 2
                    y{2*k} = circshift(y{2*k}, [0 1]);
                else
                    y{2*k} = circshift(y{2*k}, [0 -1]);
                end
            end

        end

        % The second half channels use R3 and R4
        for k = 2^(l-2)+1:2^(l-1)
            i = mod(k-1, 2) + 1;
            [y{2*k-1}, y{2*k}] = fbdec(y_old{k}', f0{i}, f1{i}, 'pq', i, 'per');
            if l > 3
                if mod(k-1, 4) < 2
                    y{2*k} = circshift(y{2*k}, [0 1]);
                else
                    y{2*k} = circshift(y{2*k}, [0 -1]);
                end
            end
            y{2*k-1} = y{2*k-1}';
            y{2*k} = y{2*k}';

        end
    end
end

% Back sampling (so that the overal sampling is separable) 
% to enhance visualization
y = backsamp(y);

% Flip the order of the second half channels
y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

