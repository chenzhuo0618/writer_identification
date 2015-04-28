%% PARASCALE 
% return numbers of tiles for scale based on dilation beta
%
%% Description
%  Ntile = ParaScale(scale,beta)
%    if scale < 0 return 0;
%    if scale >=0 and beta == 2 return 2^[scale/2];
%    if scale >=0 and beta == 4 return 2^scale;
%  total tiles = [-Ntile:Ntile]
%
%% Examples
     ParaScale(-1,2)
     ParaScale(2, 4)

%% See also   
% <meyer_help.html MEYER>, 
% <bumpV_help.html BUMPV>, 
% <nv_help.html NV>, 
% <WindowOnPPGrid_help.html WINDOWONPPGRID>.
% <AdjWindowOnPPGrid_help.html ADJWINDOWONPPGRID>.


%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
