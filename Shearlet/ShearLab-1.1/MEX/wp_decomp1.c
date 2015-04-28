/*

wp_decomp1.c	.MEX file 
see wp_decomp1.m
  
  The calling syntax is:

			wc = wp_decomp1(img,scale,qmf)

This is a modified version of WPAnalysis.c (from WaveLab850).
*/

#include <math.h>
#include "mex.h"
#include "wavelab.h"

#define DOUBLE		double
#define INT			int

/* prototypes 

void wpd(double *sig,int nr,int Dee,double *hpf,double *lpf,int lenfil,double *wc,double *temp);
void downhi(double *x,int n,double *hpf,int m,double *y);
void downlo(double *x,int n,double *lpf,int m,double *y);
void mirrorfilt(double *lpf,double *hpf,int length);
void copydouble(DOUBLE *x,DOUBLE *y,int n);
*/

/* Input Arguments */

#define	Sig_IN	prhs[0]
#define	LLL_IN	prhs[1]
#define  LPF_IN prhs[2]


/* Output Arguments */

#define	WP_OUT	plhs[0]

INT nlhs, nrhs;
mxArray *plhs[], *prhs[];

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
	DOUBLE	*hpf,*lpf;
	DOUBLE	*sig,*wcp,*wcp1,*wcp2;
/*	unsigned int	m,n;  */
	int nr,nc,nn,mm,kk,J,lenfil,dee;
	mxArray *temp, *hpfmat, *WP_OUT1, *WP_OUT2;



	/* Check for proper number of arguments */

	if (nrhs != 3) {
		mexErrMsgTxt("wp_decomp1 requires three input arguments.");
	} else if (nlhs != 1) {
		mexErrMsgTxt("wp_decomp1 requires one output argument.");
	}


	/* Check the dimensions of signal.  signal can be n X 1 or 1 X n. */

	nr  = mxGetM(Sig_IN);
	nc = mxGetN(Sig_IN);
	
    J = 0;
	for( nn = 1; nn < nc;  nn *= 2 )  
		 J ++;
	if(  nn  !=  nc){
		mexErrMsgTxt("wp_decomp1 requires dyadic length");
	}
    J = 0;
	for( nn = 1; nn < nr;  nn *= 2 )  
		 J ++;
	if(  nn  !=  nr){
		mexErrMsgTxt("wp_decomp1 requires dyadic length");
	}
    WP_OUT = mxCreateDoubleMatrix(nr, nc, mxREAL);
    sig = mxGetPr(Sig_IN);
    wcp = mxGetPr(WP_OUT);
    lenfil =  (int) (mxGetM(LPF_IN) * mxGetN(LPF_IN));   /* should check this */
    
    lpf = mxGetPr(LPF_IN);
    hpfmat = mxCreateDoubleMatrix((unsigned int) lenfil,  1, mxREAL);
    hpf    = mxGetPr(hpfmat);
    mirrorfilt(lpf,hpf,lenfil);
    
    for( kk = 0; kk < mxGetN(LLL_IN); kk++) {
        dee =  floor ((mxGetPr(LLL_IN))[kk] + .5);   /* should check whether this is in range */
	    /* Create a matrix for the return argument */
	    if( dee > J ){
	    	mexErrMsgTxt("wp_decomp1 requires D < log_2(n)");
         }
        if( dee < 0){
	        mexErrMsgTxt("wp_decomp1 requires D >= 0");
	     }
    	nn = dee+1;
        for( mm = nc/2; mm < nc; mm++){  
            WP_OUT1 = mxCreateDoubleMatrix(nr, nn, mxREAL);
            WP_OUT2 = mxCreateDoubleMatrix(nr, 1, mxREAL);
            temp   = mxCreateDoubleMatrix(nr, 4, mxREAL);
        	/* Assign pointers to the various parameters */
        	wcp1 = mxGetPr(WP_OUT1);
            wcp2 = mxGetPr(WP_OUT2);
            copydouble(&sig[mm*nr],wcp2,nr);
            /* Do the actual computations in a subroutine */
        	wpd(wcp2,nr,dee,hpf,lpf,lenfil,wcp1,mxGetPr(temp));
            copydouble(&wcp1[dee*nr],&wcp[mm*nr],nr);
         	mxDestroyArray(temp);
        }
        nc = nc/2;
    }
    mxDestroyArray(hpfmat);
}

#define LSON(d,b)  (d+1)*nr + (2*b+bit)*(nj/2)
#define RSON(d,b)  (d+1)*nr + (2*b+1-bit)*(nj/2)
#define PKT(d,b)    d*nr + b*nj
void wpd(sig,nr,Dee,hpf,lpf,lenfil,wc,temp)
DOUBLE sig[],hpf[],lpf[],wc[],temp[];
int  nr,Dee,lenfil;
{
        DOUBLE *tmplo,*tmphi;
        int nj,d,b,nb,bit;
        copydouble(sig,wc,nr);
		tmplo = &temp[nr];
		tmphi = &temp[2*nr];
		nb = 1; nj = nr;
        for( d=0; d < Dee; d++){
			 bit = 0;
			 for( b=0; b < nb; b++){
				copydouble(&wc[PKT(d,b)],temp,nj);
                downlo(temp, nj, lpf,lenfil,tmplo);
				downhi(temp, nj, hpf,lenfil,tmphi);
				copydouble(tmplo,&wc[LSON(d,b)],nj/2);
				copydouble(tmphi,&wc[RSON(d,b)],nj/2);
				bit =1-bit;
             }
			 nj = nj/2; nb = nb*2;
        }
}

void copydouble(x,y,n)
DOUBLE *x,*y;
int n;
{
   while(n--) *y++ = *x++;
}
 
#include "downhi.c"
#include "downlo.c"
#include "mirrorfilt.c"
