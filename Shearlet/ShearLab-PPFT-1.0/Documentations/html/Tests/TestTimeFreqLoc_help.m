%% TESTTIMEFREQLOC 
% Time frequency localization Test.
%
%% Description
%  OUTPUT_TESTTIMEFREQLOC = TESTTIMEFREQLOC(N,R,BETA,SCALE,SECT,SHEAR,LFILE)
%   compute decay of a shearlet in time and frequency domains
%   SCALE: which level j
%   SECT : sect = 1,2,3,4
%   SHEAR: shear s = -2^{j}...2^{j}
%
%   Save measurements M_{decay_1}, M_{supp}, M_{decay_2}, M_{smooth_1},
%   and M_{smooth_2}
%
%% See also 
% <TestAlgExact_help.html  TestAlgExact>,
% <TestGeomExact_help.html  TestGeomExact>,
% <TestIsometry_help.html TestIsometry>,
% <TestPackage_help.html TestPackage>,
% <TestQuantization_help.html TestQuantization>,
% <TestRobustness_help.html TestRobustness>,
% <TestShearInvariance_help.html  TestShearInvariance>,
% <TestSpeed_help.html TestSpeed>,
% <TestThresholding_help.html TestThresholding>,
% <TestTightness_help.html TestTightness>,
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
