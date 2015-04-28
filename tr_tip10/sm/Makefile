VPATH = cephes

COPT = -g -O2 -Wall -fomit-frame-pointer -ffast-math -msse3 -mfpmath=sse -I. -I/software/gsl/include -L/software/gsl/lib -I/opt/local/include -L/opt/local/lib
CXX = g++ $(COPT)
CC = gcc $(COPT)

LIBS = -L. -lstex -lgsl -lgslcblas -lpthread -lm

all: KL-Weibull KL-GGamma KL-Gamma KL-Rayleigh KL-GGD

clean:
	rm -f KL-Weibull KL-GGamma KL-Gamma KL-Rayleigh KL-GGD *.o libstex.a

libstex.a: common.o diststore.o
	$(AR) rcv $@ common.o diststore.o

KL-Weibull: KL-Weibull.cpp libstex.a
	$(CXX) -o $@ KL-Weibull.cpp $(LIBS)

KL-GGamma: KL-GGamma.cpp libstex.a
	$(CXX) -o $@ KL-GGamma.cpp $(LIBS)

KL-Gamma: KL-Gamma.cpp libstex.a
	$(CXX) -o $@ KL-Gamma.cpp $(LIBS)

KL-Rayleigh: KL-Rayleigh.cpp libstex.a
	$(CXX) -o $@ KL-Rayleigh.cpp $(LIBS)

KL-GGD: KL-GGD.cpp libstex.a
	$(CXX) -o $@ KL-GGD.cpp $(LIBS)

