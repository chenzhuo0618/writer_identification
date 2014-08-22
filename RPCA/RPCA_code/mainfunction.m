clear;clc

% % Add path
addpath(genpath('E:\Jay\project\writer_identification\RPCA\RPCA_code\Augmented Lagrange Multiplier (ALM) Method'));

load ORL_64x64.mat

fea = fea';
expopt.nClass = 40;
expopt.nFace  = 10;
imagesize = [64,64];
Ntra_per = 8; % training number per class

tol = 1e-7; % for ALM
maxIter = 1000; % for ALM
epsilon = 0.003; % for sparse
alpha = 0.3; % for weighted based method

ran = randperm(expopt.nFace);
t = ran(1:Ntra_per); 
[traindata,testdata,trainIdx,testIdx] = genFold(fea,gnd,t,expopt);
Nfea = size(traindata,1);
Ntra = size(trainIdx,1);
Ntes = size(testIdx,1); 

% % %    Normalization
for i = 1:Ntra
    traindata(:,i) = traindata(:,i)./norm(traindata(:,i));
end
for i = 1:Ntes
    testdata(:,i) = testdata(:,i)./norm(testdata(:,i));
end
   
Ind_weighted = zeros(Ntes,1);
Ind_ratio = zeros(Ntes,1);

tic
for j = 1:Ntes
    testsample = testdata(:,j);
    
           for i = 1:expopt.nClass
               train_perclass = traindata(:,trainIdx==i);    
               
               [ Sparse, Smooth ] = RPCA( train_perclass, testsample, imagesize, tol, maxIter, epsilon);
               
               Num_sparse(i) = Sparse;               
               S_grad(i) = Smooth; 
           end 

           Num_sparse = (Num_sparse - min(Num_sparse)) ./ (max(Num_sparse) - min(Num_sparse)); % Normalization
            
           C = Num_sparse ./ S_grad; % ratio based method
           com_c = find(C==max(C));
           Ind_ratio(j) = com_c(1); 

           S_grad = (S_grad - max(S_grad)) ./ (min(S_grad) - max(S_grad)); % Normalization       
            
           Comb = alpha .* Num_sparse + (1 - alpha) .* S_grad; % sparse + smooth            
           com = find(Comb==max(Comb));
           Ind_weighted(j) = com(1);           
end
toc

Recog_rate1 = 100 .* sum(Ind_weighted == testIdx) ./ Ntes;
fprintf(['recogniton rate of weighted method is ' num2str(Recog_rate1)]);fprintf('\n');

Recog_rate2 = 100 .* sum(Ind_ratio == testIdx) ./ Ntes;
fprintf(['recogniton rate of ratio method is ' num2str(Recog_rate2)]);fprintf('\n');

