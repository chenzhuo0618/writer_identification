function output_TestAlgExact=TestAlgExact(N,R,beta,reps,lfile)
%% TESTALGEXACT Test Algebraic Exactness
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
%% See also TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSHEARINVARIANCE, TESTSPEED, TESTGEOMEXACT, TESTROBUSTNESS,
% TESTTHRESHOLDING, WINDOWONPPGRID, ADJWINDOWONPPGRID.
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

fprintf(lfile, 'Test Algebraic Exactness: \n\n');

output_TestAlgExact     = zeros(2,reps);
output_TestAlgExact(1,1)= N;

for i = 1:reps
    FX   = randn(2,R*N+1,N+1);
    ShX  = WindowOnPPGrid(FX,beta);    
    RecFX= AdjWindowOnPPGrid(ShX,N,R,beta);
    
    ErrorMatrix   = FX-RecFX;
    NewMCEstimate = 0;
    NewMCEstimate = norm(reshape(ErrorMatrix,2*(R*N+1),N+1),'fro')/norm(reshape(FX,2*(R*N+1),N+1),'fro');
    
    fprintf(lfile,'N = %d, Iteration = %d, MCE = %E \n',N,i,NewMCEstimate);
    output_TestAlgExact(2,i)=NewMCEstimate;
end;

fprintf(lfile, '\n');
fprintf(lfile, 'M_alg (max,avg,median) = %E, %E, %E \n', max(output_TestAlgExact(2,:)),mean(output_TestAlgExact(2,:)),median(output_TestAlgExact(2,:)));
fprintf(lfile, '\n');

end