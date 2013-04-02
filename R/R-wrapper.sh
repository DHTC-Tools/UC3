#!/bin/bash
# Simple R wrapper.

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
