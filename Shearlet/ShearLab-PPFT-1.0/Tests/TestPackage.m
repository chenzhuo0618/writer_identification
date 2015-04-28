%% TESTPACKAGE Perform the test for different measures
%  
%% Description (MEASURES)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% [D1] : Algebraic Exactness. 
%
% [D2] : Isometry of Pseudo-Polar Transform
%
% [D3] : Tight Frame Property.
%
% [D4] : Time-Frequency-Localization.  
% 
% [D5] : True Shear Invariance. 
%
% [D6] : Speed.
%
% [D7] : Geometric Exactness. 
%
% [D8] : Robustness.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%
%% See also  TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSHEARINVARIANCE, TESTSPEED, TESTGEOMEXACT, TESTROBUSTNESS,
% TESTTHRESHOLDING
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
%

clear
close all
clc

R      = 8;                   % Oversampling rate
reps   = 5;                   % Number of repetitions for Monte Carlo estimates
Nsmall = 256;                  % Size of small image for tests [D1], [D2], [D3] 
Choice = 5;                   % basis Choice on PPGRID
rangeN = [32 64 128 256 512]; % Range of sizes for test [D6]
beta   = 4;                   % either 2 for scaling 2^j or 4 for scaling 4^j

powerm = 50;                  % Number of iterations for power method for test [D2]

p1     = [2:2:20];            % Thresholds 1 for test [D8]
h      = 1e-3;
p2     = [h:10*h:h*100];      % p2=[0.5:0.5:5];  Thresholds 2 for test [D8]
q      = [8:-0.5:3.5];        % Alphabets for test [D8]

scale  = ceil(log(Nsmall)/log(beta))-2; % sclae j.
sector = 2;                   % time frequency localization D[4]
shear  = 0;                   % time frequency localization D[4]

s      = 0.5;                 % slope for testing shear invariance D[5]

for test_choice = [8] % Choice of tests!
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % [D1] : Algebraic Exactness. 
    %
    % [D2] : Isometry of Pseudo-Polar Transform
    %
    % [D3] : Tight Frame Property.
    %
    % [D4] : Time-Frequency-Localization.  
    % 
    % [D5] : True Shear Invariance. 
    %
    % [D6] : Speed.
    %
    % [D7] : Geometric Exactness. 
    %
    % [D8] : Robustness.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if test_choice == 1        
        filename = ['LogfileForAlgExactN' num2str(Nsmall) 'R' num2str(R) '.txt'];
        lfile    = fopen(filename, 'wt');
        
        t1  = tic;
        output_TestAlgExact = TestAlgExact(Nsmall,R,beta,reps,lfile);
        tsec = toc(t1);
        
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);     
    end;  
    
    if test_choice == 2         
        filename = ['LogfileForIsometryN' num2str(Nsmall) 'R' num2str(R) 'P' num2str(Choice) '.txt'];
        lfile    = fopen(filename, 'wt'); 
        
        t1   = tic;
        output_TestIsometry = TestIsometry(Nsmall,R,Choice,powerm,reps,lfile);
        tsec = toc(t1);
                
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);
    end; 
    
    if test_choice == 3         
        filename = ['LogfileForTightnessN' num2str(Nsmall) 'R' num2str(R) 'P' num2str(Choice) '.txt'];
        lfile = fopen(filename, 'wt'); % Initialization of Log-File        
        
        t1   = tic;
        output_TestTightness=TestTightness(Nsmall,R,beta,Choice,reps,lfile);
        tsec = toc(t1);
        
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);
    end; 
    
    if test_choice == 4
        filename = ['LogfileForTimeFreqLoc' num2str(Nsmall) 'R' num2str(R) 'Scale' num2str(scale) 'Sector' num2str(sector) 'Shear' num2str(shear) '.txt'];
        lfile = fopen(filename, 'wt'); % Initialization of Log-File
        
        t1   = tic;
        output_TestTimeFreqLoc = TestTimeFreqLoc(Nsmall,R,beta,scale,sector,shear,lfile);
        tsec = toc(t1);
        
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);        
    end;      
    
    if test_choice == 5 
        filename = ['LogfileForShearInvarianceN' num2str(Nsmall), 'R' num2str(R) 'Slope' num2str(s) '.txt'];
        lfile    = fopen(filename, 'wt'); % Initialization of Log-File  
        
        t1  = tic;
        output_TestShearInvariance = TestShearInvariance(Nsmall,R,beta,s,lfile);
        tsec= toc(t1);
       
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);
    end;
    
    if test_choice == 6
        filename = ['LogfileForSpeedR' num2str(R) '.txt'];
        lfile = fopen(filename, 'wt'); % Initialization of Log-File  
        
        t1   = tic;
        output_TestSpeed = TestSpeed(rangeN,R,beta,Choice,lfile);
        tsec = toc(t1);
 
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);
    end; 
    
    if test_choice == 7 
        filename = ['LogfileForGeomExactN' num2str(Nsmall) 'R' num2str(R) '.txt'];
        lfile = fopen(filename,'wt');
        
        t1   = tic;        
        output_TestGeomExact = TestGeomExact(Nsmall,R,beta,lfile);
        tsec = toc(t1);
        
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);
    end;  
    
    if test_choice == 8 
        filename = ['LogfileForRobustnessN' num2str(Nsmall) 'R' num2str(R) 'P' num2str(Choice) '.txt'];
        lfile = fopen(filename, 'wt'); % Initialization of Log-File       
        
        t1  = tic;
        output_TestRobustness = TestRobustness(Nsmall,R,beta,Choice,p1,p2,q,lfile);
        tsec= toc(t1);
        
        
        fprintf(lfile,'Elapsed time is %.2f seconds', tsec);
        fclose(lfile);        
    end; 
end; 
