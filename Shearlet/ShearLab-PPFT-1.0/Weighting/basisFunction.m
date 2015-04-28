function P = basisFunction(N,R,choice)
%% BASISFUNCTION generate basis functions on a pseudo-polar grid
%
%% Description
% P = BASISFUNCTION(N,R,CHOICE) generate basis functions on a pseudo-polar
% grid depending on the parameter CHOICE, N is the size of original image,
% R is the oversampling rate.
% CHOICE = 1
%    bases: 1-origin, 2-first line, 3-seam line (*|x|), 4-corner point,
%    5-interior (*|x|), 6-boundary line, 7-corner point on seam line at -3
%    position.
% CHOICE = 2
%    bases: 1-origin, 2-first k0 lines, 3-interior after first k0 lines
%    (*|x|), 4-seam line (*|x|,include first k0 points), 5-boundary line.
% CHOICE = 3
%    bases: 1-origin, 2-first k0 lines, 3-interior after first k0
%    lines*|x|, 4-seam line (*|x|,exclude first k0 points), 5-boundary line.
% CHOICE = 4
%    bases: 1-origin, 2-first k0 lines, 3-interior after first k0 lines
%    (*|x|), 4-seam line (*|x|,include first k0 points), 5-boundary line.
% CHOICE = 5
%    bases: 1-origin, 2-corner point, 3-interior (*|x|), 4-seam line (*|x|)
%    , 5-boundary line. 
% CHOICE = 6
%    bases: 1-origin, 2-first k0 line interior (*|x|^alpha), 3-after first
%    k0 line interior (*|x|^beta), 4-seam line (*|x|^gamma), 5-boundary line 
%    , 6-corner point.
% CHOICE = 7
%    bases: 1-origin, 2-first slope line (slope=0), 3-second slope line
%    (slope = 1/(N/2)),..., and last slope line (slope = 1).
% CHOICE = 8
%    bases: 1-origin, 2-first k0 line interior (*|x|), 3-after first
%    k0 line interior (*|x|), 4-first k0 point seam line (*|x|), 5-after
%    first k0 point seam line (*|x|), 6-corner point, 7-boundary line.
% CHOICE = 9
%    bases: 1-origin, 2-first line, 3-interior, 4-first k0 points seam line (*|x|), 
%    5-after first k0 points seam line (*|x|), 6-corner point,
%    7-boundary line.
% CHOICE = 10
%    bases: 1-origin, 2-first line, 3-first k0 line interior (exclude first
%    line *|x|), 4-after first k0 line interior (*|x|), 5-first k0 points 
%    seam line (*|x|), 6-after first k0 points seam line (*|x|), 
%    7-boundary line, 8-corner point.
% CHOICE = 11
%    bases: 1-origin, 2-interior, 3-first k0 point seam line, 4-after first
%    k0 point seam line, 5-boundary line, 6-corner point.
% CHOICE = 12
%    bases: 1-origin, 2-interior, 3-seam line.
%
%% Examples
%    N = 128; R=4; Choice = 5;
%    P = basisFunction(N,R,Choice);
%
%% See also GETPPCOORDINATES, FINDWEIGHT, WEIGHTGENERATE

%% Copyright
% Copyright (C) 2011. Xiaosheng Zhuang, University of Osnabrueck

if nargin <= 1
    R = 2;
end
if nargin <= 2
    choice = 1;
end

[x,y] = GetppCoordinates(N,R);

x  = x(:);
y  = y(:);
xx = [x(:) y(:)];


L = prod(size(x));


% basis functions 1 in SPIE paper and SampTA paper
if choice == 1
    LQ = 7;
    P = zeros(L,LQ);
    P(:,1) = (x==0).*(y==0);
    P(:,2) = (abs(x)==1).*(abs(x)>abs(y))+(abs(y)==1).*(abs(y)>abs(x));
    P(:,2) = P(:,2)+(abs(x)==1).*(abs(y)==1);
    P(:,3) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    P(:,4) = abs(x).*(abs(x)>1).*(abs(x)<N*R/2).*(abs(x)>abs(y))+abs(y).*(abs(y)>1).*(abs(y)<N*R/2).*(abs(y)>abs(x));
    P(:,5) = abs(x).*(abs(x)>1).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    P(:,6) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    P(:,7) = (abs(x)==N*R/2-3).*(abs(y)==N*R/2-3);
