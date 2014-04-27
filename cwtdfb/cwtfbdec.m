function y = cwtfbdec( x, J, dfilt, nlevs)
% im=imread('zoneplate.png');
% x=double(im);
% J=1;
% nlevs=3;

if length(nlevs) == 0
    y = {x};
    
else
    
    if nlevs(end) ~= 0
        % Laplacian decomposition
        
       [xlo,xh,Yscale] = dtwavexfm2(x,J,'near_sym_b','qshift_b');
         xhi=cell(J,12);
         for i=1:J
              index=1;
              for j=1:6
                  xhi{i,index}=real(xh{i,1}(:,:,j));
                  index=index+1;
                  xhi{i,index}=imag(xh{i,1}(:,:,j));
                  index=index+1;
              end
         end

          [m,n]=size(xhi);
          xhi_dir=[];
          y=[];
          
           for i=1:m
               for j=1:n
                   xhi_dir1 = dfbdec_l(xhi{m,n}, dfilt, nlevs(end));
                   xhi_dir = [xhi_dir, xhi_dir1];
                end
           end    
    else        
       disp('there is a mistake!');    
    end
    
    % Recursive call on the low band
    ylo = cwtfbdec(xlo, J, dfilt, nlevs(1:end-1));

    % Add bandpass directional subbands to the final output
    y = {ylo{:}, xhi_dir};
                
end

