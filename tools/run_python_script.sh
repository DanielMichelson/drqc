#!/bin/sh
############################################################
# Description: Script that executes a Python script with proper
# settings in this build.
#
# Author(s):   Anders Henja, Daniel Michelson
#
# Copyright:   Swedish Meteorological and Hydrological Institute, 2009
#              The Crown (i.e. Her Majesty the Queen in Right of Canada), 2019
#
# History:  2009-10-22 Created by Anders Henja
#	    2016-06-10 Modified by Daniel Michelson for rave_ec
############################################################
SCRFILE=`python -c "import os;print os.path.abspath(\"$0\")"`
SCRIPTPATH=`dirname "$SCRFILE"`

DEF_MK_FILE="${RAVEROOT}/rave/mkf/def.mk"

if [ ! -f "${DEF_MK_FILE}" ]; then
  echo "configure has not been run"
  exit 255
fi

RESULT=0

# RUN THE PYTHON TESTS
HLHDF_MKFFILE=`fgrep HLHDF_HLDEF_MK_FILE "${DEF_MK_FILE}" | sed -e"s/\(HLHDF_HLDEF_MK_FILE=[ \t]*\)//"`

# Get HDF5s ld path from hlhdfs mkf file
HDF5_LDPATH=`fgrep HDF5_LIBDIR "${HLHDF_MKFFILE}" | sed -e"s/\(HDF5_LIBDIR=[ \t]*-L\)//"`

# Get HLHDFs libpath from raves mkf file
HLHDF_LDPATH=`fgrep HLHDF_LIB_DIR "${DEF_MK_FILE}" | sed -e"s/\(HLHDF_LIB_DIR=[ \t]*\)//"`

BNAME=`python -c 'from distutils import util; import sys; print "lib.%s-%s" % (util.get_platform(), sys.version[0:3])'`

RBPATH="${SCRIPTPATH}/../Lib:${SCRIPTPATH}/../modules"
EC_LDPATH="${SCRIPTPATH}/../src"
XRUNNERPATH="${SCRIPTPATH}/../test/lib"

# Special hack for Mac OS X.
ISMACOS=no
case `uname -s` in
 Darwin*)
   ISMACOS=yes
   ;;
 darwin*)
   ISMACOS=yes
   ;;
esac

if [ "x$ISMACOS" = "xyes" ]; then
  if [ "$DYLD_LIBRARY_PATH" != "" ]; then
    export DYLD_LIBRARY_PATH="${EC_LDPATH}:${HLHDF_LDPATH}:${HDF5_LDPATH}:${LD_LIBRARY_PATH}"
  else
    export DYLD_LIBRARY_PATH="${EC_LDPATH}:${HLHDF_LDPATH}:${HDF5_LDPATH}"
  fi
else
  if [ "$LD_LIBRARY_PATH" != "" ]; then
    export LD_LIBRARY_PATH="${EC_LDPATH}:${HLHDF_LDPATH}:${HDF5_LDPATH}:${LD_LIBRARY_PATH}"
  else
    export LD_LIBRARY_PATH="${EC_LDPATH}:${HLHDF_LDPATH}:${HDF5_LDPATH}"
  fi
fi

export ECPATH="${HLHDF_LDPATH}:${RBPATH}:${XRUNNERPATH}"

if test "${PYTHONPATH}" != ""; then
  export PYTHONPATH="${ECPATH}:${PYTHONPATH}"
else
  export PYTHONPATH="${ECPATH}"
fi

# Syntax: run_python_script <pyscript> [<dir> - if script should be executed in a particular directory]

NARGS=$#
PYSCRIPT=
DIRNAME=
if [ $NARGS -eq 1 ]; then
  PYSCRIPT=`python -c "import os;print os.path.abspath(\"$1\")"`
elif [ $NARGS -eq 2 ]; then
  PYSCRIPT=`python -c "import os;print os.path.abspath(\"$1\")"`
  DIRNAME="$2"
elif [ $NARGS -eq 0 ]; then
  # Do nothing
  PYSCRIPT=
  DIRNAME=
else
  echo "Unknown command"
  exit 255
fi

if [ "$DIRNAME" != "" ]; then
  cd "$DIRNAME"
fi

if [ "$PYSCRIPT" != "" ]; then
  python "$PYSCRIPT"
else
  python
fi

VAL=$?
if [ $VAL != 0 ]; then
  RESULT=$VAL
fi

# EXIT WITH A STATUS CODE, 0 == OK, ANY OTHER VALUE = FAIL
exit $RESULT

