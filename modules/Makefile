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
# dr_qc Makefile
# @file
# @author Daniel Michelson, Environment and Climate Change Canada
# @date 2019-04-11
###########################################################################
-include $(RAVEROOT)/rave/mkf/def.mk

CFLAGS= $(CCSHARED) $(OPTS) $(DEFS) $(RAVE_INCLUDE_FLAG) \
	$(RAVE_INCLUDE_FLAG)/python \
	-I. -I../src $(INCLUDE_PYTHON) \
	-I$(HLHDF_INCLUDE_DIR) $(NUMPY_INCLUDE_DIR) \
	$(ZLIB_INCDIR) $(HDF5_INCDIR) $(PROJ_INCLUDE_DIR)

# Linker flags
#
LDFLAGS= $(RAVE_LIB_FLAG) -L. -L../src \
	 -L$(HLHDF_LIB_DIR) $(ZLIB_LIBDIR) $(HDF5_LIBDIR) $(PROJ_LIB_DIR)

ifeq ($(EXPAT_SUPPRESSED), no)
CFLAGS+= $(EXPAT_INCLUDE_DIR) -DRAVE_XML_SUPPORTED  
LDFLAGS+= $(EXPAT_LIB_DIR) 
EXPAT_LIBRARY=-lradvol -lexpat
endif

ifeq ($(BUFR_SUPPRESSED), no)
CFLAGS+= $(BUFR_INCLUDE_DIR) -DRAVE_BUFR_SUPPORTED
LDFLAGS+= $(BUFR_LIB_DIR)
BUFR_LIBRARY=-lOperaBufr
endif

ifeq ($(GOT_PTHREAD_SUPPORT), yes)
CFLAGS+= -DPTHREAD_SUPPORTED
PTHREAD_LIBRARY=-lpthread
endif

LIBRARIES= -ldr_qc $(RAVE_MODULE_LIBRARIES)

# --------------------------------------------------------------------
# Fixed definitions

SOURCE= pydr_qc.c
OBJECT= $(SOURCE:.c=.o)
TARGET= _dr_qc.so

INSTALL_HEADERS= 

MAKECDEPEND=$(CC) -MM $(CFLAGS) -MT '$(@D)/$(@F)' -o $(DF).d $<

DEPDIR=.dep
DF=$(DEPDIR)/$(*F)

# Ensures that the .dep directory exists
.PHONY=$(DEPDIR)
$(DEPDIR):
	+@[ -d $@ ] || mkdir -p $@

# And the rest of the make file targets
#
.PHONY=all
all:		$(TARGET)

$(TARGET): $(DEPDIR) $(OBJECT)
	$(LDSHARED) -o $@ $(OBJECT) $(LDFLAGS) $(LIBRARIES)

.PHONY=install
install:
	@for i in $(TARGET) ; \
	do \
		"$(HLHDF_INSTALL_BIN)" -f -o -m755 -C $$i "$(prefix)/Lib/$$i"; \
	done
	@for i in $(INSTALL_HEADERS) ; \
	do \
		"$(HLHDF_INSTALL_BIN)" -f -o -m644 -C $$i "$(prefix)/include/python/$$i"; \
	done

.PHONY=clean
clean:
	@\rm -f *.o core *~
	@\rm -fr $(DEPDIR)

.PHONY=distclean		 
distclean:	clean
	@\rm -f $(TARGET)

# --------------------------------------------------------------------
# Rules

# Contains dependency generation as well, so if you are not using
# gcc, comment out everything until the $(CC) statement.
%.o : %.c
	@$(MAKECDEPEND); \
	cp $(DF).d $(DF).P; \
	sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
		-e '/^$$/ d' -e 's/$$/ :/' < $(DF).d >> $(DF).P; \
	\rm -f $(DF).d
	$(CC) -c $(CFLAGS) $< -o $@

# NOTE! This ensures that the dependencies are setup at the right time so this should not be moved
-include $(SOURCE:%.c=$(DEPDIR)/%.P)
