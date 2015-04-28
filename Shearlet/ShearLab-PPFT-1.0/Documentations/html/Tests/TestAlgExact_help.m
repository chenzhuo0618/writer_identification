%% TESTALGEXACT 
% Test Algebraic Exactness
%
%% Description
%  OUTPUT_TESTALGEXACT=TESTALGEXACT(N,R,BETA,REPS,LFILE)
%     Generate pseudo-polar images I_1,...,I_REPS of original image size N,
%     oversampling rate R, scaling factor BETA, and 
%     randomly wth normally distributed entires. Compute
%
%     M_{alg} = \max_{i=1...reps} norm(W^\star WI_i-I_i,'fro')/norm(I_i,'fro').
%
%     Here W is the Windowing operator, see routines 
%     WINDOWONPPGRID, ADJWINDOWONPPGRID.
%
%% See also
% <TestGeomExact_help.html TestGeomExact>,
% <TestIsometry_help.html TestIsometry>,
% <TestPackage_help.html TestPackage>,
% <TestQuantization_help.html TestQuantization>,
% <TestRobustness_help.html TestRobustness>,
% <TestShearInvariance_help.html  TestShearInvariance>,
% <TestSpeed_help.html TestSpeed>,
% <TestThresholding_help.html TestThresholding>,
% <TestTightness_help.html TestTightness>,
% <TestTimeFreqLoc_help.html TestTimeFreqLoc>

%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
