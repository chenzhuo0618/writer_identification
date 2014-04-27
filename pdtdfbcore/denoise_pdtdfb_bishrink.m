% denoising evalution of different curvelet/contourlet implementation
close all; clear all;

im = double(imread('lena512.bmp'));
s = 512;

sigma = 20; % NV(in);
noise = randn(size(im));
noise = sigma.*(noise./(std(noise(:))));

nim = im + noise;
resnoi = psnr(im, nim)

addpath('/home/truong/pdfb/DTDWT');
% Set the windowsize and the corresponding filter
windowsize  = 5;
windowfilt = ones(1,windowsize)/windowsize;
windowfilt2d = 1/49*ones(7,7);

% cfg =  [4 5 5 6];
%cfg =  [3 4 4 5];
cfg =  [3 3 3 4];
alpha = 0.15;
s = 512;
resi = false;

F = pdtdfb_win(s, alpha, length(cfg), resi);

% 
disp('Compute all thresholds');
Ff = ones(s);
X = fftshift(ifft2(Ff)) * sqrt(prod(size(Ff)));

% imp = mkImpulse(s);
% y = pdtdfbdec_f(X, cfg, F, alpha, resi);
yn = pdtdfbdec_f(nim, cfg, F, alpha, resi);
clear eng

% for in1=1:length(cfg)
%     for in2=1:2^cfg(in1)
%         A = y{in1+1}{1}{in2}+j*y{in1+1}{1}{in2};
%         eng(in1,in2) =  sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
%     end
% end
%eng = eng./sqrt(2);
yth = yn;

clear noisestd
y = pdtdfbdec_f(noise./sigma, cfg, F);

for in1=1:length(cfg)
    for in2=1:2^cfg(in1)
        noisestd(in1,in2,1) = std(y{in1+1}{1}{in2}(:));
        noisestd(in1,in2,2) = std(y{in1+1}{2}{in2}(:));
   end
end

for in1=1:length(cfg)
    for in2=1:2^cfg(in1)
        %A = yth{in1+1}{1}{in2}+j*yth{in1+1}{1}{in2};
        % A = A./eng(in1,in2);
        % yth{in1+1}{1}{in2} = real(A);
        % yth{in1+1}{1}{in2} = imag(A);
        yth{in1+1}{1}{in2} = yth{in1+1}{1}{in2}./noisestd(in1,in2,1);
        yth{in1+1}{2}{in2} = yth{in1+1}{2}{in2}./noisestd(in1,in2,2);
  end
end

% if resi
%     A = y{end};
%     eng(length(cfg)+1,1) = sqrt(sum(sum(A.*conj(A))) / prod(size(A)));
% end
tmp = yth{end}{1}{2};
Nsig = median(abs(tmp(:)))/0.6745;

