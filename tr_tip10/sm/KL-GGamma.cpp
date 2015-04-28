#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_sf.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_linalg.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_cblas.h>
#include <math.h>
#include "diststore.h"
#include "common.h"
#include "pthread.h"
#include "getopt.h"

static void distance(gsl_vector **, unsigned int, unsigned int, unsigned int, unsigned int);
//static double probdist(gsl_vector **, int, int, unsigned int);
static double probdist_fast(gsl_vector **, int, int, unsigned int);

static void *distance_thread(void *thread_params);
typedef struct {
    gsl_vector **ggamlist;
    unsigned int dim;
} metric_params_t;

// globals
const char *progname = "KL-GGamma";
unsigned int verbose = 0;

// default values
const char *DIST_OUT_FNAME = "dist.bin";
const char *LIST_FNAME = "filelist.txt";
const char *BASE_PATH = "";
const unsigned int DEFAULT_SCALES = 3; // default 3 scales 
const unsigned int DEFAULT_CHANNELS = 3; // color images per default
const unsigned int DEFAULT_ORIENTATIONS = 3; // 3 detail subbands
const unsigned int DEFAULT_START_IMAGE = 0;
const unsigned int DEFAULT_PROCESS_IMAGES = 0;
const unsigned int DEFAULT_NUM_THREADS = 1;
const unsigned int DEFAULT_PARAMNUM = 2; // per default the distributions have two parameters

static void usage() {
    fprintf(stderr,
        "usage: %s [-S n] [-C n] [-F n] [-d file] [-l file] [-s n] [-c n] [-t n] [-m mode]\n"
        "\n"
        "\t-S n\t\tnumber of scales (default: %d)\n"
		"\t-C n\t\tnumber of channels (default: %d)\n"
        "\t-F n\t\tnumber of dist. parameters (default: %d)\n"
        "\t-O n\t\tnumber of orientations (default: %d)\n"
        "\t-d file\t\tfile name of output distance matrix\n\t\t\t(default: %s)\n"
        "\t-l file\t\tfile name with list of files to process\n\t\t\t(default: %s)\n"
        "\t-s n\t\timage to start from, should be multiple of 16 (default: 0)\n"
        "\t-c n\t\tnumber of images to process (default: 0 .. all)\n"
        "\t-t n\t\tnumber of threads to use (default: 1)\n"        
        "\t-m mode\t\tcomputation mode 'matrix' or 'bestn' (default: 'matrix')\n"
        "\t-v\t\tverbose\n",
			progname, DEFAULT_SCALES, DEFAULT_CHANNELS, 
			DEFAULT_PARAMNUM, DEFAULT_ORIENTATIONS, DIST_OUT_FNAME, 
			LIST_FNAME);
}

