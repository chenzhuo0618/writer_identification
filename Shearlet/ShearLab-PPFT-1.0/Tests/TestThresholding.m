function output_TestThresholding=TestThresholding(N,R,beta,Choice,rangep,rangei,lfile);
%% TESTTHRESHOLDING Thresholding Test.
% rangep is p is p1
% rangei is t is p2
%
%% See also TESTALGEXACT, TESTISOMETRY, TESTTIGHTNESS, TESTTIMEFREQLOC,
% TESTSPEED, TESTSHEARINVARIANCE,TESTROBUSTNESS,TESTTHRESHOLDING,SHEARLETTRANSFORM, 
% ADJSHEARLETTRANSFORM
%
%% Copyright
%   Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

fprintf(lfile, 'Subtest Thresholding 1: \n');

X = zeros(N);
for i = 1:N
    for j = 1:N
        X(i,j) = exp(-(norm([i-N/2 j-N/2],2)^2)/N);
    end;
end;    
C   = generateW(N,R,Choice);
ShX = ShearletTransform(X,R,beta,C);

output_TestThresholding = zeros(4,max(size(rangep,2),size(rangei,2)));

JH = ceil(log2(N)/log2(beta));        % highest level 
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

SortCoeff = sort(ListCoeff);

countp = 0;
for p = rangep
    countp = countp+1;
    output_TestThresholding(1,countp)=100*(1-2^(-p));
    %fprintf(lfile, 'Percent = %d \n',100*(1-2^(-p)));
    ThresCoeff  = ShX;
    NumberThres = floor(size(SortCoeff,2)*(1-2^(-p))); % number of value used for thresholding
    ValueThres  = abs(SortCoeff(NumberThres)); % value used for thresholding
    for sector = 1:4
        for scale = JH:-1:JL
            Ntile = ParaScale(scale,beta);
            for tile = -Ntile:Ntile
                SizeCoeff1 = size(ThresCoeff{sector,scale-JL+2,tile+Ntile+1},1);
                SizeCoeff2 = size(ThresCoeff{sector,scale-JL+2,tile+Ntile+1},2);
                for x = 1:SizeCoeff1
                    for y = 1:SizeCoeff2
                        if (abs(ThresCoeff{sector,scale-JL+2,tile+Ntile+1}(x,y)) < ValueThres)
                            ThresCoeff{sector,scale-JL+2,tile+Ntile+1}(x,y)=0;
                        end;
                    end;
                end;    
            end;
        end;
    end; 
    
   RecX        = InvShearletTransform(ThresCoeff,N,R,beta,C);
   ErrorMatrix = RecX-X;

   output_TestThresholding(2,countp) = norm(ErrorMatrix,'fro')/norm(X,'fro');
   fprintf(lfile, 'Percent = %.8f, Mthres1 =%E  \n',100*(1-2^(-p)), output_TestThresholding(2,countp));
end;    

fprintf(lfile, '\n');

fprintf(lfile, 'Subtest Thresholding 2: \n');

MaxCoeff    = max(abs(SortCoeff));
MedianCoeff = median(abs(SortCoeff));

ranget = zeros(1,size(rangei,2));
counti = 0;
for i = rangei
    counti = counti+1;
    ranget(1,counti)=MaxCoeff*(1-2^(-i)); % computing the thresholds
end;    

countt = 0;
for t = ranget
    countt = countt+1;
    output_TestThresholding(3,countt)=t;
    %fprintf(lfile, 'Threshold = %d \n',t);
    ThresCoeff = ShX;
    for sector = 1:4
        for scale = JH:-1:JL
            Ntile = ParaScale(scale,beta);
            for tile = -Ntile:Ntile
                SizeCoeff1 = size(ThresCoeff{sector,scale-JL+2,tile+Ntile+1},1);
                SizeCoeff2 = size(ThresCoeff{sector,scale-JL+2,tile+Ntile+1},2);
                for x = 1:SizeCoeff1
                    for y = 1:SizeCoeff2
                        if (abs(ThresCoeff{sector,scale-JL+2,tile+Ntile+1}(x,y)) < t)
                            ThresCoeff{sector,scale-JL+2,tile+Ntile+1}(x,y) = 0;
                        end;
                    end;
                end;    
            end;
        end;
    end;     

    RecX        = InvShearletTransform(ThresCoeff,N,R,beta,C);
    ErrorMatrix = RecX-X;
    
    output_TestThresholding(4,countt) = norm(ErrorMatrix,'fro')/norm(X,'fro');
    fprintf(lfile, 'MaxCoeff = %.6f, MedianCoeff = %E, Threshold = %E, Mthres2 =%E  \n', MaxCoeff,MedianCoeff, t, output_TestThresholding(4,countt));
end;    
fprintf(lfile, '\n');
end





