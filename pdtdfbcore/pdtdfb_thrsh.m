function y = pdtdfb_thrsh(y, method, prm, cfg)
% PDTDFB_THRSH : Threshold the PDTDFB data structure
%        yth = pdtdfb_thrsh(y, method, prm, [range])
% Keep a number of high coefficient in the directional subband of the
% PDTDFB data structure
%
% Input:
%   y       :  PDTDFB data structure
%   in      :  index value matrix
%   method  :  method of reset the coefficient
%       'threshold'     Keep coefficient bigger than prm
%   prm     paramater to complement method
%       'threshold'     prm is the threshold
%
% Output:
%   ang:	the angle of direction of the band in radian
%
% Note: BY default, the considered dfb level is always 2 in the pdtdfb data
% structure y
%
% See also: KEEPTOP, FINDTOP,  MKZERO_PDTDFB, PDTDFB_STAT

L = length(y);
if length(prm) ~= L
        disp('Length prm should be the same as y');
end

if iscell(y{end})
    % no residual band
    for in1 = 2:L
        thresh = prm(in1);
        if iscell(y{in1}{1})
            % pdtdfb data
            for in2 = 1:length(y{in1}{1});
                tmp = abs(y{in1}{1}{in2}+j*y{in1}{2}{in2});
                idx = tmp < thresh;
                y{in1}{1}{in2}(idx) = 0;
                y{in1}{2}{in2}(idx) = 0;
            end
        else
            % wavelet data
            for in2 = 1:length(y{in1});
                tmp = abs(y{in1}{in2});
                idx = tmp < thresh;
                y{in1}{in2}(idx) = 0;
            end
        end
    end
else
    % residual band
    for in1 = 2:L-1
        thresh = prm(in1);
        if iscell(y{in1}{1})
            % pdtdfb data
            for in2 = 1:length(y{in1}{1});
                tmp = abs(y{in1}{1}{in2}+j*y{in1}{2}{in2});
                idx = tmp < thresh;
                y{in1}{1}{in2}(idx) = 0;
                y{in1}{2}{in2}(idx) = 0;
            end
        else
            % wavelet data
            for in2 = 1:length(y{in1});
                tmp = abs(y{in1}{in2});
                idx = tmp < thresh;
                y{in1}{in2}(idx) = 0;
            end
        end
    end
    tmp = abs(y{L});
    thresh = prm(L);
    idx = tmp < thresh;
    y{L}(idx) = 0;
end


