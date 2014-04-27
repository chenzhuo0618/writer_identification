function [yind, mark] = pdtdfb2vec(y)
% PDTDFB2VEC   Convert the output of the PDTDFB into a vector form
%
%       [yind, cfig] = pdtdfb2vec(y)
%
% Input:
%   y:  an output of the PDTDFB
%
% Output:
%   yind :  1-D vector that contains all PDFB coefficients
%   mark :  starting point of each change in band in yind
%
% See also:	PDTDFBDEC, VEC2PDFB, (also PDFB2VEC in Contourlet toolbox)

if iscell(y{end})
    range = 2: length(y);
    S = 2*max(size(y{end}{1}{1}));
    for in = 1:(length(y)-1)
        cfig(in) = log2(length(y{in+1}{1}));
    end
else
    range = 2: length(y)-1;
    S = size(y{end}, 1);
    for in = 1:(length(y)-2)
        cfig(in) = log2(length(y{in+1}{1}));
    end
end
clear in;

% take out the directional subband complex amplitude value
tmp2 = [];
yind = [];
% band index
min = 0;
ind = 0;
for in = 1:length(range) % for each consider resolution
    
    for d = 1:length(y{range(in)}{1})
        min = min+1;
        tmp = y{range(in)}{1}{d}+j*y{range(in)}{2}{d};
        
        % first column is the starting point of the subband
        mark(min,1) = size(yind,1);
        % second column is the row size of the subband
        mark(min,2) = size(tmp,1);
         % third column is the column size of the subband
        mark(min,3) = size(tmp,2);
        % fourth column resolution the subband
        mark(min,4) = range(in);
        % fifth column direction the subband
        mark(min,5) = d;

        % [inc, inr] = meshgrid(1:Stmp(2), 1:Stmp(1));
        
        % 
        % tmp3 = [(tmp(:));
        
        yind = [yind; tmp(:)];
    end
end
