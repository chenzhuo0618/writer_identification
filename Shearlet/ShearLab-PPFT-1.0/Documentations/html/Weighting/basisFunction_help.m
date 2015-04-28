%% BASISFUNCTION 
% generate basis functions on a pseudo-polar grid

%% Description
% P = BASISFUNCTION(N,R,CHOICE) generate basis functions on a pseudo-polar
% grid depending on the parameter CHOICE, N is the size of original image,
% R is the oversampling rate.
%
% CHOICE = 1
%    bases: 1-origin, 2-first line, 3-seam line (`*`|x`|`), 4-corner point,
%    5-interior (`*`|x`|), 6-boundary line, 7-corner point on seam line at -3
%    position.
%
% CHOICE = 2
%    bases: 1-origin, 2-first k0 lines, 3-interior after first k0 lines
%    (`*`|x`|), 4-seam line (`*`|x`|,include first k0 points), 5-boundary line.
%
% CHOICE = 3
%    bases: 1-origin, 2-first k0 lines, 3-interior after first k0
%    lines`*`|x`|, 4-seam line (`*`|x`|,exclude first k0 points), 5-boundary line.
%
% CHOICE = 4
%    bases: 1-origin, 2-first k0 lines, 3-interior after first k0 lines
%    (`*`|x`|), 4-seam line (`*`|x`|,include first k0 points), 5-boundary line.
%
% CHOICE = 5
%    bases: 1-origin, 2-corner point, 3-interior (`*`|x`|), 4-seam line (`*`|x`|)
%    , 5-boundary line. 
%
% CHOICE = 6
%    bases: 1-origin, 2-first k0 line interior (`*`|x`|^alpha), 3-after first
%    k0 line interior (`*`|x`|^beta), 4-seam line (`*`|x`|^gamma), 5-boundary line 
%    , 6-corner point.
%
% CHOICE = 7
%    bases: 1-origin, 2-first slope line (slope=0), 3-second slope line
%    (slope = 1/(N/2)),..., and last slope line (slope = 1).
%
% CHOICE = 8
%    bases: 1-origin, 2-first k0 line interior (`*`|x`|), 3-after first
%    k0 line interior (`*`|x`|), 4-first k0 point seam line (`*`|x`|), 5-after
%    first k0 point seam line (`*`|x`|), 6-corner point, 7-boundary line.
%
% CHOICE = 9
%    bases: 1-origin, 2-first line, 3-interior, 4-first k0 points seam line (`*`|x`|), 
%    5-after first k0 points seam line (`*`|x`|), 6-corner point,
%    7-boundary line.
%
% CHOICE = 10
%    bases: 1-origin, 2-first line, 3-first k0 line interior (exclude first
%    line `*`|x`|), 4-after first k0 line interior (`*`|x`|), 5-first k0 points 
%    seam line (`*`|x`|), 6-after first k0 points seam line (`*`|x`|), 
%    7-boundary line, 8-corner point.
%
% CHOICE = 11
%    bases: 1-origin, 2-interior, 3-first k0 point seam line, 4-after first
%    k0 point seam line, 5-boundary line, 6-corner point.
%
% CHOICE = 12
%    bases: 1-origin, 2-interior, 3-seam line.

%% Examples
    N = 128; R=4; Choice = 5;
    P = basisFunction(N,R,Choice);
    
%% See also 
% <../Utilities/getppCoordinate_help.html GETPPCOORDINATES>, 
% <findWeight_help.html FINDWEIGHT>,
% <WeightGenerate_help.html WEIGHTGENERATE>,
% <loadW_help.html LOADW>,
% <saveW_help.html SAVEW>.


%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
