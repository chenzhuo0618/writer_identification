function [h0, h1] = dfilters(fname, type)
% DFILTERS	Generate diamond 2D filters
%
%	[h0, h1] = dfilters(fname, type)
%
% Input:
%  fname:	Filter name.  Available 'fname' are:
%       'haar':     the "Haar" filters
%
%       '5-3':      McClellan transformed of 5-3 filters
%
%       'cd','9-7': McClellan transformed of 9-7 filters (Cohen and Daubechies)
%
%       'pkvaN':   length N ladder filters by Phong et al. (N = 6, 8, 12)
%                   'pkva6', 'pkva8', 'pkva12', 'pkva'
%
%       'tk', 'tkN' : Generalized McClellan transformation method (Tay and
%       Kingsburry) (N = 7, 11 default 'tk' 5) (Require image processing toolbox)
%
%       'lat8','lat10','lat17' : the filter that can be implement by lattice structure
%       size 8*9 and size 10*11 and 17*18 respectively
%       ( see Chapter 6 , 'The multiresolution DFBs' PhD dissertation)
%
%       'optim9', 'optim11'   : The coefficient of diamond filter design by
%       optimizaition method 
%       ( see Chapter 6 , 'The multiresolution DFBs' PhD dissertation)
%
%       'meyer' : meyer type diamond filter bank
%       'meyerh2''meyerh3' : meyer type fan fb for the second level of the dual dfb
%
%  type:	'd' or 'r' for decomposition or reconstruction filters
%
% Output:
%
%   h0, h1:	diamond filter pair (lowpass and highpass)
%
% See also : LPFILTERS, WFILTERS
% References
% 
% Note
%   20/7/07 : clean up this file, remove old option


% To test those filters (for the PR condition for the FIR case), verify that:
% conv2(h0, modulate2(h1, 'b')) + conv2(modulate2(h0, 'b'), h1) = 2
% (replace + with - for even size filters)
%
% To test for orthogonal filter
% conv2(h, reverse2(h)) + modulate2(conv2(h, reverse2(h)), 'b') = 2

