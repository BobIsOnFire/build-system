ifeq ($(SUBDIRS),)
SUBDIRS := $(patsubst $(ROOT)/%/,%,$(dir $(wildcard $(ROOT)/$(PRJ)/*/Makefile)))
endif

$(PRJ)_SUBDIRS := $(SUBDIRS)
SUBDIRS :=

$(foreach sub,$($(PRJ)_SUBDIRS),$(eval $(call collect-dependency,$(sub))))
