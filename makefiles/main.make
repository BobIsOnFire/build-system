##### Custom user variables validation.

ifeq ($(wildcard $(ROOT)/makefiles/main.make),)
$(error $(NAME): Something is wrong with root definition. Please set it as `ROOT ?= ...` in the project Makefile)
endif

PRJ ?= $(patsubst $(abspath $(ROOT))/%,%,$(abspath $(CURDIR)))

ifneq ($(words $(NAME)),1)
$(error $(PRJ): Invalid NAME value: '$(NAME)'. Please set NAME variable in your project Makefile that consists of a single word)
endif

ifeq ($(wildcard $(ROOT)/makefiles/drivers/$(DRIVER).make),)
$(error $(PRJ): invalid DRIVER value: '$(DRIVER)'. This driver does not exist.)
endif

# We might have already completed this project
ifeq ($($(PRJ)_NAME),)

##### Main targets.

$(PRJ)_TOPLEVEL ?= YES

ifeq ($($(PRJ)_TOPLEVEL),YES)
all: do-all
clean: do-clean

.PHONY: all do-all clean do-clean
endif

##### Dependency collection.

$(PRJ)_NAME := $(NAME)
$(PRJ)_DRIVER := $(DRIVER)
$(PRJ)_DEPENDS := $(DEPENDS)

NAME :=
DRIVER :=
DEPENDS :=

define collect-dependency

prj_stack := $$(prj_stack) $$(PRJ)
PRJ := $(1)

$(1)_TOPLEVEL = NO
include $(ROOT)/$(1)/Makefile

PRJ := $$(lastword $$(prj_stack))
prj_stack := $$(filter-out $$(PRJ),$$(prj_stack))

endef

$(foreach dep,$($(PRJ)_DEPENDS),$(eval $(call collect-dependency,$(dep))))

NAME := $($(PRJ)_NAME)
DRIVER := $($(PRJ)_DRIVER)
DEPENDS := $($(PRJ)_DEPENDS)

##### Driver targets.

include $(ROOT)/makefiles/drivers/$($(PRJ)_DRIVER).make

##### Everything is set, add custom targets to the build process

ifeq ($($(PRJ)_TOPLEVEL),YES)
do-all: $(BUILD_TARGETS)
do-clean: $(CLEAN_TARGETS)
endif

endif # $($(PRJ)_NAME)
