#!/bin/sh

#include "config.h"
MAKEIN = ./make.in
include $(MAKEIN)

# --- Makefile for Quick Program ---
#				- v 2.00 2010/10/25 Yipu Miao
#				- v 1.18 2009/09/16 John Faver Exp $ 
#				- Makefile created by mkmf.pl $Id:
#	--------
#	 INDEX
#	--------
#	A. Compiler Setting			! Intel Fortran 9.0+ or GNU Fortran is recommended for single CPU Version
#								! mpif90 is recommended for MPI Multi-CPU Version
#	B. Make Object Files		! Source files --> Object files
#	C. Make Executed files		! Object files --> Executed files
#	D. Self-defined Option		! Make option

#************************************************************************
#                  A. Compiler Settings
# 
#   FC specifies f90 compiler
#   FFLAGS are compliation options
#   LFLAGS are linking flags
#
#************************************************************************

# See compiler information and flag in make.in

#----------------------
# exe file location
#----------------------
exefile = ../bin/quick

#----------------------
# library file location
#----------------------
libfolder = ../lib

#----------------------
# config file location
#----------------------
configfolder = ./config

#----------------------
# cuda files
#----------------------
cudafolder = ./cuda
cudaobj = gpu_write_info.o gpu_MP2.o gpu.o gpu_type.o gpu_get2e.o gpu_getxc.o

#----------------------
# blas lib
#----------------------
blasfolder = ./BLAS
#----------------------
# quick modules and object files
#----------------------
modfolder = ./modules

mpimod  = quick_mpi_module.f90
mpimod_o= quick_mpi_module.o

modfile0 = quick_constants_module.f90
modobj0  = quick_constants_module.o
modfile1 = quick_method_module.f90 quick_molspec_module.f90 quick_gaussian_class_module.f90 
modobj1  = quick_method_module.o quick_molspec_module.o quick_gaussian_class_module.o
modfile2 = quick_size_module.f90 quick_amber_interface_module.f90 quick_basis_module.f90 \
		quick_calculated_module.f90 quick_divcon_module.f90 \
		quick_ecp_module.f90 quick_electrondensity_module.f90 quick_files_module.f90 \
		quick_gridpoints_module.f90 \
		quick_mfcc_module.f90 quick_params_module.f90 quick_pb_module.f90 \
		quick_scratch_module.f90 quick_timer_module.f90 quick_all_module.f90
modobj2  = quick_size_module.o quick_amber_interface_module.o quick_basis_module.o \
		quick_calculated_module.o quick_divcon_module.o \
		quick_ecp_module.o quick_electrondensity_module.o quick_files_module.o \
		quick_gridpoints_module.o \
		quick_mfcc_module.o quick_params_module.o quick_pb_module.o \
		quick_scratch_module.o quick_timer_module.o quick_all_module.o
#.DEFAULT:
#	-touch $@

all: quick quick.cuda

#************************************************************************
# 
#                 B. Make Object Files
# 
#************************************************************************

#================= common subroutine library ============================
quick_subs:
	cp *.mod ./subs
