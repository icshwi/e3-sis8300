#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
#
# Author  : joaopaulomartins
#           Jeong Han Lee
# email   : joaopaulomartins@esss.se
#           jeonghan.lee@gmail.com
# Date    : Saturday, September 15 14:28:16 CEST 2018
# version : 0.0.2
#


where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(where_am_I)/../configure/DECOUPLE_FLAGS

EXCLUDE_ARCHS += linux-ppc64e6500 


ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(LOKI_DEP_VERSION)),)
loki_VERSION=$(LOKI_DEP_VERSION)
endif

ifneq ($(strip $(NDS_DEP_VERSION)),)
nds_VERSION=$(NDS_DEP_VERSION)
endif


ifneq ($(strip $(SIS8300DRV_DEP_VERSION)),)
sis8300drv_VERSION=$(SIS8300DRV_DEP_VERSION)
endif



APP:=src/main/epics/sis8300App
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src


HEADERS += $(wildcard $(APPSRC)/*.h)

SOURCES += $(APPSRC)/sis8300Device.cpp
SOURCES += $(APPSRC)/sis8300RegisterChannelGroup.cpp
SOURCES += $(APPSRC)/sis8300RegisterChannel.cpp
SOURCES += $(APPSRC)/sis8300AIChannelGroup.cpp
SOURCES += $(APPSRC)/sis8300AIChannel.cpp
SOURCES += $(APPSRC)/sis8300AOChannelGroup.cpp
SOURCES += $(APPSRC)/sis8300AOChannel.cpp

USR_INCLUDES += -I/usr/include/libxml2
USR_LIBS += xml2



TEMPLATES += $(wildcard $(APPDB)/*.template)
TEMPLATES += $(APPDB)/sis8300.db
TEMPLATES += $(APPDB)/sis8300Register.db
TEMPLATES += $(APPDB)/sis8300noAO.db



#EPICS_BASE_HOST_BIN = $(EPICS_BASE)/bin/$(EPICS_HOST_ARCH)
#MSI = $(EPICS_BASE_HOST_BIN)/msi

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)



SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)

db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@


.PHONY: db $(SUBS) $(TMPS)


