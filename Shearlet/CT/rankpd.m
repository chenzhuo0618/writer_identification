function rr = rankpd(fs, ns)
% RANKPD Rank relevant images using probabilistic distance
%
% Input:
%	fs:	feature sets, one column per image
%	ns:	(optional), number of subimages per texture class
%		(default 16)
%
% Output:
%	rr:	rank of relevant images, one column for each query
%
% See also: RANKED

if nargin < 2
    ns = 16;
end

[nf, nimages] = size(fs);

rr = zeros(ns, nimages);
d = zeros(1, nimages);
ii = 1:nimages;

for q = 1:nimages			% each query
    for i = 1:nimages			% each image
	% Compute probabilistic distance between the image and the query
	d(i) = local_pd(fs(:,i), fs(:,q), nf);
    end
	
    % Sort distances in ascending order
    [sd, si] = sort(d);

    % Find the rank of the images
    r(si) = ii;
	
    % Save the ranks of the relevant images
    c = floor((q-1) / ns);
    rr(:, q) = r((c*ns+1):((c+1)*ns))';
end

return


% --------------------------------------------------- %
% Kullback-Leibler distance between two Laplacian pdf %
% --------------------------------------------------- %
function d = local_kld(s1, p1, s2, p2)
% 	s ~ alpha, p ~ beta

d = (s1/s2)^p2 * exp(gammaln((p2+1)/p1) - gammaln(1/p1)) - 1/p1 + ...
    (s2/s1)^p1 * exp(gammaln((p1+1)/p2) - gammaln(1/p2)) - 1/p2;

return


% ------------------------------------ %
% Distance between two feature vectors %
% ------------------------------------ %
function d = local_pd(fv1, fv2, nf)
%	Assumption on feature vectors:
%	s, p, s, p, (next subband), ...
%	
%	No checking is done!

n = floor(nf/2);

d = 0;

for i = 1:n
    d = d + local_kld(fv1(2*i-1), fv1(2*i), fv2(2*i-1), fv2(2*i));
end

return
