% SRCFUN Apply function to each filenames of a ScatNet-compatible src
%
% Usage
%   cell_out = SRCFUN(fun, src);

function roto_trans_scatt_multiscale_log_sp_avg = new_srcfun(fun, src,fmt,M,margintype,copulatype,debug)

time_start = clock;
for k = 1:length(src.files)
    db.indices{k} = k;
    filename = src.files{k};
    % %cell_out{1} = fun(filename);
    tmp = imreadBW(filename);
    cell_out = fun(tmp);
    clear tmp;
    out=[];
    for i=1:2
        msize=size(cell_out{i}.signal,2);
        for ss=1:msize
            out = [out double(log(cell_out{i}.signal{ss}(:)))];
        end
    end
    %        tempout=format_scat(cell_out,'table');
    %        out=double(mean(log(tempout),3)');
    
    %###############对每幅图像单独变换直到最后形成特征，以节省内存和时间开支
    % f_fun = @(Sx)(mean(mean(log(format_scat(Sx,fmt,M)),2),3));
    model = ctbfit(abs(out),'margin', margintype, 'copula',copulatype,'debug',debug);
    roto_trans_scatt_multiscale_log_sp_avg{k} = model;
    
    %         ctbfit(abs(double(out)),'margin', margintype, 'copula',copulatype,'debug',debug);
    %         roto_trans_scatt_multiscale_log_sp_avg{k} = cellfun_monitor(f_fun, cell_out);
    
    
%     tm0 = tic;
%     time_elapsed = etime(clock, time_start);
%     estimated_time_left = time_elapsed * (length(src.files)-k) / k;
%     fprintf('calculated features for %s. (%.2fs)\n',src.files{k},toc(tm0));
%     fprintf('%d / %d : estimated time left %d seconds\n',k,length(src.files),floor(estimated_time_left));
end
end
