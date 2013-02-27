#!/bin/bash
# Grabs everything from a canned CVMFS setup and tries to run root
WORKDIR="workspace/"
SLEEP=2

echo "Looking in current dir..."
ls 

if [ -d $WORKDIR ]; then
  echo "Old workdir will self destrict in $SLEP seconds..."
  sleep $SLEEP
  rm -rf $WORKDIR
fi
echo "making new $WORKDIR"
mkdir -pv $WORKDIR
echo "Copying inspector and makefile to $WORKDIR"
cp inspector.C Makefile $WORKDIR
echo "cd to $WORKDIR"
pushd $WORKDIR 

echo "Grabbing parrot from sthapa's webdir.."
wget http://uc3-data.uchicago.edu/~sthapa/parrot.tar.gz
echo "Extracting parrot into $WORKDIR"
tar -xzf parrot.tar.gz
echo "Done" 

echo "Exporting canned CVMFS environment variables..."
export PARROT_CVMFS_REPO='atlas.cern.ch:url=http://cvmfs.racf.bnl.gov:8000/opt/atlas,pubkey=cern.ch.pub,quota_limit=1000 atlas-condb.cern.ch:url=http://cvmfs.racf.bnl.gov:8000/opt/atlas-condb,pubkey=cern.ch.pub,quota_limit=1000'
export HTTP_PROXY="uc3-data.uchicago.edu:3128;http://uct2-grid1.uchicago.edu:3128;DIRECT"
export PARROT_HELPER="parrot/lib/libparrot_helper.so"
export MANPATH=:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/root/5.34.04-x86_64-slc5-gcc4.3/man:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/edg/share/man:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/share/man:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/yaim/man:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/globus/man:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/man:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/share/man::::::
export AtlasSetupSite=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/AtlasSetup/.config/.asetup.site
export GLITE_SD_PLUGIN=file,bdii
export ALRB_cvmfs_CDB=/cvmfs/atlas.cern.ch/repo/conditions
export PAC_ANCHOR=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/Gcc/gcc435_x86_64_slc5
export ATLAS_LOCAL_ROOT_PACOPT=
export ATLAS_LOCAL_CERNROOT_VERSION=5.34.04-x86_64-slc5-gcc4.3
export GRID_ENV_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/etc/profile.d
export GLOBUS_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/globus
export ALRB_SHELL=bash
export GCC_DIR=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/Gcc/gcc435_x86_64_slc5/gcc-alt-435/x86_64-slc5-gcc43-opt
export PERL5LIB=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/lib64/perl:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/gpt/lib/perl:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/usr/lib/perl5/vendor_perl/5.8.8
export GT_PROXY_MODE=old
export ATLAS_LOCAL_GCC_VERSION=gcc435_x86_64_slc5
export ATLAS_LOCAL_SETUP_OPTIONS=
export GLITE_WMS_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite
export X509_CERT_DIR=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/etc/grid-security/certificates
export ALRB_useGridSW=gLite
export LD_LIBRARY_PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/xrootd/3.2.4-x86_64-slc5/v3.2.4/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/root/5.34.04-x86_64-slc5-gcc4.3/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/Gcc/gcc435_x86_64_slc5/gcc-alt-435/x86_64-slc5-gcc43-opt/lib64:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/Gcc/gcc435_x86_64_slc5/gcc-alt-435/x86_64-slc5-gcc43-opt/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/../external/usr/lib64:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/python/2.6.5-x86_64-slc5-gcc43/sw/lcg/external/Python/2.6.5/x86_64-slc5-gcc43-opt/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/d-cache/dcap/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/d-cache/dcap/lib64:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/lib64:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/globus/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/lib64:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/usr/lib64:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/usr/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/classads/lib64/
export GPT_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/gpt
export LCG_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
export ATLAS_LOCAL_GCC_PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/Gcc/gcc435_x86_64_slc5
export ATLAS_LOCAL_GLITE_VERSION=3.2.11-1-patch1.sl5
export DQ2_LOCAL_SITE_ID=ROAMING
export ALRB_cvmfs_Athena=/cvmfs/atlas.cern.ch/repo/sw/software
export AtlasSetup=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/AtlasSetup/V00-03-40/AtlasSetup
export ATLAS_LOCAL_DQ2CLIENT_VERSION=2.3.0
export ATLAS_LOCAL_ASETUP_PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/AtlasSetup/V00-03-40
export ALRB_cvmfs_ALRB_default=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
export PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/xrootd/3.2.4-x86_64-slc5/v3.2.4/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/root/5.34.04-x86_64-slc5-gcc4.3/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/Gcc/gcc435_x86_64_slc5/gcc-alt-435/x86_64-slc5-gcc43-opt/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/DQ2Client/2.3.0/DQ2Clients/opt/dq2/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/python/2.6.5-x86_64-slc5-gcc43/sw/lcg/external/Python/2.6.5/x86_64-slc5-gcc43-opt/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/d-cache/srm/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/d-cache/dcap/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/edg/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/globus/bin:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/bin:/usr/local/bin:/bin:/usr/bin:/opt/dell/srvadmin/bin:/usr/local/swift-0.94/bin:/home/lincolnb/bin
export EDG_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/edg
export ALRB_cvmfs_nightly_repo=/cvmfs/atlas-nightlies.cern.ch/repo
export ATLAS_LOCAL_ASETUP_VERSION=V00-03-40
export X509_VOMS_DIR=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/etc/grid-security/vomsdir/
export ATLAS_LOCAL_PYTHON_VERSION=2.6.5-x86_64-slc5-gcc43
export DQ2_ENDUSER_SETUP=True
export MYPROXY_SERVER=myproxy.cern.ch
export PERLLIB=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/gpt/lib/perl
export ATLAS_POOLCOND_PATH=/cvmfs/atlas.cern.ch/repo/conditions
export ALRB_localConfigDir=/home/lincolnb/localConfig
export ROOTSYS=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/root/5.34.04-x86_64-slc5-gcc4.3
export GLITE_SD_SERVICES_XML=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/etc/services.xml
export GLITE_LOCATION_VAR=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/var
export ATLAS_LOCAL_DQ2CLIENT_PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/DQ2Client/2.3.0
export GLOBUS_TCP_PORT_RANGE=20000,25000
export X509_USER_PROXY=/tmp/x509up_u414703179
export DYLD_LIBRARY_PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/xrootd/3.2.4-x86_64-slc5/v3.2.4/lib
export LCG_GFAL_INFOSYS=lcg-bdii.cern.ch:2170
export PYTHONPATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/root/5.34.04-x86_64-slc5-gcc4.3/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/DQ2Client/2.3.0/DQ2Clients/opt/dq2/lib:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/DQ2Client/2.3.0/DQ2Clients/opt/dq2/lib/dq2/clientapi/cli/plugins:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/lib64/python2.6/site-packages:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/lib64/python2.4/site-packages:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite/lib64/python:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/lib64/python2.4/site-packages:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/lcg/lib64/python:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/opt/fpconst/lib/python2.4/site-packages:/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/external/opt/ZSI/lib/python2.4/site-packages
export ATLAS_LOCAL_ROOT_ARCH=x86_64
export XRDSYS=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/xrootd/3.2.4-x86_64-slc5/v3.2.4
export ALRB_cvmfs_ALRB=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
export GLITE_LOCATION=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/glite
export ATLAS_LOCAL_ROOT=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64
export DQ2_HOME=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/DQ2Client/2.3.0/DQ2Clients/opt/dq2
export SRM_PATH=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase/x86_64/gLite/3.2.11-1-patch1.sl5/d-cache/srm
export ALRB_cvmfs_repo=/cvmfs/atlas.cern.ch/repo

echo "Grabbing CVMFS pubkey"
wget http://uc3-data.uchicago.edu/rwg-web/cern.ch.pub

echo "Firin' up parrot!"
echo "Making inspector, staging to disk, and running inspector..."
# I wanted to minimize the number of files that get transfered with the condor
# job, so I just start bash and execute my code in there. Obviously not
# scalable.
./parrot/bin/parrot_run -r atlas.cern.ch:url=http://cvmfs.racf.bnl.gov:8000/opt/atlas,pubkey=cern.ch.pub,quota_limit=1000 /bin/bash -c 'make; ./inspector root://xrddc.mwt2.org:1096//atlas/dq2/user/ilijav/HCtest/user.ilijav.HCtest.1/group.test.hc.NTUP_SMWZ.root' 
