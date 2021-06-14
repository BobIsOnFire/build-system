$(PRJ)_IS_CXX = YES

CC := gcc
CXX := g++

CXX_SOURCE_EXTENSIONS = .c .cpp

ifeq ($(SOURCES),)
SOURCES := $(foreach ext,$(CXX_SOURCE_EXTENSIONS),$(shell find $(ROOT)/$(PRJ)/src -name '*$(ext)'))
endif
OBJECTS := $(patsubst $(ROOT)/%,$(ROOT)/build/$(PRJ)/%.o,$(SOURCES))
DEPOBJS := $(patsubst $(ROOT)/%,$(ROOT)/build/$(PRJ)/%.o.d,$(SOURCES))

include $(wildcard $(DEPOBJS))

HEADER_FLAGS := $(sort $(foreach dep,$(DEPENDS),$(if $($(dep)_IS_CXX),$($(dep)_HEADER_FLAGS))) -I$(ROOT)/$(PRJ)/headers)

define collect-libs

ifeq ($$($(1)_DRIVER),dynamic-library)
DEPLIBS += $$($(1)_DEPLIBS) $$($(1)_CXX_BINARY)
LIB_FLAGS += -l$$($(1)_NAME) $$($(1)_LIB_FLAGS) 
else ifeq ($$($(1)_DRIVER),static-library)
DEPLIBS += $$($(1)_CXX_BINARY)
LIB_FLAGS += -l$$($(1)_NAME)
endif

endef

$(foreach dep,$(DEPENDS),$(eval $(call collect-libs,$(dep))))
LDFLAGS += -L$(ROOT)/dist

$(CXX_BINARY): $(DEPLIBS)

##### Exposing everything and cleaning general variables

$(PRJ)_SOURCES := $(SOURCES)
$(PRJ)_OBJECTS := $(OBJECTS)
$(PRJ)_DEPOBJS := $(DEPOBJS)
$(PRJ)_CFLAGS := $(CFLAGS) $(HEADER_FLAGS)
$(PRJ)_CXXFLAGS := $(CXXFLAGS) $(HEADER_FLAGS)
$(PRJ)_LDFLAGS := $(LDFLAGS)
$(PRJ)_HEADER_FLAGS := $(HEADER_FLAGS)
$(PRJ)_DEPLIBS := $(DEPLIBS)
$(PRJ)_LIB_FLAGS := $(LIB_FLAGS)
$(PRJ)_CXX_BINARY := $(CXX_BINARY)

SOURCES :=
OBJECTS :=
DEPOBJS :=
CFLAGS :=
HEADER_FLAGS :=
CXXFLAGS :=
LDFLAGS :=
DEPLIBS :=
LIB_FLAGS :=
CXX_BINARY :=

##### Compilation and linking commands

COMPILE.c = $(CC) $($(PRJ)_CFLAGS) -c 
DEPOBJ.c = $(CC) -MM -MP $($(PRJ)_HEADER_FLAGS)

COMPILE.cpp = $(CXX) $($(PRJ)_CXXFLAGS) -c
DEPOBJ.cpp = $(CXX) -MM -MP $($(PRJ)_HEADER_FLAGS)

LINK = $(CXX) $($(PRJ)_CXXFLAGS) $($(PRJ)_LDFLAGS)
POSTLINK = $($(PRJ)_LIB_FLAGS)

##### Targets

BUILD_TARGETS := $(BUILD_TARGETS) $($(PRJ)_CXX_BINARY)

define make-link-rule

$(1)_link := $$(LINK)
$(1)_postlink := $$(POSTLINK)
$(1): $(2)
	mkdir -p $$(@D)
	@echo '   link $$(@F)'
	$$($(1)_link) -o $$@ $$^ $$($(1)_postlink)

endef

define make-cxx-rule

__empty :=
__space := $$(__empty) $$(__empty)

__name := $$(patsubst $(ROOT)/%,%,$(1))
__ext := $$(lastword $$(subst .,$$(__space),$(1)))

$(1)_depobj := $$(DEPOBJ.$$(__ext))
$(1)_compile := $$(COMPILE.$$(__ext))

$(ROOT)/build/$(PRJ)/$$(__name).o: $(ROOT)/$$(__name) $(ROOT)/$(PRJ)/Makefile
	mkdir -p $$(@D)
	@echo 'compile $$(@F)'
	$$($(1)_depobj) $$< | \
		sed 's/^[^:]*://;s/\\$$$$//' | \
		while read f; do echo "$$@": "$$$$f"; echo "$$$$f": ; done >$$@.d
	$$($(1)_compile) -o $$@ $$<

endef

$(eval $(call make-link-rule,$($(PRJ)_CXX_BINARY),$($(PRJ)_OBJECTS)))
$(foreach src,$($(PRJ)_SOURCES),$(eval $(call make-cxx-rule,$(src))))

CLEAN_TARGETS := $(CLEAN_TARGETS) do-cxx-clean-$(PRJ)
.PHONY: do-cxx-clean-$(PRJ)

do-cxx-clean-$(PRJ):
	$(RM) $($(PRJ)_CXX_BINARY) $($(PRJ)_OBJECTS)