end


if choice == 2
    
    if N < 32   
        k0 = R/2; 
    else
        k0 = R/2*N/32;
    end
    
    LQ = k0+4;
    P  = zeros(L,LQ);
    
    %basis function: origin
    P(:,1) = (x==0).*(y==0);    
    
    %basis function: low-frequency part near origin
    for k = 1:k0
       P(:,k+1) = (abs(x)==k).*(abs(x)>abs(y))+(abs(y)==k).*(abs(y)>abs(x));
       %P(:,k+1) = P(:,k+1)+(abs(x)==k).*(abs(y)==k);
    end
    
    %basis function: interior
    P(:,k0+2) = abs(x).*(abs(x)>k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+abs(y).*(abs(y)>k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));
    
    %basis function: seam line
    P(:,k0+3) = abs(x).*(abs(x)>=1).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    
    %basis function: boundary
    P(:,k0+4) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
end


if choice == 3
    
    if N < 32   
        k0 = R/2; 
    else
        k0 = R/2*N/32;
    end
    
    LQ = k0+4;
    P  = zeros(L,LQ);
    
    %basis function: origin
    P(:,1) = (x==0).*(y==0);    
    
    %basis function: low-frequency    
    for k = 1:k0
       P(:,k+1) = (abs(x)==k).*(abs(x)>abs(y))+(abs(y)==k).*(abs(y)>abs(x));
       P(:,k+1) = P(:,k+1)+(abs(x)==k).*(abs(y)==k);
    end
    
    %basis function: interior
    P(:,k0+2) = abs(x).*(abs(x)>k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+abs(y).*(abs(y)>k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));

    %basis function: seam line
    P(:,k0+3) = abs(x).*(abs(x)>k0).*(abs(x)<=N*R/2).*(abs(x)==abs(y)); 
    
    %basis function: boundary    
    P(:,k0+4) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
end


% Bad Choice
if choice == 4
    if N < 32   
        k0 = R/2; 
    else
        k0 = R/2*N/32;
    end
    LQ = 5;
    P  = zeros(L,LQ);
    
    %basis function: origin
    P(:,1) = (x==0).*(y==0);    
    
    %basis function: low-frequency    
    P(:,2) = abs(x).^2.*(abs(x)>=1).*(abs(x)<=k0).*(abs(x)>abs(y))+abs(y).*(abs(y)>k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));

    
    %basis function: interior
    P(:,3) = abs(x).*(abs(x)>k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+abs(y).*(abs(y)>k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));

    %basis function: seam line
    P(:,4) = abs(x).*(abs(x)>0).*(abs(x)<=N*R/2).*(abs(x)==abs(y)); 
    
    %basis function: boundary    
    P(:,5) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
end



% Good Choice
if choice == 5
    
    k0 = 1;
    LQ = k0+4;
    P = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0);
    
    for k = 2:k0
        P(:,k) = (abs(x)==k-1).*(abs(x)>abs(y))+(abs(y)==k-1).*(abs(y)>abs(x));
        P(:,k) = P(:,2)+(abs(x)==k-1).*(abs(y)==k-1); 
    end
    
    P(:,k0+1) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    P(:,k0+2) = abs(x).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+abs(y).*(abs(y)>=k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));
    P(:,k0+3) = abs(x).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    P(:,k0+4) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    
end


if choice == 6
    
    k0     = 10;
    alpha  = 0.8;
    beta   = 1;
    gamma  = 1;
    LQ     = 6;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    P(:,2) = (abs(x)).^alpha.*(abs(x)>=1).*(abs(x)<k0).*(abs(x)>abs(y))+(abs(y)).^alpha.*(abs(y)>=1).*(abs(y)<k0).*(abs(y)>abs(x));
    P(:,3) = (abs(x)).^beta.*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+(abs(y)).^beta.*(abs(y)>=k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));
    P(:,4) = (abs(x)).^gamma.*(abs(x)>=1).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    P(:,5) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    P(:,6) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    
end

