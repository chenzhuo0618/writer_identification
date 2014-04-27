function x = tdfbrec(y, dfbtype, fname)
% TDFBREC   Directional Filterbank Reconstruction in Time domain, use in
% the dual DFB 
%
%   x = tdfbrec(y, dfbtype,fname)
%
% Input:
%   y:	    subband images in a cell vector of length 2^n
%   dfbtype:   'primal' or 'dual', correspond to the type of the dual pdfb
%   fname:  filter name to be called by DFILTERS
%
% Output:
%   x:	    reconstructed image
%
% See also: TDFBDEC, FBREC, DFILTERS

n = log2(length(y));

if (n ~= round(n)) | (n < 0)
    error('Number of reconstruction levels must be a non-negative integer');
end
if ~exist('fname','var')
    fname = 'meyer'; % default implementation by the frequency method
end

if n == 0
    % Simply copy input to output
    x = y{1};
    return;
end

% Get the diamond-shaped filters
[h0, h1] = dfilters(fname, 'r');

% Fan filters for the first two levels
%   k0: filters the first dimension (row)
%   k1: filters the second dimension (column)
k0 = modulate2(h0, 'c');
k1 = modulate2(h1, 'c');

% Flip back the order of the second half channels
y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

% Undo backsampling
y = rebacksamp(y);

% Tree-structured filter banks
if n == 1
    % Simplest case, one level
    x = fbrec(y{1}, y{2}, k0, k1, 'q', '1r', 'per');
    
else
    % For the cases that n >= 2

    % Fan filters from diamond filters
    [f0, f1] = ffilters(h0, h1);

    % Recombine subband outputs to the next level
    for l = n:-1:3
        y_old = y;
        y = cell(1, 2^(l-1));

        % The first half channels use R1 and R2
        for k = 1:2^(l-2)
            i = mod(k-1, 2) + 1;

            % circlular shift to make the subband has minimum delay
            for inl = 4:l

                if mod(k-1, 2^(inl-2)) < 2^(inl-3)
                    y_old{2*k} = circshift(y_old{2*k}, [0 -2^(inl-4)]);
                else
                    y_old{2*k} = circshift(y_old{2*k}, [0 2^(inl-4)]);
                end

            end

            y{k} = fbrec(y_old{2*k-1}, y_old{2*k}, f0{i}, f1{i}, ...
                'pq', i, 'per');
        end
        
        % The second half channels use R3 and R4
        for k = 2^(l-2)+1:2^(l-1)
            i = mod(k-1, 2) + 1;
            y_old{2*k-1} = y_old{2*k-1}';
            y_old{2*k} = y_old{2*k}';
            
            for inl = 4:l

                if mod(k-1, 2^(inl-2)) < 2^(inl-3)
                    y_old{2*k} = circshift(y_old{2*k}, [0 -2^(inl-4)]);
                else
                    y_old{2*k} = circshift(y_old{2*k}, [0 2^(inl-4)]);
                end

            end

            %             if l > 3
            %                 if mod(k-1, 4) < 2
            %                     y_old{2*k} = circshift(y_old{2*k}, [0 -1]);
            %                 else
            %                     y_old{2*k} = circshift(y_old{2*k}, [0 1]);
            %                 end
            %             end
            %             if l > 4
            %                 if mod(k-1, 8) < 4
            %                     y_old{2*k} = circshift(y_old{2*k}, [0 -2]);
            %                 else
            %                      y_old{2*k} = circshift(y_old{2*k}, [0 2]);
            %                 end
            %             end

            y{k} = fbrec(y_old{2*k-1}, y_old{2*k}, f0{i}, f1{i}, ...
                'pq', i, 'per');
            y{k} = y{k}';

        end
    end

    if strcmp(dfbtype, 'dual')

        [g0, g1] = dfilters('meyerh2', 'r');
        [g2, g3] = dfilters('meyerh3', 'r');
        % Second level : shift channel 4
        y{4} = circshift(y{4}, [-1, 0]);
        x0 = fbrec(y{1}, y{2}, g0, g1, 'q', '2c', 'qper_col');
        x1 = fbrec(y{3}, y{4}, g2, g3, 'q', '2c', 'qper_col');
        % First level
        % remove aliasing on the high frequency 
        % x = fbrec(x0, x1, [zeros(2,size(k0,2)); k0 ], [zeros(size(k1,1),2), k1] , 'q', '1r', 'per');
        
        % firstlevel of dual branch: apply delay to filters
        x = fbrec(x0, x1, [k0, zeros(size(k0,1),2)], [k1; zeros(2,size(k1,2)) ] , 'q', '1r', 'per');
    else
        % Second level
        y{4} = circshift(y{4}, [-1, 0]);
        x0 = fbrec(y{1}, y{2}, k0, k1, 'q', '2c', 'qper_col');
        x1 = fbrec(y{3}, y{4}, k0, k1, 'q', '2c', 'qper_col');
        % First level
        x = fbrec(x0, x1, k0, k1, 'q', '1r', 'per');
    end
end
