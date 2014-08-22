function [ Sparse, Smooth ] = RPCA( trainsample, testsample, imagesize, tol, maxIter,epsilon)
%RPCA Summary of this function goes here
%   Detailed explanation goes here

% Generally, tol and maxIter are fixed to 1e-7 and 1000, respectively.
% epsilon = 0.003;

M = [trainsample testsample];
s = size(M);
s = max(s(1),s(2));
lambda = 1./sqrt(s);

[A_hat E_hat iter] = inexact_alm_rpca(M, lambda, tol, maxIter); % M = A_hat + E_hat            
E_test = E_hat(:,end);

a = find(abs(E_test)<=epsilon); 
Sparse = size(a,1); % sparse descriptor

E_temp = reshape(E_test,imagesize); 
[Ix,Iy,I_grad] = comput_gradient(E_temp);
Smooth = sum(sum(I_grad.^2)); % smooth descriptor

               


