function out=gabortransform(in,options)

sigma = 1;
xi = 3*pi/4; 
gabfactor = sqrt(2*xi/(3*pi));
slant=1;
J=getoptions(options,'J',3);
D=getoptions(options,'D',6);
 dim = size(in,3);
out=[];
 for i=1:dim
     plane = double(in(:,:,i));
     plane = (plane - mean2(plane)./std2(plane));
     fin=fft2(plane);
	for scale=1:J
	for d=1:D
% 		scale = j-j0+1;
		tmp = gabfactor*sqrt(4/D)*2^(-scale)*gabor_2d(sigma*2^(scale-1),slant,(d-1)*pi/D,xi*2^(1-scale),[0 0],ceil(N*2^(-j0+1)),0);
		W{scale}{d} = fft2(tmp);
        coef=abs(ifft2(fin.*W{scale}{d}));
        coef=coef(:)+eps;
        out=[out coef];
        
	end
	end
% 	tmp= gabor_2d(sigma0*2^(J-j0),1,0,0,[0 0],ceil(N*2^(-j0+1)),1);
% 	Phi{j0} = fft2(tmp);
end

             
             
 



