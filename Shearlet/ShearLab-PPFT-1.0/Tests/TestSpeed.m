function output_TestSpeed=TestSpeed(rangeN,R,beta,Choice,lfile);
%% TESTSPEED Test Speed of Shearlet Transform
%
%% Description
%  OUTPUT_TESTSPEED=TESTSPEED(RANGEN,R,BETA,CHOICE,LFILE);
%   Model : s_i = c(2^{2i})^d, speed model
%   Estimate: c, d, s_i/time(fft2(i));
%
%   Save measurement M_{speed_1}, M_{speed_2}, M_{speed_3}.
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTGEOMEXACT, TESTROBUSTNESS,TESTTHRESHOLDING,SHEARLETTRANSFORM, 
% ADJSHEARLETTRANSFORM
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck
 
fprintf(lfile, 'Test Speed: \n');

numberN          = size(rangeN,2);
output_TestSpeed = zeros(2,numberN+3);
FourierSpeed     = zeros(1,numberN);

for i = 1:numberN
    disp(['i = ' num2str(i) '...']);
    output_TestSpeed(1,i)=rangeN(i);
    
    X     = randn(rangeN(i));
    C     = generateW(rangeN(i),R,Choice);

    tfft1 = tic;
    FFTX  = fft2(X);
    tfft2 = toc(tfft1);
    FourierSpeed(1,i) = tfft2;                        % fft2 time.
    
    tshX1 = tic;
    ShX   = ShearletTransform(X,R,beta,C);
    tshX2 = toc(tshX1);
    output_TestSpeed(2,i)= tshX2;

    fprintf(lfile, 'N = %d,\t FwdSHT_Speed = %.4f secs, \t FFT_Speed = %.6f sec \n',rangeN(1,i), output_TestSpeed(2,i), FourierSpeed(1,i));
end;

fprintf(lfile, 'Now the computation of the three measures!\n');

SpeedEntries = zeros(1,numberN);
SpeedEntries = output_TestSpeed(2,[1:numberN]);
x = zeros(1,numberN);
x = log2(SpeedEntries);
d = zeros(2,1);

% For now without the intercept!!!!!
x = x';
y = log2(rangeN)';
X = [ones(numberN,1)  y];
d = X\x;

output_TestSpeed(1,[numberN+1:numberN+3])=0;
M1 = d(2,1)/(2*log(2));
output_TestSpeed(2,numberN+1) = M1;
output_TestSpeed(2,numberN+2) = (1/numberN)*sum(SpeedEntries./((2.^(2.*y')).^M1));
output_TestSpeed(2,numberN+3) = (1/numberN)*sum(SpeedEntries./FourierSpeed);

fprintf(lfile, 'Speed. Complexity: Mspeed1 = %f\n',M1);
fprintf(lfile, 'Speed. The Constant: Mspeed2 = %E\n',output_TestSpeed(2,numberN+2));
fprintf(lfile, 'Speed. Comparision with 2D-FFT: Mspeed3 = %f\n',output_TestSpeed(2,numberN+3));

fprintf(lfile, '\n');

end