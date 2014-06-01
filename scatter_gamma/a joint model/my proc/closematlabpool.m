function []=closematlabpool
nlabs=matlabpool('size');
if nlabs>0
    matlabpool close;
end
