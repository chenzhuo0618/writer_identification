function a = dump_ggddata(fe,where,offset)
    if offset == 0
      fl = fopen(fullfile(where,'filelist.txt'),'wt');
    else
      fl = fopen(fullfile(where,'filelist.txt'),'at');
    end
    for i=1:length(fe)
        xi = fe{i}.features;
        fprintf(fl,'model%d\n',i+offset-1);
        s = sprintf('model%d.ggd',i+offset-1);
        fid = fopen(fullfile(where,s),'wb');
        fwrite(fid,xi,'double');
        fclose(fid);
    end
    fclose(fl);
    a = 0;
end
