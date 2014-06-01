function llf = ctbll(samples,model,margintype,copulatype)
%%%% 对应方程（7）
    nsamples = size(samples,1);
    mllf = 0;
    for i=1:size(samples,2)
        switch margintype
            % transform the margins to uniform and compute margin llf
            case 'Weibull'
                mllf = mllf + 1/nsamples * sum(log(wblpdf(samples(:,i), ...
                    model.margins(i,1),...
                    model.margins(i,2))));
                Y(:,i) = wblcdf(samples(:,i), ...
                    model.margins(i,1),...
                    model.margins(i,2));
            case 'Gamma'
                mllf = mllf + 1/nsamples * sum(log(gampdf(samples(:,i), ...
                    model.margins(i,1),...
                    model.margins(i,2))));
                Y(:,i) = gamcdf(samples(:,i), ...
                    model.margins(i,1),...
                    model.margins(i,2));
        end
    end
    % compute copula llf based on the PIT transformed margins
    switch copulatype
        case 'Gaussian'
            m=copulapdf('Gaussian',Y,model.Rho);
            cllf = 1/size(Y,1)* ...
                sum(log(copulapdf('Gaussian',Y,model.Rho)));
        case 't'
            cllf = 1/size(Y,1)* ...
                sum(log(copulapdf('t',Y,model.Rho,model.nu)));
    end
        llf = cllf + mllf;
end
