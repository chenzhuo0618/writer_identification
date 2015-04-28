% WEIGHTING
%
% Files
%   basisFunction  - generate basis functions on a pseudo-polar grid
%   findWeight     - find suitable weights on pseudo-polar grids in basis funtions.
%   fnnls          - Non-negative least-squares.
%   WeightGenerate - generate weight on a pseudo-polar grid based on N,R,Weight constant.
%   loadW          - load weight constants found by FINDWEIGHTS
%   saveW          - find weight constant and save it as files
%   generateW      - generate weighting matrix based on N, R, basisChoice
%   condW          - condition number for the operator (F*wF - Id)||^2.
%   errorW         - the frobenious error of ||F*wF I- I||^2/||I||^2
%   errorW_random  - Operator norm estimate for  ||F*wF I- I||^2/||I||^2 
%   Weights        - folder contains weight constants by saveW