% Nsig = 1.1*sigma;
for scale = 2:length(cfg)
    for dir = 1:2^cfg(scale)
        % parent childrent band ratio
        br = 2^(cfg(scale)-cfg(scale-1));

        % Noisy complex coefficients
        %Real part
        Y_coef_real = yth{scale+1}{1}{dir};
        % imaginary part
        Y_coef_imag = yth{scale+1}{2}{dir};
        % The corresponding noisy parent coefficients
        pdir = floor((dir-1)/br) + 1;
        %Real part
        Y_parent_real = yth{scale}{1}{pdir};
        % imaginary part
        Y_parent_imag = yth{scale}{2}{pdir};

        Sc = size(Y_coef_real);
        Sp = size(Y_parent_real);
        Exmat = ones(Sc(1)/Sp(1),Sc(2)/Sp(2));
        % Extend noisy parent matrix to make the matrix size the same as the coefficient matrix.
       
        Y_parent_real  = kron(Y_parent_real, Exmat);
        Y_parent_imag  = kron(Y_parent_imag, Exmat);
        % Y_parent_real = interpft(interpft(Y_parent_real,Sc(1),1), Sc(2),2);
        % Y_parent_imag = interpft(interpft(Y_parent_imag,Sc(1),1), Sc(2),2);
        
        % Signal variance estimation
        Y_coef = Y_coef_real+j*Y_coef_imag;
        Wsig = conv2(windowfilt,windowfilt,0.5*(Y_coef.*conj(Y_coef)),'same');

        %Wsig = conv2(windowfilt,windowfilt,(Y_coef_real).^2,'same');
        
        % Wsig2 = conv2(windowfilt,windowfilt,(Y_coef_imag).^2,'same');
        % Wsig = 0.75*(Wsig1 + Wsig2);
        %         if Sc(1) < Sc(2)
        %             Wsig = conv2(0.5*(Y_coef.*conj(Y_coef)),windowfilt2d.','same');
        %         else
        %             Wsig = conv2(0.5*(Y_coef.*conj(Y_coef)),windowfilt2d,'same');
        %         end

        Ssig = sqrt(max(Wsig-Nsig.^2,eps));

        % Threshold value estimation
        T = sqrt(3)*Nsig^2./Ssig;

        % Bivariate Shrinkage
        Y_parent = Y_parent_real + j*Y_parent_imag;
        Y_parent = abs(Y_parent);
        
        Y_coef = bishrink(Y_coef,Y_parent,T);
        yth{scale+1}{1}{dir} = real(Y_coef);
        yth{scale+1}{2}{dir} = imag(Y_coef);

    end
end

for in1=1:length(cfg)
    for in2=1:2^cfg(in1)
        %A = yth{in1+1}{1}{in2}+j*yth{in1+1}{1}{in2};
        %A = A.*eng(in1,in2);
        %yth{in1+1}{1}{in2} = real(A);
        %yth{in1+1}{1}{in2} = imag(A);
        yth{in1+1}{1}{in2} = yth{in1+1}{1}{in2}.*noisestd(in1,in2,1);
        yth{in1+1}{2}{in2} = yth{in1+1}{2}{in2}.*noisestd(in1,in2,2);
    end
end

% Inverse Transform

tic
pim = pdtdfbrec_f(yth, F, alpha,resi);toc
respdtdfb = psnr(im, pim)







% Number of Stages
J = 6;
I=sqrt(-1);

% symmetric extension
L = length(nim); % length of the original image.
N = L+2^J;     % length after extension.
x = symextend(nim,2^(J-1));

load nor_dualtree    % run normaliz_coefcalc_dual_tree to generate this mat file.

% Forward dual-tree DWT
% Either FSfarras or AntonB function can be used to compute the stage 1 filters  
%[Faf, Fsf] = FSfarras;
[Faf, Fsf] = AntonB;
[af, sf] = dualfilt1;
W = cplxdual2D(x, J, Faf, af);
W = normcoef(W,J,nor);  


% Noise variance estimation using robust median estimator..
tmp = W{1}{1}{1}{1};
Nsig = median(abs(tmp(:)))/0.6745;

for scale = 1:J-1
    for dir = 1:2
        for dir1 = 1:3
            
            % Noisy complex coefficients
            %Real part
            Y_coef_real = W{scale}{1}{dir}{dir1};
            % imaginary part
            Y_coef_imag = W{scale}{2}{dir}{dir1};
            % The corresponding noisy parent coefficients
            %Real part
            Y_parent_real = W{scale+1}{1}{dir}{dir1};
            % imaginary part
            Y_parent_imag = W{scale+1}{2}{dir}{dir1};
            % Extend noisy parent matrix to make the matrix size the same as the coefficient matrix.
            Y_parent_real  = expand(Y_parent_real);
            Y_parent_imag   = expand(Y_parent_imag);
            
            % Signal variance estimation
            Wsig = conv2(windowfilt,windowfilt,(Y_coef_real).^2,'same');
            Ssig = sqrt(max(Wsig-Nsig.^2,eps));
            
            % Threshold value estimation
            T = sqrt(3)*Nsig^2./Ssig;
            %mesh(T);
            %pause;
            
            % Bivariate Shrinkage
            Y_coef = Y_coef_real+I*Y_coef_imag;
            Y_parent = Y_parent_real + I*Y_parent_imag;
            Y_coef = bishrink(Y_coef,Y_parent,T);
            W{scale}{1}{dir}{dir1} = real(Y_coef);
            W{scale}{2}{dir}{dir1} = imag(Y_coef);
            
        end
    end
end

% Inverse Transform
W = unnormcoef(W,J,nor);
y = icplxdual2D(W, J, Fsf, sf);

% Extract the image
ind = 2^(J-1)+1:2^(J-1)+L;
y = y(ind,ind);

