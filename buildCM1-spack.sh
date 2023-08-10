#!/usr/bin/env bash
echo "Building CM1-LOFS from spack libraries..."
echo "Loading module files"
spack load h5z-zfp%intel
cd src
export H5Z_MAIN=`spack find --format "{prefix}" h5z-zfp%intel`
export ZFP_MAIN=`spack find --format "{prefix}" zfp%intel`
export H5_MAIN=`spack find --format "{prefix}" hdf5%intel`
export FORTRAN_MODULES="${H5Z_MAIN}/include"
export LD_LIBRARY_PATH="${H5Z_MAIN}/lib:${ZFP_MAIN}/lib"

if spack find --format "{compiler}" zfp | grep -q intel; then
    echo "It appears ZFP was compiled with Intel. Using Intel Makefile..."
    export HDF5_FC=mpiifort
    PREFIX=$PREFIX make -f Makefile.spack.intel clean
    PREFIX=$PREFIX make -f Makefile.spack.intel newcomm
    PREFIX=$PREFIX make -f Makefile.spack.intel lofs
    PREFIX=$PREFIX make -j 8 -f Makefile.spack.intel all
else
    echo "ZFP wasn't compiled by intel, which is currently the only supported configuration. You may have to manually modify the Makefile to work."
fi
