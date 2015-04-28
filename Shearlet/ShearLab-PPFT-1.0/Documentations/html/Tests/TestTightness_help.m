%% TESTTIGHTNESS 
% Test Tightness of PPFT
%
%% Description
%  OUTPUT_TESTTIGHTNESS=TESTTIGHTNESS(N,R,BETA,Choice,REPS,LFILE)
%     Generate images I_1,...,I_REPS of size N,
%     oversampling rate R, basis CHOICE (see basisFunction), and 
%     randomly wth normally distributed entires. Compute
%
%     M_{tight_1} = \max_{i=1...reps} norm(S^\star SI_i-I_i,'fro')/norm(I_i,'fro').
%
%     M_{tight_2} = \max_{i=1...reps}norm(CG(I_i)-I_i,'fro')/norm(I_i,'fro');
%
%     Here S is the shearlet transform, CG using cg iteration for PPFT.
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
% <TestTimeFreqLoc_help.html TestTimeFreqLoc>
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
