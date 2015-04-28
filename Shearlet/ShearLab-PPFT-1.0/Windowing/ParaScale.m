function Ntile = ParaScale(scale,beta)
%% PARASCALE return numbers of tiles for scale based on dilation beta
%
%% Description
%  Ntile = ParaScale(scale,beta)
%    if scale < 0 return 0;
%    if scale >=0 and beta == 2 return 2^[scale/2];
%    if scale >=0 and beta == 4 return 2^scale;
%  total tiles = [-Ntile:Ntile]
%
%% Examples
%     ParaScale(-1,2)
%     ParaScale(2, 4)
%
%% See also   MEYER, BUMPV, NV, WINDOWONPPGRID, ADJWINDOWONPPGRID

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

if scale < 0
    Ntile = 0;
elseif beta == 2
   half_scale = floor(scale/2);
   Ntile      = 2^half_scale;
elseif beta == 4
   half_beta  = beta/2;
   Ntile      = half_beta^scale;
else
   error('MishMash: beta is a mess')
end
