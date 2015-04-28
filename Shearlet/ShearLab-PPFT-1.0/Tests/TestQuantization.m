function output_TestQuantization=TestQuantization(N,R,beta,Choice,rangeq,lfile)
%% TestQuantization Quantization Test.
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSPEED, TESTSHEARINVARIANCE,TESTROBUSTNESS,TESTTHRESHOLDING,SHEARLETTRANSFORM, 
% ADJSHEARLETTRANSFORM
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

fprintf(lfile, 'Subtest Quantization: \n');

X = zeros(N);
for i = 1:N
    for j = 1:N
        X(i,j) = exp(-(norm([i-N/2 j-N/2],2)^2)/N);
    end;
end;    

C   = generateW(N,R,Choice);
ShX = ShearletTransform(X,R,beta);

JH = ceil(log2(N)/log2(beta));       %highest level 
JL = -floor(log2(R/2)/log2(beta));    % lowest level

ListCoeff = [];
for sector = 1:4
     for scale = JH:-1:JL
         Ntile = ParaScale(scale,beta);
         for tile = -Ntile:Ntile
             LengthVector = prod(size(ShX{sector,scale-JL+2,tile+Ntile+1}));
             ListCoeff    = [ListCoeff reshape(ShX{sector,scale-JL+2,tile+Ntile+1},1,LengthVector)];
         end;   
    end;    
end;  
MaxCoeff = max(abs(ListCoeff));

output_TestQuantization = zeros(2,size(rangeq,2));
countq =0;

for q = rangeq
    q = MaxCoeff/(2^q);
    countq =countq+1;
    output_TestQuantization(1,countq)=q;
    %fprintf(lfile, 'Alphabet size = %d \n',q);
    QuantCoeff = ShX;
    for sector = 1:4
      for scale = JH:-1:JL
         Ntile  = ParaScale(scale,beta);
         for tile =-Ntile:Ntile
              QuantCoeff{sector,scale-JL+2,tile+Ntile+1} = round(QuantCoeff{sector,scale-JL+2,tile+Ntile+1}./q).*q;
         end;
      end;
    end; 
    
    RecX        = InvShearletTransform(QuantCoeff,N,R,beta,C);
    ErrorMatrix = RecX-X;
    
    output_TestQuantization(2,countq) = norm(ErrorMatrix,'fro')/norm(X,'fro');
    fprintf(lfile, 'Alphabet size = %f, Mquant =%E  \n',q,output_TestQuantization(2,countq));
end;    
fprintf(lfile, '\n');
end