#	cd ./subs && $(FC) $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c *.f90
	ar -r $(libfolder)/quicklib.a ./subs/*.o
	rm ./subs/*.mod

#================= quick module library =================================
quick_modules:
	cd $(modfolder) && make
	mv ${modfolder}/*.mod ${modfolder}/*.o ./
#=========== targets for cuda =========================================
quick_cuda:
	cd $(cudafolder) && $(CUDAC) $(CUDA_FLAGS) -c gpu.cu gpu_type.cu
	cd $(cudafolder) && $(CUDAC) $(CUDA_FLAGS) -c gpu_get2e.cu
#	cd $(cudafolder) && $(CUDAC) $(CUDA_FLAGS) -c gpu.cu gpu_type.cu gpu_get2e.cu gpu_getxc.cu gpu_MP2.cu
#	cd $(cudafolder) && $(CUDAC) $(CUDA_FLAGS) -c gpu.cu gpu_type.cu gpu_MP2.cu
	cd $(cudafolder) && $(FC) $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c *.f90
	cp $(cudafolder)/*.o ./

#=========== BLAS =====================================================
blas:
	cd $(blasfolder) && make
	cp $(blasfolder)/*.a $(libfolder)

#================= quick core subroutines ===============================
main.o: main.f90 quick_modules
	$(FPP) main.f90 > _main.f90
	$(FC) -o main.o $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c       _main.f90
#calMP2.o: calMP2.f90 quick_modules
#	$(FPP) calMP2.f90 > _calMP2.f90
#	$(FC) -o calMP2.o $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c       _calMP2.f90
#shell.o: shell.f90 quick_modules
#	$(FPP) shell.f90 > _shell.f90
#	$(FC) -o shell.o $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c       _shell.f90

#=========== targets for CUDBLAS =====================================
fortran_thunking.o:
	cd $(cudafolder)/CUBLAS && $(CPP) $(CPP_FLAG) -c  fortran_thunking.c
	cp $(cudafolder)/CUBLAS/fortran_thunking.o ./

#=========== targets for amber-quick interface ========================
# This is a fake amber-quick interface
fake_amber_interface.o: fake_amber_interface.f90
	$(FC) $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c       fake_amber_interface.f90

# This is for amber-quick interface
amber_interface.o: amber_interface.f90 quick_modules qmmm_module.mod
	$(FC) $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c       amber_interface.f90

									
OBJ =   main.o $(mpimod_o) ${modobj0} ${modobj1} ${modobj2} \
		initialize.o read_job_and_atom.o fmm.o \
		getMolSad.o getMol.o shell.o schwarz.o quick_one_electron_integral.o \
		getEnergy.o inidivcon.o ecp.o hfoperator.o nuclear.o \
		dft.o sedftoperator.o dipole.o \
		scf.o uscf.o finalize.o uhfoperator.o udftoperator.o usedftoperator.o \
		uelectdii.o mpi_setup.o quick_debug.o calMP2.o optimize.o \
		gradient.o hessian.o CPHF.o frequency.o MFCC.o basis.o 
cpconfig:
	cp $(configfolder)/config.h ./config.h
cpconfig.cuda:
	cp $(configfolder)/config.cuda.h ./config.h
cpconfig.cuda.SP:
	cp $(configfolder)/config.cuda.SP.h ./config.h
#************************************************************************
# 
#                 C. Make Executed Files
# 
#************************************************************************

quick: cpconfig quick_modules quick_subs $(OBJ) fake_amber_interface.o
	$(FC) -o ${exefile} $(OBJ) $(libfolder)/quicklib.a $(libfolder)/blas.a fake_amber_interface.o $(LDFLAGS)

quick.cuda: cpconfig.cuda quick_cuda quick_modules quick_subs $(OBJ) fake_amber_interface.o fortran_thunking.o
	$(CXX) -o ${exefile}.cuda $(OBJ) $(cudaobj) $(libfolder)/quicklib.a $(libfolder)/blas.a fake_amber_interface.o fortran_thunking.o $(CFLAGS) 

quick.cuda.SP: cpconfig.cuda.SP quick_cuda quick_modules quick_subs $(OBJ) fake_amber_interface.o fortran_thunking.o
	$(CXX) -o ${exefile}.cuda.SP $(OBJ) $(cudaobj) $(libfolder)/quicklib.a fake_amber_interface.o fortran_thunking.o $(CFLAGS) 

quick_lib:$(OBJ) ambermod amber_interface.o

ambermod:
	cd ../../../AmberTools/src/sqm && $(MAKE) qmmm_module.o
	cp ../../../AmberTools/src/sqm/qmmm_module.mod .
	cp ../../../AmberTools/src/sqm/qmmm_vsolv_module.mod .
	cp ../../../AmberTools/src/sqm/qmmm_struct_module.mod .
	cp ../../../AmberTools/src/sqm/qmmm_nml_module.mod .
	cp ../../../AmberTools/src/sqm/qmmm_module.o .

		
#************************************************************************
# 
#                 D. Self-defined Option
# 
#************************************************************************

# - 1. Clean object files
clean: neat
	-rm -f _*.f90 .cppdefs *.mod *.o subs/*.o quick
	
neat:
	-rm -f $(TMPFILES)

# - 2. Make tags for source files
TAGS: $(SRC)
	etags $(SRC)
tags: $(SRC)
	ctags $(SRC)

#include depend
