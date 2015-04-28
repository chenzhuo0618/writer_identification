clc;
clear all;
close all;

%% Setting parameters
N      = 512;              % image size
R      = 4;                % oversammpling rate R = 2, 4, 8, 16;
beta   = 2;                % scaling factor beta = 2, 4
Choice = 1;                % basis Choice, see GENERATEW
CG     = 0;                % Use CG or not
err    = 1e-5;             % CG control error
its    = 10;               % CG maximal iterations
slope  = 1;

%% create a line
img = zeros(N);
img(N/2+1,:) = 1;
img = imShear(img,slope);
figure(1),imshow(img);

%% shearlet coefficients
W     = generateW(N,R,Choice);
shX   = ShearletTransform(img,R,beta,W);

%% nonlinear approximation
[SortX, index] = ShXSort(shX,N,R,beta,'descend');

errX = zeros(N,1);
j = 1;
for m = N:N+100
    disp(['Nonlinear Approximation of a Line. j = ', num2str(j)]);
    thr = SortX(m+1);
    ThresCoeff = ShXThres(shX,N,R,beta,thr,0);
    RecX = InvShearletTransform(ThresCoeff,N,R,beta,W,1e-5,N);
    errX(j) = norm(img - RecX,'fro');
    j = j+1;
end