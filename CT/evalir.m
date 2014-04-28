function [r, rs, or,mas] = evalir(rr, mnr)
% EVALIR Evaluate Image Retrieval (IR) performance
%
% Input:
%	rr:	rank of relevant images, one column for each query
%	mnr:	(optional) maximum number of retrieved images considered
%		(default 100)
%
% Output:
%	r:	overall recognition rate
%	rs:	(optional) average recognition rate for each texture class
%	or:	(optional) operating recognition rate in percentage,
%		according to the number of retrieved images considered
[ns, nimages] = size(rr);
pr = zeros(1, nimages);

for q = 1:nimages    
    pr(q) = length(find(rr(:, q) <= ns));
end

r = mean(pr) / ns * 100

if nargout > 1
    rs = mean(reshape(pr, ns, floor(nimages/ns))) / ns * 100;
end

if nargout > 2
    if nargin < 2
	mnr = 100;
    end
    
    for nr = 1:mnr
	or(nr) = length(find(rr <= (nr+1))) / (ns * nimages) * 100;
    end
end
M_class=zeros(112,1);
M_class=[1;26;20;18;8;1;10;2;29;20;5;31;31;1;32;5;5;4;23;1;6;20;9;13;
        15;15;9;9;18;9;9;8;8;3;20;20;28;28;19;19;19;19;22;22;22;4;4;21;
         1;14;14;3;7;9;6;2;18;10;11;10;11;12;11;2;2;24;24;14;17;14;17;17
         26;24;24;14;7;7;7;13;13;23;23;6;23;27;20;12;12;21;21;18;17;16;16;15
        32;9;9;21;25;25;3;3;13;13;30;30;29;29;26;26];
      mas=zeros(1,32);
      for i=1:112
         k=M_class(i);
          mas(k)=mas(k)+rs(i);
      end
  M_as=[5,4,4,3,3,3,4,3,8,3,3,3,5,5,3,2,4,4,4,6,4,3,4,4,2,4,1,2,3,2,2,2];
  mas=mas./M_as;
return
     
