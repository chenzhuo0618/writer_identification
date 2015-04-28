#CC=g++-4.4
CFLAGS=-finline-functions  -I /usr/local/include/opencv -msse -I tclap -O3 
LDFLAGS=-lhighgui -lcxcore -lcv
SOURCES=HSC.cpp example.cpp HSCmatrices.cpp maths.cpp misc.cpp


OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=example

all: $(LIBS) $(SOURCES)  $(EXECUTABLE) 

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o $@ 

.cpp.o:
	$(CC) $(CFLAGS) $< -c

clean:
	rm -f *.o $(EXECUTABLE)
