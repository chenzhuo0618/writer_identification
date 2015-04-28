function output_TestIsometry=TestIsometry(N,R,Choice,powerm,reps,lfile)
%% TESTISOMETRY Test Isometry of PPFT
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
%% See also TESTALGEXACT, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSHEARINVARIANCE, TESTSPEED, TESTGEOMEXACT, TESTROBUSTNESS,
% TESTTHRESHOLDING, PPFT, ADJPPFT, GENERATEW
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

fprintf(lfile, 'Test Isometry: \n\n');
output_TestIsometry     = zeros(4,reps);
output_TestIsometry(1,1)= N;

C = generateW(N,R,Choice); % The Weighting matrix.
% Isometry
disp('Testing Isometry of Pseudo-Polar Transform P^*wP ~ Id ...');
for i = 1:reps
    disp(['i = ' num2str(i) '...']);
    X    = randn(N);
    FX   = ppFT(X,R);   
    FX   = C.*FX;
    RecX = AdjppFT(FX,R);
    
    ErrorMatrix   = RecX-X;
    NewMCEstimate = 0;
    NewMCEstimate = norm(ErrorMatrix,'fro')/norm(X,'fro');
    
    fprintf(lfile, 'N = %d, Iteration = %d, MCE1 = %f  \n',N,i,NewMCEstimate);
    output_TestIsometry(2,i) =  NewMCEstimate;
end;

fprintf(lfile, 'Closeness to tightness: Misom1(max,min,avg,median) = %f, %f, %f, %f\n\n', max(output_TestIsometry(2,:)),min(output_TestIsometry(2,:)),mean(output_TestIsometry(2,:)),median(output_TestIsometry(2,:)));
disp('Done!');

% Quality of Preconditioning
disp('Computing the Condition number of P^*wP...');

fprintf(lfile, 'Now the Spread of the Eigenvectors! \n');
  
[lmax,lmin]              = EigMaxMinFtCF(C,powerm,lfile);  
output_TestIsometry(3,1) = lmax/lmin;

fprintf(lfile, 'Quality of Preconditioning: Misom2 = %f', output_TestIsometry(3,1));
fprintf(lfile, '\n\n');

disp('Done!');

% Inverbility
disp('Testing Inverbility (x = arg min ||Px -y||_2) of Pseudo-Polar Transform Using CG Method...');

error = 1e-5; % default error control for CG
for i = 1:reps
    disp(['i = ' num2str(i) '...']);
    X = randn(N);
    FX = ppFT(X,R);     
    
    [RecX,its,res,tsec] = InvppFTCG(FX,N,C,error,0);
    
    ErrorMatrix   = RecX-X;
    NewMCEstimate = 0;
    NewMCEstimate = norm(ErrorMatrix,'fro')/norm(X,'fro');
    
    fprintf(lfile, 'N = %d, Iteration = %d, MCE3 = %E, CGIts = %d, CGResidual = %E, CGSec = %.2f \n',N,i, NewMCEstimate, its, res, tsec);
    output_TestIsometry(4,i) = NewMCEstimate;
    
    disp(['CG Iterations = ' num2str(its) '!']);
end;

fprintf(lfile, 'Inverbility of PPFT: Misom3(max,min,avg,median) = %E, %E, %E, %E\n\n', max(output_TestIsometry(4,:)),min(output_TestIsometry(4,:)),mean(output_TestIsometry(4,:)),median(output_TestIsometry(4,:)));
disp('Done!');

end