% The diamond-shaped filter pair
switch fname
    case {'haar'} %-------------------------------------------------------
        if lower(type(1)) == 'd'
            h0 = [1, 1] / sqrt(2);
            h1 = [-1, 1] / sqrt(2);
        else
            h0 = [1, 1] / sqrt(2);
            h1 = [1, -1] / sqrt(2);
        end

    case {'5-3', '5/3'}     % McClellan transformed of 5-3 filters %------
        % 1D prototype filters: the '5-3' pair
        [h0, g0] = pfilters('5-3');

        if lower(type(1)) == 'd'
            h1 = modulate2(g0, 'c');
        else
            h1 = modulate2(h0, 'c');
            h0 = g0;
        end

        % Use McClellan to obtain 2D filters
        t = [0, 1, 0; 1, 0, 1; 0, 1, 0] / 4;	% diamond kernel
        h0 = mctrans(h0, t);
        h1 = mctrans(h1, t);
    case {'cd', '9-7', '9/7'}	    % ------------------------------------
        % 1D prototype filters: the '9-7' pair
        [h0, g0] = pfilters('9-7');

        if lower(type(1)) == 'd'
            h1 = modulate2(g0, 'c');
        else
            h1 = modulate2(h0, 'c');
            h0 = g0;
        end

        % Use McClellan to obtain 2D filters
        t = [0, 1, 0; 1, 0, 1; 0, 1, 0] / 4;	% diamond kernel
        h0 = mctrans(h0, t);
        h1 = mctrans(h1, t);

    case {'pkva6', 'pkva8', 'pkva12', 'pkva'}
        % Filters from the ladder structure

        % Allpass filter for the ladder structure network
        beta = ldfilter(fname);

        % Analysis filters
        [h0, h1] = ld2quin(beta);

        % Normalize norm
        h0 = sqrt(2) * h0;
        h1 = sqrt(2) * h1;

        % Synthesis filters
        if lower(type(1)) == 'r'
            f0 = modulate2(h1, 'b');
            f1 = modulate2(h0, 'b');

            h0 = f0;
            h1 = f1;
        end
    case {'lat8'} % lattice structure filter
        % load mat\lat8.mat
        h0 =  10^(-3)*[...
            0         0         0   19.6853  -20.9112         0         0         0         0;
            0         0   41.3906  -43.9682   -1.7544   12.2187         0         0         0;
            0   17.2361  -18.3095 -159.9463    8.0327  -69.3194   69.9947         0         0;
            -4.5969    4.8832 -150.2817  -29.9456  360.8494  -69.4293  -37.2543    4.0663   0;
            0   35.3025    2.0879  306.9457  789.0718  193.0575   -5.6809   -5.1280   -4.8274;
            0         0  -62.0192  -67.9865  170.3598    0.3474   19.2276   18.1004         0;
            0         0         0  -25.7092  -13.9653   46.1728   43.4661         0         0;
            0         0         0         0   21.9597   20.6724         0         0         0];

        h1 =  -10^(-3)*[...
            0         0         0   20.6724  -21.9597         0         0         0         0;
            0         0   43.4661  -46.1728  -13.9653   25.7092         0         0         0;
            0   18.1004  -19.2276    0.3474 -170.3598  -67.9865   62.0192         0         0;
            -4.8274    5.1280   -5.6809 -193.0575  789.0718 -306.9457    2.0879  -35.3025   0;
            0    4.0663   37.2543  -69.4293 -360.8494  -29.9456  150.2817    4.8832    4.5969;
            0         0   69.9947   69.3194    8.0327  159.9463  -18.3095  -17.2361         0;
            0         0         0   12.2187    1.7544  -43.9682  -41.3906         0         0;
            0         0         0         0  -20.9112  -19.6853         0         0         0];

        if lower(type(1)) == 'd'
        else
            h0 = h0(end:-1:1,end:-1:1);
            h1 = h1(end:-1:1,end:-1:1);
        end

    case {'lat10'} % lattice structure filter
        % diamond filter of size 10*11
        H(:,:,1) =  -10^(-3)*[...
            0         0         0         0   -0.0113   -0.1134         0         0         0         0         0;
            0         0         0   -0.1516   -1.5162    0.4113   -2.8702         0         0         0         0;
            0         0    0.3303    3.3033   -2.7298  -14.2898   15.4026  -18.4426         0         0         0;
            0    1.2795   12.7954    2.4510   72.2226  -35.9680   94.8643  102.1411   -9.0141         0         0;
            0.4726    4.7258    0.9398    8.3444 -102.0748 -534.4668 -278.7716   15.6555   -7.0806    2.3563    0;
            0    0.9413    1.5834    1.4902   -5.3506 -283.2854  -70.8236   72.2972   -7.0081   -9.9486    0.9949;
            0         0   -4.6912  -49.6634   20.4799   -1.6936   60.4236  -16.0867  -26.9360    2.6936         0;
            0         0         0   -7.1195   11.0385  -18.5912   -0.8792   -6.9540    0.6954         0         0;
            0         0         0         0    1.8227    1.2877    3.1917   -0.3192         0         0         0;
            0         0         0         0         0    0.2387   -0.0239         0         0         0         0];

        H(:,:,2) = -10^(-3)*[...
            0         0         0         0    0.0239    0.2387         0         0         0         0         0;
            0         0         0    0.3192    3.1917   -1.2877    1.8227         0         0         0         0;
            0         0   -0.6954   -6.9540    0.8792  -18.5912  -11.0385   -7.1195         0         0         0;
            0   -2.6936  -26.9360   16.0867   60.4236    1.6936   20.4799   49.6634   -4.6912         0         0;
            -0.9949   -9.9486    7.0081   72.2972   70.8236 -283.2854    5.3506    1.4902   -1.5834    0.9413   0;
            0   -2.3563   -7.0806  -15.6555 -278.7716  534.4668 -102.0748   -8.3444    0.9398   -4.7258    0.4726;
            0         0    9.0141  102.1411  -94.8643  -35.9680  -72.2226    2.4510  -12.7954    1.2795         0;
            0         0         0   18.4426   15.4026   14.2898   -2.7298   -3.3033    0.3303         0         0;
            0         0         0         0    2.8702    0.4113    1.5162   -0.1516         0         0         0;
            0         0         0         0         0    0.1134   -0.0113         0         0         0         0];

        if lower(type(1)) == 'd'
            h0 = sqrt(2)*squeeze(H(:,:,1));
            h1 = sqrt(2)*squeeze(H(:,:,2));
        else
            h0 = sqrt(2)*squeeze(H(end:-1:1,end:-1:1,1));
            h1 = sqrt(2)*squeeze(H(end:-1:1,end:-1:1,2));
        end
        
    case {'lat17'} % lattice structure filter
        % diamond filter of size 17*18
        % old mat file        load Dlat8.mat
        H(:,:,1) = -10^(-3)*[...
            0         0         0         0         0         0         0         0   -0.0000    0.0001         0         0         0         0         0         0         0         0;
            0         0         0         0         0         0         0    0.0006   -0.0117    0.0003   -0.0061         0         0         0         0         0         0         0;
            0         0         0         0         0         0   -0.0110    0.2152   -0.0222    0.5309   -0.0037    0.1217         0         0         0         0         0         0;
            0         0         0         0         0    0.0532   -1.0396    0.1759   -5.2824    0.0495   -5.3705   -0.0193   -0.6195         0         0         0         0         0;
            0         0         0         0    0.0335   -0.6552    0.4122    1.9268    2.4833   -0.3302    2.9904  -12.9126    0.3894   -2.5618         0         0         0         0;
            0         0         0   -0.3541    6.9242   -1.8345   34.0051   -3.3201    2.4341   -6.1550   21.5160    4.2553    1.9084    1.1577   -1.5432         0         0         0;
            0         0   -0.3543    6.9277   -3.8687   15.3707   -9.7280  -74.0358   16.5652  -15.8648   28.5357  -48.3298    3.3437   12.5238    0.6338    0.6987         0         0;
            0   -0.0337    0.6580    0.2788  -14.7836    9.2159    0.1277   22.9984   53.0882 -124.7117  125.1335   27.6191  -38.1974    2.9189    2.3636   -0.2786    0.0043         0;
            0.0006   -0.0109    2.0715   -4.7297   16.0513  -26.7438  -90.0447 -135.3339 -392.4347 -706.4825  -52.9402  104.0566   -6.2630    5.1932   -3.4552   -1.4591   -0.0077   -0.0004;
            0   -0.0061   -0.3951   -2.9340    3.9272   18.6087   -1.3045   32.1750 -123.5876 -413.2989   98.3748  140.8226   -3.6557  -18.1300   -1.1304    0.4608    0.0236         0;
            0         0   -0.9908    0.8988  -18.2650    3.6855   -4.8774   21.5462  119.7541   11.9448  121.0278  -13.3458  -53.4407   -0.4933    5.0792    0.2598         0         0;
            0         0         0    2.1884    1.6417   -5.1248    5.1058  -61.0996  -13.2142   -0.2612   -2.1187  -45.6162   -1.3450    6.9575    0.3558         0         0         0;
            0         0         0         0    3.6329    0.5523   16.3976    3.9962   -7.6154    1.8079   -1.8254   -0.2971    1.8737    0.0958         0         0         0         0;
            0         0         0         0         0    0.8785   -0.0273    7.2650    0.0743    4.4512    0.1649   -0.6016   -0.0308         0         0         0         0         0;
            0         0         0         0         0         0   -0.1726   -0.0052   -0.7004   -0.0294   -0.1373   -0.0070         0         0         0         0         0         0;
            0         0         0         0         0         0         0    0.0087    0.0004    0.0151    0.0008         0         0         0         0         0         0         0;
            0         0         0         0         0         0         0         0   -0.0001   -0.0000         0         0         0         0         0         0         0         0 ];

        H(:,:,2) = -10^(-3)*[...
            0         0         0         0         0         0         0         0    0.0000   -0.0001         0         0         0         0         0         0         0         0;
            0         0         0         0         0         0         0   -0.0008    0.0151   -0.0004    0.0087         0         0         0         0         0         0         0;
            0         0         0         0         0         0    0.0070   -0.1373    0.0294   -0.7004    0.0052   -0.1726         0         0         0         0         0         0;
            0         0         0         0         0    0.0308   -0.6016   -0.1649    4.4512   -0.0743    7.2650    0.0273    0.8785         0         0         0         0         0;
            0         0         0         0   -0.0958    1.8737    0.2971   -1.8254   -1.8079   -7.6154   -3.9962   16.3976   -0.5523    3.6329         0         0         0         0;
            0         0         0   -0.3558    6.9575    1.3450  -45.6162    2.1187   -0.2612   13.2142  -61.0996   -5.1058   -5.1248   -1.6417    2.1884         0         0         0;
            0         0   -0.2598    5.0792    0.4933  -53.4407   13.3458  121.0278  -11.9448  119.7541  -21.5462   -4.8774   -3.6855  -18.2650   -0.8988   -0.9908         0         0;
            0   -0.0236    0.4608    1.1304  -18.1300    3.6557  140.8226  -98.3748 -413.2989  123.5876   32.1750    1.3045   18.6087   -3.9272   -2.9340    0.3951   -0.0061         0;
            0.0004   -0.0077    1.4591   -3.4552   -5.1932   -6.2630 -104.0566  -52.9402  706.4825 -392.4347  135.3339  -90.0447   26.7438   16.0513    4.7297    2.0715    0.0109    0.0006;
            0   -0.0043   -0.2786   -2.3636    2.9189   38.1974   27.6191 -125.1335 -124.7117  -53.0882   22.9984   -0.1277    9.2159   14.7836    0.2788   -0.6580   -0.0337         0;
            0         0   -0.6987    0.6338  -12.5238    3.3437   48.3298   28.5357   15.8648   16.5652   74.0358   -9.7280  -15.3707   -3.8687   -6.9277   -0.3543         0         0;
            0         0         0    1.5432    1.1577   -1.9084    4.2553  -21.5160   -6.1550   -2.4341   -3.3201  -34.0051   -1.8345   -6.9242   -0.3541         0         0         0;
            0         0         0         0    2.5618    0.3894   12.9126    2.9904    0.3302    2.4833   -1.9268    0.4122    0.6552    0.0335         0         0         0         0;
            0         0         0         0         0    0.6195   -0.0193    5.3705    0.0495    5.2824    0.1759    1.0396    0.0532         0         0         0         0         0;
            0         0         0         0         0         0   -0.1217   -0.0037   -0.5309   -0.0222   -0.2152   -0.0110         0         0         0         0         0         0;
            0         0         0         0         0         0         0    0.0061    0.0003    0.0117    0.0006         0         0         0         0         0         0         0;
            0         0         0         0         0         0         0         0   -0.0001   -0.0000         0         0         0         0         0         0         0         0];

        if lower(type(1)) == 'd'
            h0 = squeeze(H(:,:,1));
            h1 = squeeze(H(:,:,2));
        else
            h0 = squeeze(H(end:-1:1,end:-1:1,1));
            h1 = squeeze(H(end:-1:1,end:-1:1,2));
        end

    case {'tk','tk7','tk11'} % --------------------------------------------
        % Filter by DB Tay and Kingsburry method
        switch fname
            case {'tk7'}
                N = 7;
            case {'tk11'}
                N = 11;
            otherwise
                N = 5;
        end
        % calculate the transformation matrix , internal function
        h_trans = trans_matrix(N);
        % the maxflat lagrange halfband 3-5
        h = [ 0.2500    0.5000    0.2500 ];
        f = [-0.1250    0.2500    0.7500    0.2500   -0.1250];
        % Use Mcclellan transform
        if lower(type(1)) == 'd'
            h0 = sqrt(2)*ftrans2(h,h_trans);
            f0 = sqrt(2)*ftrans2(f,h_trans);
            % two diamond filter h0,f0, h0*f0 is nyquist Q
            h1 = modulate2(f0,'b');
        else
            % reconstruction filter
            h0 = sqrt(2)*ftrans2(h,h_trans);
            h1 = modulate2(h0,'b');

            h0 = sqrt(2)*ftrans2(f,h_trans);
        end
    case 'optim9' % ------------------------------------------------------
        % filter design by optimization method, synthesis and analysis
        % fiters are the same centro-symmetric filters
        % high pass filter is modulation of lowpass filter

        h0 =  10^(-3)*[...
            0.0744   -0.3361   -2.5823    0.7787   -2.0561    0.7966   -0.6866   -0.6434    0.0665
            0.3058    4.7015   -7.7192   -5.4991   -2.1719  -10.6472   -3.4500    1.6892    0.6543
            -2.0812    6.8068   12.5743  -34.8545  -27.5217  -43.0428   26.0018    3.6422   -0.9481
            -0.5519   -2.7023   28.8237   74.4245 -278.9884   64.1302   45.6976  -10.8442   -0.9527
            -2.3530    3.4648  -23.8808  266.2680  816.0931  266.2680  -23.8808    3.4648   -2.3530
            -0.9527  -10.8442   45.6976   64.1302 -278.9884   74.4245   28.8237   -2.7023   -0.5519
            -0.9481    3.6422   26.0018  -43.0428  -27.5217  -34.8545   12.5743    6.8068   -2.0812
            0.6543    1.6892   -3.4500  -10.6472   -2.1719   -5.4991   -7.7192    4.7015    0.3058
            0.0665   -0.6434   -0.6866    0.7966   -2.0561    0.7787   -2.5823   -0.3361    0.0744];

        h1 = h0;
        h1(2:2:end, 1:2:end) = -h1(2:2:end, 1:2:end);
        h1(1:2:end, 2:2:end) = -h1(1:2:end, 2:2:end);
      
    case 'optim11'
        
        h0 = 10^(-3)*sqrt(2)*[ ...
            -0.0457    0.4225   -0.1463    0.1600    1.1171   -0.4570    1.1171    0.1600   -0.1463    0.4225   -0.0457;
            0.3557    0.0362    0.1650   -2.7032   -0.5488   -4.4739   -0.5488   -2.7032    0.1650    0.0362    0.3557;
            0.0845   -0.1945   -7.3984    8.3702    5.9456    8.9636    5.9456    8.3702   -7.3984   -0.1945    0.0845;
            0.1172   -2.7413    8.7215   21.4156  -43.1093   -7.2819  -43.1093   21.4156    8.7215   -2.7413    0.1172;
            0.8169   -0.2165    5.4719  -40.6566  -31.7533  184.6749  -31.7533  -40.6566    5.4719   -0.2165    0.8169;
            -0.2627   -3.6227    6.7719   -7.6965  183.1327  585.7587  183.1327   -7.6965    6.7719   -3.6227   -0.2627;
            0.8169   -0.2165    5.4719  -40.6566  -31.7533  184.6749  -31.7533  -40.6566    5.4719   -0.2165    0.8169;
            0.1172   -2.7413    8.7215   21.4156  -43.1093   -7.2819  -43.1093   21.4156    8.7215   -2.7413    0.1172;
            0.0845   -0.1945   -7.3984    8.3702    5.9456    8.9636    5.9456    8.3702   -7.3984   -0.1945    0.0845;
            0.3557    0.0362    0.1650   -2.7032   -0.5488   -4.4739   -0.5488   -2.7032    0.1650    0.0362    0.3557;
            -0.0457    0.4225   -0.1463    0.1600    1.1171   -0.4570    1.1171    0.1600   -0.1463    0.4225   -0.0457];

        h1 = 10^(-3)*sqrt(2)*[ ...
            -0.0406   -0.4278   -0.1415   -0.1653    1.1221    0.4515    1.1221   -0.1653   -0.1415   -0.4278   -0.0406;
            -0.3609    0.0412   -0.1705   -2.6982    0.5436   -4.4691    0.5436   -2.6982   -0.1705    0.0412   -0.3609;
            0.0895    0.1893   -7.3936   -8.3754    5.9507   -8.9690    5.9507   -8.3754   -7.3936    0.1893    0.0895;
            -0.1225   -2.7362   -8.7270   21.4207   43.1040   -7.2771   43.1040   21.4207   -8.7270   -2.7362   -0.1225;
            0.8220    0.2113    5.4767   40.6513  -31.7482 -184.6804  -31.7482   40.6513    5.4767    0.2113    0.8220;
            0.2575   -3.6176   -6.7774   -7.6915 -183.1379  585.7635 -183.1379   -7.6915   -6.7774   -3.6176    0.2575;
            0.8220    0.2113    5.4767   40.6513  -31.7482 -184.6804  -31.7482   40.6513    5.4767    0.2113    0.8220;
            -0.1225   -2.7362   -8.7270   21.4207   43.1040   -7.2771   43.1040   21.4207   -8.7270   -2.7362   -0.1225;
            0.0895    0.1893   -7.3936   -8.3754    5.9507   -8.9690    5.9507   -8.3754   -7.3936    0.1893    0.0895;
            -0.3609    0.0412   -0.1705   -2.6982    0.5436   -4.4691    0.5436   -2.6982   -0.1705    0.0412   -0.3609;
            -0.0406   -0.4278   -0.1415   -0.1653    1.1221    0.4515    1.1221   -0.1653   -0.1415   -0.4278   -0.0406];

    case 'meyer' % -------------------------------------------------------
        % estimate meyer type diamond filter bank
        N = 128;

        [x1, x2] = meshgrid(0:2*pi/(N):2*pi,0:2*pi/(N):2*pi);
        X = x1 + x2;
        F1 = zeros(size(X));
        F1( find( (X < 2*pi/3) ) )= 1;
        int2 = find( (X >= 2*pi/3) & (X  < 4*pi/3) );
        F1( int2 ) = cos(pi/2*meyeraux(3/2/pi*X(int2)-1));

        Fs = F1.^2+rot90(F1.^2,1)+rot90(F1.^2,2)+rot90(F1.^2,3);
        Fs = Fs(1:N,1:N);
        % F2 = fftshift(F1);
        % Gs = F2.^2+rot90(F2.^2,1)+rot90(F2.^2,2)+rot90(F2.^2,3);
        Gs = fftshift(Fs);
        F = sqrt(Fs./(Fs+Gs));
        G = sqrt(Gs./(Fs+Gs));

        h0 = ifftshift(ifft2(F));
        h1 = ifftshift(ifft2(G));
        L = 30;
        cen = N/2 + 1;
        h0 = sqrt(2)*h0(cen-L:cen+L,cen-L:cen+L);
        h1 = sqrt(2)*h1(cen-L:cen+L,cen-L:cen+L);
        % nomralized , improve 1 to 2 db
        % h0 = modulate2(h0,'c'); h0 = h0./sum(h0(:)); h0 = modulate2(h0,'c');
        % h1 = modulate2(h1,'c'); h1 = h1./sum(h1(:)); h1 =
        % modulate2(h1,'c');
    case 'meyerh2' % estimate meyer type fan fb for the second level of the dual dfb
        N = 128;
        [x1, x2] = meshgrid(0:2*pi/(N):2*pi,0:2*pi/(N):2*pi);
        X = x1 + x2;
        F1 = zeros(size(X));
        F1( find( (X < 2*pi/3) ) )= 1;
        int2 = find( (X >= 2*pi/3) & (X  < 4*pi/3) );
        F1( int2 ) = cos(pi/2*meyeraux(3/2/pi*X(int2)-1));

        Fs = F1.^2+rot90(F1.^2,1)+rot90(F1.^2,2)+rot90(F1.^2,3);
        Fs = Fs(1:N,1:N);
        Gs = fftshift(Fs);

        %calculate the FG mask for the dual case, second level
        alpha = 0.2*pi;
        X2 = -abs(x1-x2)*(2*pi/(3*alpha))+ 4*pi/3;
        X1 = fftshift(X2); X2(find(abs(x1-x2)> pi) ) = X1(find(abs(x1-x2)> pi) );
        Fdm = zeros(size(X2)); % Fdual mask
        Fdm( find( X2 < 2*pi/3) )= 1;
        int2 = find( X2  >= 2*pi/3 );
        Fdm( int2 ) = cos(pi/2*meyeraux(3/2/pi*X2(int2)-1));

        F = sqrt(2*Fs./(Fs+Gs));
        G = sqrt(2*Gs./(Fs+Gs));

        F = F([N/2+1:end,1:N/2],:);
        G = G([N/2+1:end,1:N/2],:);
        % F and G are the FFT2 of Fan FB

        % prepare the phase
        [w1, w2] = meshgrid(-pi:2*pi/(N):pi, -pi:2*pi/(N):pi);
        phase = ((w1+w2 )>= 0).*(-w1/2-w2/2+pi/2) + ...
            ((w1+w2 )< 0).*(-w1/2-w2/2-pi/2) ;
        % make the phase border periodic
        temp = phase(1,:)+phase(end,:);phase(1,:) = temp/2;phase(end,:) = temp/2;
        temp = phase(:,1)+phase(:,end);phase(:,1) = temp/2;phase(:,end) = temp/2;
        % make the phase symmetric
        phase = phase - rot90(phase,2);
        % cut the phase to NN
        phase = 0.5*phase(1:N,1:N);
        % not necessary, since the phase is the same is shifted by pi pi
        phase = fftshift(phase);
        % dual mask
        Fdm = rot90(Fdm); Fdm = Fdm(1:N,1:N);
        F = F.*exp(-i*Fdm.*phase);
        G = G.*exp(-i*Fdm.*phase);

        if lower(type(1)) == 'r'
            F = conj(F); G = conj(G);
        end

        h1 = ifftshift(ifft2(F));
        h0 = ifftshift(ifft2(G));
        L = 30;
        cen = N/2 + 1;
        % h0 = real(fitmat(h0,2*L));
        % h1 = real(fitmat(h1,2*L));
        h0 = real(h0(cen-L:cen+L,cen-L:cen+L));
        h1 = real(h1(cen-L:cen+L,cen-L:cen+L));

    case 'meyerh3' % estimate meyer type fan fb for the second level of the dual dfb
        N = 128;
        [x1, x2] = meshgrid(0:2*pi/(N):2*pi,0:2*pi/(N):2*pi);
        X = x1 + x2;
        F1 = zeros(size(X));
        F1( find( (X < 2*pi/3) ) )= 1;
        int2 = find( (X >= 2*pi/3) & (X  < 4*pi/3) );
        F1( int2 ) = cos(pi/2*meyeraux(3/2/pi*X(int2)-1));

        Fs = F1.^2+rot90(F1.^2,1)+rot90(F1.^2,2)+rot90(F1.^2,3);
        Fs = Fs(1:N,1:N);
        Gs = fftshift(Fs);

        %calculate the FG mask for the dual case, second level
        alpha = 0.2*pi;
        X2 = -abs(x1-x2)*(2*pi/(3*alpha))+ 4*pi/3;
        X1 = fftshift(X2); X2(find(abs(x1-x2)> pi) ) = X1(find(abs(x1-x2)> pi) );
        Fdm = zeros(size(X2)); % Fdual mask
        Fdm( find( X2 < 2*pi/3) )= 1;
        int2 = find( X2  >= 2*pi/3 );
        Fdm( int2 ) = cos(pi/2*meyeraux(3/2/pi*X2(int2)-1));

        F = sqrt(2*Fs./(Fs+Gs));
        G = sqrt(2*Gs./(Fs+Gs));

        F = F([N/2+1:end,1:N/2],:);
        G = G([N/2+1:end,1:N/2],:);
        % F and G are the FFT2 of Fan FB

        % prepare the phase
        [w1, w2] = meshgrid(-pi:2*pi/(N):pi, -pi:2*pi/(N):pi);
        phase = ((-w1+w2 )>= 0).*(w1/2-w2/2+pi/2) + ...
            ((-w1+w2 )< 0).*(w1/2-w2/2-pi/2) ;
        % make the phase border periodic
        temp = phase(1,:)+phase(end,:);phase(1,:) = temp/2;phase(end,:) = temp/2;
        temp = phase(:,1)+phase(:,end);phase(:,1) = temp/2;phase(:,end) = temp/2;
        % make the phase symmetric
        phase = phase - rot90(phase,2);
        % cut the phase to NN
        phase = 0.5*phase(1:N,1:N);
        % not necessary, since the phase is the same is shifted by pi pi
        phase = fftshift(phase);
        Fdm = Fdm(1:N,1:N);
        F = F.*exp(-i*Fdm.*phase);
        G = G.*exp(-i*Fdm.*phase);

        if lower(type(1)) == 'r'
            F = conj(F); G = conj(G);
        end

        h1 = ifftshift(ifft2(F));
        h0 = ifftshift(ifft2(G));
        L = 30;
        cen = N/2 + 1;
        % h0 = real(fitmat(h0,2*L));
        % h1 = real(fitmat(h1,2*L));
        h0 = real(h0(cen-L:cen+L,cen-L:cen+L));
        h1 = real(h1(cen-L:cen+L,cen-L:cen+L));

    otherwise
        error('Unrecognized directional filter name');

end

%-----------------------------------------------------------------------
% Internal function
% ----------------------------------------------------------------------

function h_trans=trans_matrix(N)
% this function return the transformation matrix as in Tay and Kingsburry paper
%
% properties : size 2N+1*2N+1
% h_trans(k1,k2)= 0 when k1+k2 even
% h_trans(k1,k2) linear phase
% h_trans(w1,w2)=1 in the passband (diamond)
% and =-1 in the stopband (outside the dimamond)

[n1,n2]=meshgrid(-N:N,-N:N);
h_ideal=sinc((n1+n2)/2).*sinc((n1-n2)/2);
h_ideal(N+1,N+1)=0;

% choose Kaiser window
beta=2.5;
w = kaiser(2*N+1,beta);

% index matrix
n3=n1+n2;
n4=n1-n2;
% set up window
w1=zeros(2*N+1,2*N+1);
w2=zeros(2*N+1,2*N+1);

for i=-N:1:N
    % Kaiser window for n1+n2
    w1(abs(n3)==i)=w(i+N+1);
    % Kaiser window for n1-n2
    w2(abs(n4)==i)=w(i+N+1);
end
% This is the two dimension diamond Kaiser window
win=w1.*w2;
h_trans=h_ideal.*win;

