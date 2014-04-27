This is the readme file for the PDTDFB toolbox, which is a shiftable pyramidal 
decomposition ( see references ). Many functions are developped based on the 
contourlet toolbox available at http://www.ifp.uiuc.edu/~minhdo/software/. 
Some of the functions in the contourlet toobox are rewritten
in this toolbox. We also use some functions from the shiftable pyramid toolbox
at http://www.cns.nyu.edu/~lcv/software.html

This is the list of main functions. For syntax of each function, see the 
content of the m files

LEVEL 1
* The two main PDTDFB decompostion and reconstruction functions 

PDTDFBDEC : Pyramid Dual Tree Directional Filterbank Decomposition 
PDTDFBREC : Pyramid Dual Tree Directional Filterbank Reconstruction 

PDTDFBDEC_F  Pyramid Dual Tree Directional Filterbank Decomposition 
using FFT at the multresolution FB and the first two level of dual DFB
tree  
PDTDFBREC_F  Pyramid Dual Tree Directional Filterbank Reconstruction 
using FFT at the multresolution FB and the first two level of dual DFB
tree  

LEVEL 2
* DFB decomposition and reconstruction functions

TDFBDEC : DFB decomposition with phase correction at each stage of the tree
TDFBREC : DFB reconstruction with phase correction at each stage of the tree

TDFBDEC_L : Directional Filterbank Decomposition using Ladder Structure
TDFBREC_L : Directional Filterbank Reconstruction using Ladder Structure

LPREC : Pyramid Decomposition
LPDEC : Pyramid Reconstruction

LEVEL 3 
* Two channel FB decomposition and reconstruction
FBDEC  Two-channel 2D Filterbank Decomposition   
FBREC  Two-channel 2D Filterbank Reconstruction  
FBDEC_L  Two-channel 2D Filterbank Decomposition using Ladder Structure
FBREC_L  Two-channel 2D Filterbank Reconstruction using Ladder Structure 

SUPPORT FUNCTIONS
* Resampling functions
BACKSAMP  
REBACKSAMP  
RESAMP      

PUP    
PDOWN          

DUP       
DDOWN     

QUP    
QDOWN  

QPDEC  
QPREC  

PPDEC        
PPREC  

* Utility functions
PDTDFB_WIN   
FUN_MEYER  

ANG_PDFB   : Return the angle of the direction of the filter in radian
PDFB_ANG   : Return the directional filter that the angle fall into
SNR

* Filters functions
DFILTERS  
LDFILTER   
MCTRANS    
PFILTERS     
FFILTERS  

* Signal manipulation
MKZERO_PDTDFB : Make a data structure similar to a PDTDFB decomposition filled with zeros
INTERPFILT : Interpolation based on digital filter
PDTDFB2VEC     
VEC2PDTDFB
FITMAT     
MODULATE2      
EXTEND2   
PERIODIZE    

*Convolution and filtering
SEFILTER2   
EFILTER2  
FCONV2    

DEMO SCRIPTS 

DEMO_PDTDFB_F
DEMO_DENOISE



