function output_TestTightness=TestTightness(N,R,beta,Choice,reps,lfile)
%% TESTTIGHTNESS Test Tightness of PPFT
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
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIMEFREQLOC,
% TESTSHEARINVARIANCE, TESTSPEED, TESTGEOMEXACT, TESTROBUSTNESS,
% TESTTHRESHOLDING, SHEARLETTRANSFORM, ADJSHEARLETTRANSFORM,
% INVSHEARLETTRANSFORM, 
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

fprintf(lfile, 'Test Tightness: \n');

output_TestTightness      = zeros(3,reps);
output_TestTightness(1,1) = N;

C = generateW(N,R,Choice); % weighting matrix.

for i = 1:reps
    disp(['Testing Tightness Using AdjppFT, i = ' num2str(i)]);
    
    t_i = tic;
    X   = randn(N);
    ShX = ShearletTransform(X,R,beta,C);
    RecX= AdjShearletTransform(ShX,N,R,beta,C);
    t_e = toc(t_i);
    
    ErrorMatrix   = RecX-X;
    NewMCEstimate = norm(ErrorMatrix,'fro')/norm(X,'fro');
    
    output_TestTightness(2,i)= NewMCEstimate;
    fprintf(lfile, 'N = %d, Iteration = %d , MCE = %f, Total Time = %.2f sec\n',N,i,NewMCEstimate,t_e);
end;

fprintf(lfile, 'Tight Frame Property(AdjointPPFT): Mtight1(max,min,avg,median) = %f,%f,%f,%f\n\n', max(output_TestTightness(2,:)), min(output_TestTightness(2,:)), mean(output_TestTightness(2,:)), median(output_TestTightness(2,:)));

for i = 1:reps
    disp(['Testing Tightness Using InvppFTCG, i = ' num2str(i)]);
        
    X    = randn(N);    
    t_i  = tic; 
    ShX  = ShearletTransform(X,R,beta,C);
    [RecX,it,res] = InvShearletTransform(ShX,N,R,beta,C);
    t_e  = toc(t_i);
    
    ErrorMatrix   = RecX-X;
    NewMCEstimate = norm(ErrorMatrix,'fro')/norm(X,'fro');
    
    output_TestTightness(3,i) = NewMCEstimate;
    fprintf(lfile, 'N = %d, Iteration = %d , MCE = %E, CGits = %d, CGres = %E, Total Time = %.2f sec\n',N,i,NewMCEstimate,it,res,t_e);
end;

fprintf(lfile, 'Tight Frame Property(InvPPFT): Mtight2(max,min,avg,median) = %E,%E,%E,%E\n', max(output_TestTightness(3,:)),min(output_TestTightness(3,:)),mean(output_TestTightness(3,:)),median(output_TestTightness(3,:)));
fprintf(lfile, '\n');

end
