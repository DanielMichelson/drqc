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
# dr_qc/src Makefile
# @file
# @author Daniel Michelson, Environment and Climate Change Canada
# @date 2019-04-15
###########################################################################
-include $(RAVEROOT)/rave/mkf/def.mk

DR_QCINC= -I. $(NUMPY_INCLUDE_DIR) $(INCLUDE_PYTHON) \
		-I$(HLHDF_INCLUDE_DIR) $(ZLIB_INCDIR) $(HDF5_INCDIR) \
		$(PROJ_INCLUDE_DIR) $(RAVE_INCLUDE_FLAG)

LDFLAGS+= -L. -L$(HLHDF_LIB_DIR) $(ZLIB_LIBDIR) $(HDF5_LIBDIR) $(PROJ_LIB_DIR) \
		$(RAVE_LIB_FLAG)

ifeq ($(EXPAT_SUPPRESSED), no)
DR_QCINC+= $(EXPAT_INCLUDE_DIR)
LDFLAGS+= $(EXPAT_LIB_DIR)
endif

ifeq ($(BUFR_SUPPRESSED), no)
DR_QCINC+= $(BUFR_INCLUDE_DIR)
LDFLAGS+= $(BUFR_LIB_DIR)
endif

CFLAGS=	$(OPTS) $(CCSHARED) $(DEFS) $(CREATE_ITRUNC) $(DR_QCINC)

# --------------------------------------------------------------------
# Fixed definitions

DR_QCSOURCES= dr_qc.c
INSTALL_HEADERS= dr_qc.h
DR_QCOBJS= $(DR_QCSOURCES:.c=.o)
LIBDR_QC= libdr_qc.so
DR_QCMAIN= 
DR_QCBIN= dr_qc
DR_QCBINDEB= dr_qc_deb
DR_QCLIBS= -ldr_qc $(RAVE_MODULE_LIBRARIES)

MAKEDEPEND=gcc -MM $(CFLAGS) -o $(DF).d $<
DEPDIR=.dep
DF=$(DEPDIR)/$(*F)
# --------------------------------------------------------------------
# Rules

# Contains dependency generation as well, so if you are not using
# gcc, comment out everything until the $(CC) statement.
%.o : %.c
	@$(MAKEDEPEND); \
	cp $(DF).d $(DF).P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $(DF).d >> $(DF).P; \
	\rm -f $(DF).d
	$(CC) -c $(CFLAGS) $<

# Ensures that the .dep directory exists
.PHONY=$(DEPDIR)
$(DEPDIR):
	+@[ -d $@ ] || mkdir -p $@

.PHONY=all
all:		$(LIBDR_QC) #bin

$(LIBDR_QC): $(DEPDIR) $(DR_QCOBJS) 
	$(LDSHARED) -o $@ $(DR_QCOBJS)

.PHONY=bin
bin: 
	$(CC) $(DR_QCINC) $(LDFLAGS) -o $(DR_QCBIN) $(DR_QCOBJS) $(DR_QCLIBS)

.PHONY=bin-debug
bin-debug:		$(DR_QCBINDEB)

$(DR_QCBINDEB): $(DR_QCSOURCES)
	$(CC) $(CFLAGS) -c dr_qc.c -o dr_qc.o
	$(CC) $(CFLAGS) $(DR_QCINC) $(LDFLAGS) -o $(DR_QCBINDEB) $(DR_QCOBJS) $(DR_QCLIBS)

.PHONY=install
install:
	@"$(HLHDF_INSTALL_BIN)" -f -o -C $(LIBDR_QC) "$(prefix)/lib/$(LIBDR_QC)"
	@for i in $(INSTALL_HEADERS) ; \
	do \
		"$(HLHDF_INSTALL_BIN)" -f -o -m644 -C $$i "$(prefix)/include/$$i"; \
	done
#	"$(HLHDF_INSTALL_BIN)" -f -o -C $(DR_QCBIN) "$(prefix)/bin/$(DR_QCBIN)";

.PHONY=clean
clean:
		@\rm -f *.o core *~ $(LIBDR_QC)
#		@\rm -fr $(DEPDIR)

.PHONY=distclean		 
distclean:	clean
		@\rm -f *.so

# NOTE! This ensures that the dependencies are setup at the right time so this should not be moved
-include $(DR_QCSOURCES:%.c=$(DEPDIR)/%.P)
