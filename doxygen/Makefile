###########################################################################
# Copyright (C) 2019 The Crown (i.e. Her Majesty the Queen in Right of Canada)
#
# This file is an add-on to RAVE.
#
# RAVE is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# RAVE is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with RAVE.  If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------
# 
# dr_qc Makefile for generating documentation
# @file
# @author Daniel Michelson, Environment and Climate Change Canada
# @date 2019-04-11
###########################################################################
all:

.PHONY=doc
doc:
	@doxygen dr_qc_doxygen.cfg

.PHONY=clean
clean:
	@\rm -f *.o
	@\rm -f *~

.PHONY=distclean
distclean:
	@\rm -f *.o
	@\rm -f *~ core
	@\rm -fr doxygen

distribution:

install:

