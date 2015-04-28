%% TESTISOMETRY 
% Test Isometry of PPFT
%
%% Description
%  OUTPUT_TESTISOMETRY=TESTISOMETRY(N,R,CHOICE,POWERM,REPS,LFILE)
%     Generate images I_1,...,I_REPS of size N,
%     oversampling rate R, basis CHOICE (see basisFunction), and 
%     randomly wth normally distributed entires. Compute
%
%     M_{isom_1} = \max_{i=1...reps} norm(P^\star w PI_i-I_i,'fro')/norm(I_i,'fro').
%
%     M_{isom_2} = cond(P^\star w P);
%
%     M_{isom_3} = \max_{i=1...reps}norm(CG(I_i)-I_i,'fro')/norm(I_i,'fro');
%
%     Here P is the PPFT operator, w is the weighting matrix on ppgrid.
%     see PPFT, ADJPPFT, GENERATEW.
%
%% See also 
% <TestAlgExact_help.html  TestAlgExact>,
% <TestGeomExact_help.html  TestGeomExact>,
% <TestPackage_help.html TestPackage>,
% <TestQuantization_help.html TestQuantization>,
% <TestRobustness_help.html TestRobustness>,
% <TestShearInvariance_help.html  TestShearInvariance>,
% <TestSpeed_help.html TestSpeed>,
% <TestThresholding_help.html TestThresholding>,
% <TestTightness_help.html TestTightness>,
% <TestTimeFreqLoc_help.html TestTimeFreqLoc>
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
