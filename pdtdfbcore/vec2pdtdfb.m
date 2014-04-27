function y = vec2pdtdfb(yind, cfig)
% VEC2PDTDFB   Convert the output of the PDTDFB into a vector form
%
%       [yind, cfig] = vec2pdtdfb(y)
%
% Input:
%   y:  an output of the PDTDFBDEC
%
% Output:
%   c:  1-D vector that contains all PDFB coefficients
%   s:  structure of PDFB output, which is a four-column matrix.  Each row
%       of s corresponds to one subband y{l}{d} from y, in which the first two
%       entries are layer index l and direction index d and the last two
%       entries record the size of y{l}{d}.
%
% See also:	PDFBDEC, VEC2PDFB

L = size(yind, 1);
% determine the size of image
% if L > 256*256
%     S = 512;
% else if L > 128*128 
%     S = 256;
%     else
%         S = 128;
%     end
% end

% y = mkZero_pdtdfb(S, cfig);

% take out the directional subband complex amplitude value
% if ~exist('cfig','var')
%     for in = 1: L
%         if mod(in,100000)==0
%             in
%         end
%         crow = yind(in,:);
%         y{crow(4)}{1}{crow(5)}(crow(2),crow(3)) = real(crow(1));
%         y{crow(4)}{2}{crow(5)}(crow(2),crow(3)) = imag(crow(1));
%     end
% else

cfig(end+1,1) = L;

for in = 1: size(cfig,1)-1
    tmp = yind(cfig(in,1)+1:cfig(in+1,1),:);
    nr = cfig(in,2);
    nc = cfig(in,3);
    res = cfig(in,4);
    dir = cfig(in,5);
    
    cband = reshape(tmp(:,1),nr, nc);
    y{res}{1}{dir} = real(cband);
    y{res}{2}{dir} = imag(cband);
end

%end

