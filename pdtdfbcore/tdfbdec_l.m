function y = tdfbdec_l(x, n, dfbtype, fname)
% TDFBDEC_L   Directional Filterbank Decomposition using Ladder Structure
%
%	y = dfbdec_l(x, f, n)
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

if (n ~= round(n)) | (n < 0)
    error('Number of decomposition levels must be a non-negative integer');
end

if n == 0
    % No decomposition, simply copy input to output
    y{1} = x;    
    return;
end

% Ladder filter
if isstr(fname)
    f = ldfilter(fname);
end

% Tree-structured filter banks
if n == 1
    % Simplest case, one level
    [y{1}, y{2}] = fbdec_l(x, f, 'q', '1r', 'per');

else
    % For the cases that n >= 2
    % First level
    % For the cases that n >= 2
    if strcmp(dfbtype, 'dual')
        [g0, g1] = dfilters('meyerh2', 'd');
        [g2, g3] = dfilters('meyerh3', 'd');

        % First level
        % remove aliasing on the high frequency
        %[x0, x1] = fbdec(x, [k0; zeros(2,size(k0,2))], [k1, zeros(size(k1,1),2)] , 'q', '1r', 'per');

        % complex filter
        x = circshift(x, [-1 0]);
        [x0, x1] = fbdec_l(x, f, 'q', '1r', 'per');
        
        xex = extend2(x1, 1, 0, 0, 0,'per');
        x1 = xex(1:end-1,:);        

        % Second level
        y = cell(1, 4);
        [y{1}, y{2}] = fbdec(x0, g0, g1, 'q', '2c', 'qper_col');
        y{2} = circshift(y{2}, [1, 1]);
        [y{3}, y{4}] = fbdec(x1, g2, g3, 'q', '2c', 'qper_col');
        y{4} = circshift(y{4}, [1, 0]);
    else
        [x0, x1] = fbdec_l(x, f, 'q', '1r', 'qper_col');

        % Second level
        y = cell(1, 4);
        [y{2}, y{1}] = fbdec_l(x0, f, 'q', '2c', 'per');
        [y{4}, y{3}] = fbdec_l(x1, f, 'q', '2c', 'per');
        y{3} = circshift(y{3}, [0 1]);
    end

    % Now expand the rest of the tree
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
end

% Backsampling
y = backsamp(y);

% Flip the order of the second half channels
y(2^(n-1)+1:end) = fliplr(y(2^(n-1)+1:end));

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
