function x = tdfbrec_l(y, dfbtype, fname)
% TDFBREC_L   Directional Filterbank Reconstruction using Ladder Structure
%
%	x = dfbrec_l(y, fname)
%
% Input:
%   y:	    subband images in a cell vector of length 2^n
%   dfbtype:   'primal' or 'dual', correspond to the type of the dual pdfb
%   fname:  filter name to be called by DFILTERS
%
% Output:
%   x:	    reconstructed image
%
% See also:	DFBDEC, FBREC, DFILTERS

n = log2(length(y));

if (n ~= round(n)) | (n < 0)
    error('Number of reconstruction levels must be a non-negative integer');
end

if n == 0
    % Simply copy input to output
    x = y{1};
    return;
end

% Ladder filter
if isstr(fname)
    f = ldfilter(fname);
end

% Flip back the order of the second half channels
y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

% Undo backsampling
y = rebacksamp(y);

% Tree-structured filter banks
if n == 1
    % Simplest case, one level
    x = fbrec_l(y{1}, y{2}, f, 'q', '1r', 'per');
    
else
    % For the cases that n >= 2
    
    % Recombine subband outputs to the next level
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


    if strcmp(dfbtype, 'dual')

        [g0, g1] = dfilters('meyerh2', 'r');
        [g2, g3] = dfilters('meyerh3', 'r');
        % Second level : shift channel 4
        y{2} = circshift(y{2}, [-1, -1]);
        x0 = fbrec(y{1}, y{2}, g0, g1, 'q', '2c', 'qper_col');
        
        y{4} = circshift(y{4}, [-1, 0]);
        x1 = fbrec(y{3}, y{4}, g2, g3, 'q', '2c', 'qper_col');
        % First level
        % remove aliasing on the high frequency
        % x = fbrec(x0, x1, [zeros(2,size(k0,2)); k0 ], [zeros(size(k1,1),2), k1] , 'q', '1r', 'per');

        % First level
        xex = extend2(x1, 0, 1, 0, 0,'per');
        x1 = xex(2:end,:);
        % x1 = circshift(x1, [-1 0]);
        x = fbrec_l(x0, x1, f, 'q', '1r', 'per');
        x = circshift(x, [1 0]);

        % firstlevel of dual branch: apply delay to filters
        % x = fbrec(x0, x1, [k0, zeros(size(k0,1),2)], [k1; zeros(2,size(k1,2)) ] , 'q', '1r', 'per');
    else
        y{3} = circshift(y{3},[0 -1]);
        % Second level
        x0 = fbrec_l(y{2}, y{1}, f, 'q', '2c', 'per');
        x1 = fbrec_l(y{4}, y{3}, f, 'q', '2c', 'per');

        % First level
        x = fbrec_l(x0, x1, f, 'q', '1r', 'qper_col');
    end

end

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


        

