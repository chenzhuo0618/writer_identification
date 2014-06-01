function out=gabortransform(in,options)
J=getoptions(options,'J',3);
D=getoptions(options,'D',6);
  N=size(in);
 W= gaborwavelets(J,D,N);
 fin=fft2(in);
 for j=1:J
     out=[];
     sz=size(W{j});
     for scale=1:sz
         for d=1:D
             coef=abs(iff2(fin.*W{j}{scale}{d}));
             coef=coef(:)+eps;
             out=[out coef];
         end
     end
 end
             
             
 



