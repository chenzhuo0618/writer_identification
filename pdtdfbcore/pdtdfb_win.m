function F2 = pdtdfb_win(s2, alpha, Lnlev, res)
% PDTDFB_WIN   Generate the Freq. windows that used in PDTDFB toolbox
%
%	F2 = pdtdfb_win(s2, alpha, Lnlev, res)
%
% Input:
%   s : size of the generated window
%   alpha : paramter for meyer window
%
% Output:
%   FL: 2-D window of low pass function for lower resolution curvelet
%   F : cell of size n containing 2-D matrices of size s*s
%
% Example
%
% See also
%

if ~exist('res','var')
    res = 0 ; % default implementation 
end

if ~exist('Lnlev', 'var')
    Lnlev = 1;
end

if max(size(s2)) == 1
    s2 = [s2 s2];
end

if res
    % --------------------------------------------
    % create residual Low pass and highpass window
    S1 = -1.5*pi:pi/(s2(1)/2):1.5*pi;
    S2 = -1.5*pi:pi/(s2(2)/2):1.5*pi;

    fl_row = fun_meyer(S1,pi*[-1 -1+2*alpha 1-2*alpha 1]);
    fl_col = fun_meyer(S1,pi*[-1 -1+2*alpha 1-2*alpha 1]);

    FRL =  fl_col(:)*fl_row(:).';
    FRH =  1-FRL;

    F2{Lnlev+1} = fftshift(sqrt((FRH(s2(1)/4+1:s2(1)/4+s2(1),s2(2)/4+1:s2(2)/4+s2(2)))));
else
    FRL = ones(s2*1.5+1);
end

for inl = Lnlev:-1:1
    s = s2./2^(Lnlev-inl);

    % create the grid
    S1 = -1.5*pi:pi/(s(1)/2):1.5*pi;
    S2 = -1.5*pi:pi/(s(2)/2):1.5*pi;
    [x1, x2] = meshgrid(S2,S1);

    r = [0.5-alpha 0.5 1-alpha, 1+ alpha];

    %tic
    % --------------------------------------------
    % create Low pass and highpass window
    sz = size(x1);
    cen_row = x1((sz(1)+1)/2,:);
    cen_row = abs(cen_row);
    fl_row = fun_meyer(cen_row,pi*[-2 -1 r(1:2)]);

    cen_col = x2(:,(sz(2)+1)/2);
    cen_col = abs(cen_col);
    fl_col = fun_meyer(cen_col,pi*[-2 -1 r(1:2)]);

    FL =  fl_col(:)*fl_row(:).';
    % if at the highest resolution, multiply with low residual window
    if inl == Lnlev
        FH =  FRL.*(1-FL);
   else
        FH =  1-FL;
    end

    F{1} = 2*fftshift(sqrt((FL(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2)))));
    
        FH = FH(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2));
    
    %toc
    %tic
    % -------------------------------------------
    % create the directional window
    xd = abs(x1+x2);
    f1 = fun_meyer(xd,pi*[-2, -1, 1-alpha, 1+ alpha]);

    xd = abs(x1-x2);
    f2 = fun_meyer(xd,pi*[-2, -1, 1-alpha, 1+ alpha]);

    fl = f1.*f2;

    fl = periodize(fl,s, 'r');
    fl = [fl(s(1)/2+1:end,:); fl(1:s(1)/2,:)];

    f1 = fun_meyer(x1,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);
    f2 = fun_meyer(x2,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);

    fh = f1.*f2;
    f1 = fun_meyer(-x1,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);
    f2 = fun_meyer(-x2,pi*[-alpha, alpha, 1-alpha, 1+ alpha]);

    fh = fh + f1.*f2;

    fh = periodize(fh,s,  'r');

    f1 = fftshift(sqrt(2*FH.*fl.*fh));
    f2 = fftshift(sqrt(2*FH.*fl.* [fh(s(1)/2+1:end,:); fh(1:s(1)/2,:)]));
    f3 = fftshift(sqrt(2*FH.*fftshift(fl).*fh));
    f4 = fftshift(sqrt(2*FH.*fftshift(fl).* [fh(s(1)/2+1:end,:); fh(1:s(1)/2,:)]));

    %toc
    % -------------------------------------------
    % create the phase function
    % fourier series
    Lf = 10;
    k = -((1:Lf)).^(-1);
    tmp = 0*x1;

    %tic
    for in = 1:Lf
        tmp = tmp+ k(in)*sin(2*in*x1);
    end
    %toc

    tmp2 = mod(x1+pi,2*pi)-pi;

    phs = tmp2-tmp;

    phs = (phs(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2)));

    tmp = 0*x2;

    %tic
    for in = 1:Lf
        tmp = tmp+ k(in)*sin(2*in*x2);
    end
    %toc

    tmp2 = mod(x2+pi,2*pi)-pi;

    phsb = tmp2-tmp;

    phsb = (phsb(s(1)/4+1:s(1)/4+s(1),s(2)/4+1:s(2)/4+s(2)));

    % four complex directional window
    F{5} = f1+j*f1.*exp(-j*phs);
    F{4} = f2+j*f2.*exp(-j*phs);
    F{3} = f3+j*f3.*exp(-j*phsb);
    F{2} = f4+j*f4.*exp(-j*phsb);

    F2{inl} = F;

end

