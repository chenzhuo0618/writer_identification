function savew(N,R,basisChoice)
%% SAVEW find weight constant and save it as files
%
%% Description
% SAVEW(N,R,BASISCHOICE) compute the weight constants in the basis
% functions and save them as files. N is the image size, R is the
% oversampling rate, basisChoice is the parameter 'Choice' in
% BASISFUNCTION. 
%
%% Examples
%     savew(128,2,5);
%
%% See also BASISFUNCTION, FINDWEIGHT, WEIGHTGENERATE, LOADW
%
%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck


clc
clear;
close all;

%for N = 16;             % image size N in [16 32 64 128 256 512];
%  for basisChoice = 1;  % basis choice in [1 2 3 4 5 6 7 8 9 10 11 12];
%    for R = [4]; % oversampling rate R in [2 4 8 16]  
    
       disp(['Now computing weights for R=' num2str(R) '. N=' num2str(N) '. Basis type=' num2str(basisChoice) '***TIME=' datestr(clock) '***']);
       
       tic
       m0 = 2/R*(R*N+1);
       NN = 'forceNN1';

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       P = basisFunction(N,R,basisChoice);
       disp(['Done with computing basis! *** TIME =' datestr(clock) ' ***']);

       [w,w0,w1,w2,Q,b,qh] = findWeight(P,N,NN);   
       W = [w0,w1,w2];

       str =['WeightN' num2str(N) 'R' num2str(R) 'P' num2str(basisChoice) '.mat']; 
       save(str,'W');
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       toc
%    end
%  end
%end

return