int main (int argc, char *argv[]) {
    int c;
    unsigned int num, cnt;

    unsigned int S = DEFAULT_SCALES; 
	unsigned int C = DEFAULT_CHANNELS;
	unsigned int F = DEFAULT_PARAMNUM;
	unsigned int O = DEFAULT_ORIENTATIONS;
	unsigned int dim = S*C*F*O;
    char dist_out_fname[1024]; strcpy(dist_out_fname, DIST_OUT_FNAME);
    char list_fname[1024]; strcpy(list_fname, LIST_FNAME);
    char base_path[1024]; strcpy(base_path, BASE_PATH);
    unsigned int start_image = DEFAULT_START_IMAGE;
    unsigned int process_images = DEFAULT_PROCESS_IMAGES;
    unsigned int num_threads = DEFAULT_NUM_THREADS;
    compmode_t mode = DISTMATRIX;
    bool benchmark = false;
    
    while ((c = getopt(argc, argv, "S:C:F:O:d:l:m:s:c:t:hvTB:")) != EOF) {
        switch (c) {
            case 'S':
                S = atoi(optarg);
                break;
			case 'C':
				C = atoi(optarg);
				break;
			case 'F':
				F = atoi(optarg);
				break;
			case 'O':
				O = atoi(optarg);
				break;
            case 'd':
                strcpy(dist_out_fname, optarg);
                break;
            case 'l':
                strcpy(list_fname, optarg);
                break;
            case 'm':
                mode = check_compmode(optarg);
                break;
            case 's':
                start_image = atoi(optarg);
                break;
            case 'c':
                process_images = atoi(optarg);
                break;
            case 't':
                num_threads = atoi(optarg);
                break;
            case 'T':
                benchmark = true;
                break;
            case 'B':
                strcpy(base_path, optarg);
                if (strlen(base_path) > 0 && base_path[strlen(base_path)-1] != '/') strcat(base_path, "/");
                break;
            case 'h':
            case '?': 
                usage();
                exit(0);                                           
            case 'v':
                verbose = 1;
                break;
        }
    }
    argc -= optind;
    argv += optind;
    dim = S*C*F*O; 
    num = count_listfile(list_fname);  // number of images  

    FILE *listfile = fopen(list_fname, "rt");
    if (!listfile || num < 0) {
        fprintf(stderr, "%s: failed to open '%s': %s\n", progname, list_fname, strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    if (num == 0) {
        fprintf(stderr, "%s: no entries in file list to process, exit.\n", progname);
        exit(EXIT_FAILURE);
    }
    
	// list of Generalized Gamma parameter vectors
 	gsl_vector **ggamlist = (gsl_vector **)malloc(num * sizeof(gsl_vector *));
    
	cnt = 0;
    if (verbose) fprintf(stderr, "%s: trying to read %d models ...\n", progname, num);
    char line[1024]; // whole line
	while (fgets(line, sizeof(line), listfile) != NULL) {
    	char modelname[1024]; // name of model
        if (strlen(line) <= 1) continue;
	    line[strlen(line)-1] = '\0';
  		if (verbose)
            fprintf(stderr, "%s: reading %d Generalized Gamma parameters for %s\n", progname, dim, line);

		sprintf(modelname, "%s%s.ggam", base_path, line);
		FILE *mfile = fopen(modelname, "rb");
        if (!mfile) {
            fprintf(stderr, "%s: failed to open '%s': %s\n", progname, modelname, strerror(errno));
            exit(EXIT_FAILURE);
        }
		
		gsl_vector *wbl = gsl_vector_calloc(dim);
		if (gsl_vector_fread(mfile, wbl) == GSL_EFAILED) {
           	fprintf(stderr, "%s: failed to read '%s': %s\n", progname, modelname, strerror(errno));
           	exit(EXIT_FAILURE);
		}
		fclose(mfile);

		ggamlist[cnt++] = wbl;
		//gsl_vector_fprintf(stderr, wbl, "%0.5f");
	}
	fclose(listfile);

    if (!init_diststore(num, (mode == DISTMATRIX) ? MATRIX : BOTTOMN)) {
        fprintf(stderr, "%s: failed to initialize distance store, exit.\n", progname);
        exit(EXIT_FAILURE);
    }

    metric_params_t metric_params;
    metric_params.ggamlist = ggamlist;
    metric_params.dim = dim;
    
    if (!benchmark) {
        if (!start_threads(num_threads, num, start_image, process_images, distance_thread, &metric_params)) {
            fprintf(stderr, "%s: failed to start thread(s), exit.\n", progname);
            exit(EXIT_FAILURE);
        }

        if (!write_diststore(dist_out_fname)) {
            fprintf(stderr, "%s: failed to write distance store, exit.\n", progname);
            exit(EXIT_FAILURE);
        }
    }
    else {
        if (!start_benchmark(num_threads, num, mode, distance_thread, &metric_params, 100)) {
            fprintf(stderr, "%s: failed to run benchmark, exit.\n", progname);
            exit(EXIT_FAILURE);
        }
    }
	    
    free_diststore();
	
	// free memory
    for (unsigned int i = 0; i < cnt; i++) {
		gsl_vector_free(ggamlist[i]);
    }
	free(ggamlist);
    return EXIT_SUCCESS;
}

static void distance(gsl_vector **ggamlist, unsigned int nimages, unsigned int dim, unsigned int start_image, unsigned int process_images) {
    for (unsigned int q = start_image; q < start_image+process_images; q++) {
		if (verbose)
			fprintf(stderr, "%s: processing query %d\n", progname, q);
		int queryisnull = gsl_vector_isnull(ggamlist[q]);
		if (queryisnull) { // null vector
			for (unsigned int i = 0; i < nimages; i++) {
				if (q == i) {
					store_dist(q,i,0.0);
					continue;
				}
				store_dist(q, i, DBL_MAX);
			}
			continue;
		}
		for (unsigned int i = 0; i < nimages; i++) {
			if (i == q) {
				store_dist(q,i,0.0);
				continue;
			}
			int candidateisnull = gsl_vector_isnull(ggamlist[i]);
			if (candidateisnull) { // null vector
				store_dist(q, i, DBL_MAX);
				continue;
			}
	    	double dist = probdist_fast(ggamlist, q, i, dim/3);
			store_dist(q, i, dist);
		}
	}
}

static double probdist_fast(gsl_vector **ggamlist, int q, int k, unsigned int nb) {
    double dist = 0.0; 
    double t;
	double *fv1 = ggamlist[q]->data;
	double *fv2 = ggamlist[k]->data;

    for (unsigned int i = 0; i < nb; i++) {
        const double alpha1 = fv1[3*i]; // alpha
        const double beta1 = fv1[3*i+1]; // beta
		const double lambda1 = fv1[3*i+2]; // lambda
		
        const double alpha2 = fv2[3*i];
        const double beta2 = fv2[3*i+1];   
		const double lambda2 = fv2[3*i+2];

		double t1 = log(pow(alpha1,beta1*lambda1) * pow(alpha2,beta2*lambda2)/(pow(alpha1,beta2*lambda2)*pow(alpha2,beta1*lambda1)));
		double t2 = (beta1*lambda1-beta2*lambda2) * (gsl_sf_psi(lambda1)/beta1 - gsl_sf_psi(lambda2)/beta2);
		double t3 = pow(alpha1/alpha2,beta2) * tgamma(lambda1+beta2/beta1)/tgamma(lambda1) +
					pow(alpha2/alpha1,beta1) * tgamma(lambda2 + beta1/beta2)/tgamma(lambda2) - lambda1 -lambda2;
		double t  = t1 + t2 + t3;
		/*fprintf(stderr, "(%0.5f %0.5f %0.5f) vs. (%0.5f %0.5f %0.5f): %0.5f\n",
			alpha1,beta1,lambda1, alpha2,beta2,lambda2, t);
		getchar();*/


   		dist += (t > 0.0) ? t : 0.0;
    }
    
    return dist * 0.5;
}

static void *distance_thread(void *thread_params) {
    if (!thread_params) 
        return 0;
        
    thread_params_t *p = (thread_params_t *) thread_params;
    metric_params_t *m = (metric_params_t *) p->metric_params;
    
    if (!m)
        return 0;
       
    if (verbose)
        fprintf(stderr, "%s: starting thread %d, processing images %d to %d (%d images)\n", progname, p->thread_num, p->start_image, p->start_image+p->process_images-1, p->process_images);

    distance(m->ggamlist, p->num_images, m->dim, p->start_image, p->process_images);
    return 0;
}