% Good Choice
if choice == 7
    
    LQ     = N/2+2;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    for l = 0:N/2
        P(:,l+2) = (abs(x)).*(abs(x)>=1).*(abs(y./x) == 2*l/N)+(abs(y)).*(abs(y)>=1).*(abs(x./y) == 2*l/N);
    end
end



if choice == 8
    
    k0     = R*N/4;
    LQ     = 7;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    
    P(:,2) = (abs(x)).*(abs(x)>=1).*(abs(x)<k0).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=1).*(abs(y)<k0).*(abs(y)>abs(x));
    P(:,3) = (abs(x)).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));
    
    P(:,4) = (abs(x)).*(abs(x)>=1).*(abs(x)<k0).*(abs(x)==abs(y)); 
    P(:,5) = (abs(x)).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    
    P(:,6) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    P(:,7) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    
end


if choice == 9
    
    k0     = R*N/4;
    LQ     = 7;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    
    P(:,2) = (abs(x)==1).*(abs(x)>abs(y))+(abs(y)==1).*(abs(y)>abs(x));
    P(:,2) = P(:,2)+(abs(x)==1).*(abs(y)==1);
    
    P(:,3) = (abs(x)).*(abs(x)>=1).*(abs(x)<N*R/2).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=1).*(abs(y)<N*R/2).*(abs(y)>abs(x));
        
    P(:,4) = (abs(x)).*(abs(x)>1).*(abs(x)<k0).*(abs(x)==abs(y)); 
    P(:,5) = (abs(x)).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    
    P(:,6) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    P(:,7) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    
end

% Good Choice
if choice == 10
    
    k0     = R*N/4;
    LQ     = 8;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    
    P(:,2) = (abs(x)==1).*(abs(x)>abs(y))+(abs(y)==1).*(abs(y)>abs(x));
    P(:,2) = P(:,2)+(abs(x)==1).*(abs(y)==1);
    
    P(:,3) = (abs(x)).*(abs(x)>1).*(abs(x)<k0).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>1).*(abs(y)<k0).*(abs(y)>abs(x));
    P(:,4) = (abs(x)).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=k0).*(abs(y)<N*R/2).*(abs(y)>abs(x));

        
    P(:,5) = (abs(x)).*(abs(x)>1).*(abs(x)<k0).*(abs(x)==abs(y)); 
    P(:,6) = (abs(x)).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    
    P(:,7) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    P(:,8) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    
end


% Good choice
if choice == 11
    
    k0     = R*N/4;
    LQ     = 6;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    
    P(:,2) = (abs(x)).*(abs(x)>=1).*(abs(x)<N*R/2).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=1).*(abs(y)<N*R/2).*(abs(y)>abs(x));

        
    P(:,3) = (abs(x)).*(abs(x)>=1).*(abs(x)<k0).*(abs(x)==abs(y)); 
    P(:,4) = (abs(x)).*(abs(x)>=k0).*(abs(x)<N*R/2).*(abs(x)==abs(y)); 
    
    P(:,5) = (abs(x)==N*R/2).*(abs(x)>abs(y))+(abs(y)==N*R/2).*(abs(y)>abs(x)); 
    P(:,6) = (abs(x)==N*R/2).*(abs(y)==N*R/2);
    
end

if choice == 12
    
    LQ     = 3;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    
    P(:,2) = (abs(x)).*(abs(x)>=1).*(abs(x)<=N*R/2).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=1).*(abs(y)<=N*R/2).*(abs(y)>abs(x));
   
    P(:,3) = (abs(x)).*(abs(x)>=1).*(abs(x)<=N*R/2).*(abs(x)==abs(y)); 
    
end

if choice == 13
    
    LQ     = 3;
    P      = zeros(L,LQ);
    
    P(:,1) = (x==0).*(y==0); 
    
    P(:,2) = (abs(x)).*(abs(x)>=1).*(abs(x)<=N*R/2).*(abs(x)>abs(y))+(abs(y)).*(abs(y)>=1).*(abs(y)<=N*R/2).*(abs(y)>abs(x));
   
    P(:,3) = (abs(x)).*(abs(x)>=1).*(abs(x)<=N*R/2).*(abs(x)==abs(y)); 
    
end

end