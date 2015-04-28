%  ShearLab-PPFT-1.0 -- initialize path to include ShearLab-PPFT-1.0 
%

	fprintf('Welcome to ShearLab-PPFT-1.0\n');
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
	  SHEARLABPATH = ['Macintosh HD:Build 100:ShearLab-1.0$VERSION$', PATHNAMESEPARATOR];
	  MATLABPATHSEPARATOR = ';';
      SHEARLABPATH=strcat(matlabroot,'/toolbox/ShearLab-PPFT-1.0/')
	elseif isunix,
	  PATHNAMESEPARATOR = '/';
	  SHEARLABPATH = [pwd, PATHNAMESEPARATOR];
	  MATLABPATHSEPARATOR = ':';
      SHEARLABPATH=strcat(matlabroot,'/toolbox/ShearLab-PPFT-1.0/')
	elseif strcmp(Friend(1:2),'PC');
	  PATHNAMESEPARATOR = '\';	  
	  SHEARLABPATH = [cd PATHNAMESEPARATOR];  
      MATLABPATHSEPARATOR = ';';
      SHEARLABPATH=strcat(matlabroot,'\toolbox\ShearLab-PPFT-1.0\')      
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

	p = [p pref 'PPFTs'	post];
    p = [p pref 'Windowing'	post];
    p = [p pref 'Weighting'	post];
    p = [p pref 'Weighting'	PATHNAMESEPARATOR 'Wights' post];
    p = [p pref 'ShearletTransform'	post];
    p = [p pref 'Utilities'	post];
    p = [p pref 'Visualization'	post];
    p = [p pref 'Denoising'	post];
    p = [p pref 'Datasets'	post];
    p = [p pref 'Demos' post];
    p = [p pref 'Documentations' post];
    p = [p pref 'Separation_Package' PATHNAMESEPARATOR 'FFW' post];
    p = [p pref 'Separation_Package' PATHNAMESEPARATOR 'PPFTs' post];
    path(p);
	disp('Pathnames Successfully Set');
	clear p pref post

    
    
%   disp('INSTALLING MEX FILES, MAY TAKE A WHILE ...')
%   disp(' ')
%   disp('Your mex compiler needs to be properly installed.')
%   disp('In particular, you should be able to call mex.m within matlab')
%   disp('to compile a mex file.')
%   disp('Consult your system administrator if not.')
%   disp(' ')      
%   FIRST_COMPILE = 0;
%   
%   eval(sprintf('cd ''%sCodes''', SHEARLABPATH));
%   
%   if isunix
%       switch computer
%           case 'GLNX86'
%               for file={'FWT2_PO' 'IWT2_PO' 'DWT_PO' 'IDWT_PO' 'rec_wp_decomp1' 'wp_decomp1' 'resample1'}
%                   file = char(file);
%                   disp(sprintf('%s.c',file));
%                   eval(sprintf('mex %s.c',file));
%               end
%           case 'GLNXA64'
%               break;
%           otherwise
%               display('Not supported')
%       end
%   else
%       
%   for file={'FWT2_PO' 'IWT2_PO' 'DWT_PO' 'IDWT_PO' 'rec_wp_decomp1' 'wp_decomp1' 'resample1'}
%   
%     file = char(file);
%     disp(sprintf('%s.c',file));
%     eval(sprintf('mex %s.c',file));
%   end
%   end

clear SHEARLABPATH MATLABVERSION PATHNAMESEPARATOR Friend

%
%  Copyright (c) 2010. Wang-Q Lim, University of Osnabrueck
%
%  Part of ShearLab Version 1.0
%  Built Mon, 11/29/2010
%  This is Copyrighted Material
%  For Copying permissions see COPYRIGHT.m
