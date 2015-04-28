%% PPVIEW 
% display data in pp form
%
%% DESCRIPTION
%    PPVIEW(s);
%    display image on a pp grid. 
%    INPUT 
%        s - absolute value of image on a pp grid
%
%% EXAMPLE
     X = zeros(256);
     X(129,:) = 1;
     X = imShear(X,0.5);
     Y = ppFT(X,2);
     figure(1);
     subplot(1,2,1),imshow(X);
     subplot(1,2,2),ppview(abs(Y));

%% See also 
% <PlotShearletImage_help.html PLOTSHEARLETIMAGE>,
% <displayShX_help.html DISPLAYSHX>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
