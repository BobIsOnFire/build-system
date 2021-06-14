CXX_BINARY := $(ROOT)/dist/lib$(NAME).so

CFLAGS += -fPIC
CXXFLAGS += -fPIC

LDFLAGS += --shared

include $(ROOT)/makefiles/etc/build-cxx.make
