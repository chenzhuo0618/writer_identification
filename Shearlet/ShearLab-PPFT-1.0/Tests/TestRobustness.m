function output_TestRobustness=TestRobustness(N,R,beta,Choice,p,t,q,lfile)
%% TESTROBUSTNESS Test Robustness
%
%% Description
%  OUTPUT_TESTGEOMEXACT = TESTGEOMEXACT(N,R,BETA,LFILE)
%   Save measurement M_{thres_k,p_k}, M_{quant,q}.
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSPEED, TESTSHEARINVARIANCE,TESTROBUSTNESS,TESTTHRESHOLDING,SHEARLETTRANSFORM, 
% ADJSHEARLETTRANSFORM
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

%p is p1
%t is p2
 
fprintf(lfile, 'Test Robustness: \n');
fprintf(lfile, 'N = %d, R=%d\n',N,R);

m1 = max(size(p,2),size(t,2));
m  = max(m1,size(q,2));

output_TestRobustness     = zeros(7,m);
output_TestRobustness(1,1) = N;

output_TestThresholding = TestThresholding(N,R,beta,Choice,p,t,lfile);
for i = 1:4
    output_TestRobustness(1+i,:) = output_TestThresholding(i,:);
end;

output_TestQuantization = TestQuantization(N,R,beta,Choice,q,lfile);
for i = 1:2
    output_TestRobustness(5+i,:) = output_TestQuantization(i,:);
end;
