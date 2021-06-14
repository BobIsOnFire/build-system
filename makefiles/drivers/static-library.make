CXX_BINARY := $(ROOT)/dist/lib$(NAME).a

CFLAGS += -fPIC
CXXFLAGS += -fPIC

include $(ROOT)/makefiles/etc/build-cxx.make
