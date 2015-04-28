function dump_wbldata(data,where,offset)
    if offset == 0
      flist = fopen(fullfile(where,'filelist.txt'),'wt');
    else
      flist = fopen(fullfile(where,'filelist.txt'),'at');
    end
    for i=1:length(data)
        xi = data{i}.features;
        if (sum(xi == Inf) > 0) % in case Inf occurs (e.g. empty picture) set all to zero 
            xi = zeros(1,length(data{i}.features));
            fprintf(1,'setting features to zero\n');
        end
        fprintf(flist,'model%d\n',i+offset-1);
        wblstr = sprintf('model%d.wbl',i+offset-1);
        fidwbl = fopen(fullfile(where,wblstr),'wb');
        fwrite(fidwbl,xi,'double');
        fclose(fidwbl);
    end
    fclose(flist);
end
