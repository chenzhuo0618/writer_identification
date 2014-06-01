%%Function subband KL distance measure
function  sub_kld=sub_kld_measure(vector1,vector2)

[m,n]=size(vector1);

kld=[];
for i=1:m/2
    
    s1=vector1(2*i-1);p1=vector1(2*i);
    s2=vector2(2*i-1);p2=vector2(2*i);
    
    kld(i) = (s1/s2)^p2 * exp(gammaln((p2+1)/p1) - gammaln(1/p1)) - 1/p1 + ...
          (s2/s1)^p1 * exp(gammaln((p1+1)/p2) - gammaln(1/p2)) - 1/p2;
end

sub_kld=kld;