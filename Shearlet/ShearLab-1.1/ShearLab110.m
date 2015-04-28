%  ShearLab110 -- initialize path to include ShearLab-1.1 
%
 
    fprintf('Welcome to ShearLab v 1.10 \n');
    disp('Setting Global Variables');
%
    global SHEARLABPATH
    global PATHNAMESEPARATOR
    global PREFERIMAGEGRAPHICS
    global MATLABPATHSEPARATOR
    global SLVERBOSE
    
    SLVERBOSE = 'Yes';
    PREFERIMAGEGRAPHICS = 1;
%
    Friend = computer;
    if strcmp(Friend,'MAC2'),
      PATHNAMESEPARATOR = ':';
      SHEARLABPATH = ['Macintosh HD:Build 100:ShearLab-1.1$VERSION$', PATHNAMESEPARATOR];
      MATLABPATHSEPARATOR = ';';
      SHEARLABPATH=strcat(matlabroot,'/toolbox/ShearLab-1.1/')
    elseif isunix,
      PATHNAMESEPARATOR = '/';
      SHEARLABPATH = [pwd, PATHNAMESEPARATOR];
      MATLABPATHSEPARATOR = ':';
      SHEARLABPATH=strcat(matlabroot,'/toolbox/ShearLab-1.1/')
    elseif strcmp(Friend(1:2),'PC');
      PATHNAMESEPARATOR = '\';    
      SHEARLABPATH = [cd PATHNAMESEPARATOR];  
      MATLABPATHSEPARATOR = ';';
      SHEARLABPATH=strcat(matlabroot,'\toolbox\ShearLab-1.1\')
    else
        disp('I don*t recognize this computer; ') 
        disp('Pathnames not set; solution: edit ShearPath.m')
    end
    
 
UserWavelabPath='';
while (exist(SHEARLABPATH)~=7)
    SHEARLABPATH=input(sprintf('Directory %s does not exist.\nEnter the correct path (type 0 to exit): ',SHEARLABPATH),'s')
    if SHEARLABPATH=='0'
        fprintf('\nError occurs and ShearLab has not been set up.\n')
        fprintf('Solution: Identify the correct path for ShearLab Directory in toolbox\n\n')
        clear all;
        return;
    end
    if (SHEARLABPATH(end))~=PATHNAMESEPARATOR
          SHEARLABPATH=strcat(SHEARLABPATH, PATHNAMESEPARATOR);
    end
end
 
    %
    global MATLABVERSION
    V = version;
    MATLABVERSION = str2num(V(1:3));
 
        if MATLABVERSION < 6,
          disp('Warning: This version is only supported on Matlab 6.x and 7.x');
        end
%
        % Basic Tools
    p = path;
    pref = [MATLABPATHSEPARATOR SHEARLABPATH];
    post = PATHNAMESEPARATOR;
    p = [p pref];
 
    p = [p pref 'Fourier_based_shearlet_transform'  post];
    p = [p pref 'Separation_Package'    post];
    p = [p pref 'Shearlet_Transform_with_Separable_Generator'   post];
    p = [p pref 'Image_Data'    post];
    p = [p pref 'MEX'   post];
    p = [p pref 'Separation_Package' PATHNAMESEPARATOR 'Wavelets' post];
    p = [p pref 'Separation_Package' PATHNAMESEPARATOR 'UDWT' post];
    p = [p pref 'Shearlet_Transform_with_Separable_Generator' PATHNAMESEPARATOR 'Codes' post];
    p = [p pref 'Shearlet_Transform_with_Separable_Generator' PATHNAMESEPARATOR 'Demo' post];
    p = [p pref 'Shearlet_Transform_with_Separable_Generator' PATHNAMESEPARATOR 'Scripts_for_Testing' post];
    path(p);
    disp('Pathnames Successfully Set');
    clear p pref post
 
    
    
  disp('INSTALLING MEX FILES, MAY TAKE A WHILE ...')
  disp(' ')
  disp('Your mex compiler needs to be properly installed.')
  disp('In particular, you should be able to call mex.m within matlab')
  disp('to compile a mex file.')
  disp('Consult your system administrator if not.')
  disp(' ')      
  FIRST_COMPILE = 0;
  
  eval(sprintf('cd ''%sMEX''', SHEARLABPATH));
     
  for file={'FWT2_PO.c' 'IWT2_PO.c' 'DWT_PO.c' 'IDWT_PO.c' 'rec_wp_decomp1.c' 'wp_decomp1.c' 'resample1.c' 'atrousc.c' 'mdwt.c mdwt_r.c' 'midwt.c midwt_r.c' 'mirdwt.c mirdwt_r.c' 'mrdwt.c mrdwt_r.c'}
  
    file = char(file);
    disp(sprintf('%s',file));
    eval(sprintf('mex %s',file));
  end
  
 
clear SHEARLABPATH MATLABVERSION PATHNAMESEPARATOR Friend
 
%
%  Copyright (c) 2010. Wang-Q Lim, University of Osnabrueck
%
%  Part of ShearLab Version 1.1
%  Built Mon, 11/29/2010
%  This is Copyrighted Material
%  For Copying permissions see COPYRIGHT.m

