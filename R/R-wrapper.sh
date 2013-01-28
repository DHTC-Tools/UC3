#!/bin/bash
# Simple R wrapper to bring in R from the UC3 CVMFS environment

# looks for R folder, if not found, attempts to compile it.
#if [ ! -d "R-2.15.1" ]; then
#	# Untar the source
#	tar -xvzf R-2.15.1.tar.gz
#	pushd R-2.15.1
#
#	# Compile
#	./configure --with-x=no && make 
#
#	# Return to our previous directory and run script
#	popd
#fi

# Access R from the UC3 environment
export PATH=$PATH:/cvmfs/uc3.uchicago.edu/sw/bin
export LD_LIBRARY_PATH=/cvmfs/uc3.uchicago.edu/sw/lib

INPUT=$1

which R > /dev/null 2>&1
if [ $? -ne 0 ] 
  then #not installed
    echo "Can't find R. Doing nothing"
  else
    echo "Found R!"
    R --no-save < $INPUT 
fi
