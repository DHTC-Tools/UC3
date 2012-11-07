#!/bin/bash

# looks for R folder, if not found, attempts to compile it.
if [ ! -d "R-2.15.1" ]; then
	# Untar the source
	tar -xvzf R-2.15.1.tar.gz
	pushd R-2.15.1

	# Compile
	./configure --with-x=no && make 

	# Return to our previous directory and run script
	popd
fi

R-2.15.1/bin/R --no-save < $1
