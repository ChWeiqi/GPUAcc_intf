# compile src/demo.cpp and gpuacc.cu
# and link them to a single executable
# demo

# compiler
CC = g++

# compiler flags
CFLAGS = -std=c++11 -O3

# cuda compiler
NVCC = nvcc

# cuda compiler flags
NVCCFLAGS = -O3

# linker flags
LDFLAGS = -lcuda -lcudart

# src folder
VPATH = src

# include folder
INCLUDE = -Iinclude

# source files
SRC = ${VPATH}/demo.cc ${VPATH}/gpuacc.cu

# object files
OBJ = $(SRC:.cc=.o)
OBJ := $(OBJ:.cu=.o)

# executable
EXEC = demo

# default target
all: $(EXEC)

# compile c++ source files
%.o: %.cc
	$(CC) $(CFLAGS) ${INCLUDE} -c $< -o $@

# compile cuda source files
%.o: %.cu
	$(NVCC) $(NVCCFLAGS) ${INCLUDE} -c $< -o $@

# link object files to executable
$(EXEC): $(OBJ)
	$(CC) $(OBJ) -o $(EXEC) $(LDFLAGS)

# clean up
clean:
	rm -f $(OBJ) $(EXEC)

.PHONY: all clean
