% cellfun_monitor : apply a function to each element of a cell array
%   and monitor the estimated time left every second
%
% Usage :
%   cell_out = cellfun_monitor(fun, cell_in);
%
% Input :
%   fun (function_handle) : the function handle to be applied
%   cell_in (cell) : the cell whose element will be applied fun to
%
% Output :
%   cell_out (cell) : the transformed cell

function cell_out = owncellfun_monitor(fun, cell_in)
cell_out = fun(cell_in);
end