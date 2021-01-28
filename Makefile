#
# Makefile for teensy-duino
#
# Default MCU is for teensyLC
#

MCU = MKL26Z64
CPUARCH = cortex-m0plus

LIBRARYPATH = $(PWD)
MCU_LD = $(LIBRARYPATH)/mkl26z64.ld
LIBS = -L$(LIBRARYPATH) -lteensy

CDEFINES = -DF_CPU=48000000 -DUSB_SERIAL

# options needed by many Arduino libraries to configure for Teensy 3.x
CDEFINES += -D__$(MCU)__ -DARDUINO=10805 -DTEENSYDUINO=144

CPPFLAGS = -Wall -g -Os -mcpu=$(CPUARCH) -mthumb -MMD $(CDEFINES) -I$(LIBRARYPATH)/include
CXXFLAGS = -std=gnu++14 -felide-constructors -fno-exceptions -fno-rtti
CFLAGS =
LDFLAGS = -Os -Wl,--gc-sections,--defsym=__rtc_localtime=0 \
	--specs=nosys.specs -mcpu=$(CPUARCH) -mthumb -T$(MCU_LD)

# names for the compiler programs
CROSS_COMPILE=arm-none-eabi-
CC      = $(CROSS_COMPILE)gcc
CXX     = $(CROSS_COMPILE)g++
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE    = $(CROSS_COMPILE)size
AR      = $(CROSS_COMPILE)ar
RANLIB  = $(CROSS_COMPILE)ranlib

MKDIR   = mkdir -p

TEENSY_LIB = $(LIBRARYPATH)/libteensy.a
BOUNCE_LIB = $(LIBRARYPATH)/libBounce.a
AUDIO_LIB  = $(LIBRARYPATH)/libAudio.a
SPI_LIB    = $(LIBRARYPATH)/libSPI.a
WIRE_LIB   = $(LIBRARYPATH)/libWire.a
OBJ_DIR = obj

.PHONY: all load clean
all: $(TEENSY_LIB) $(AUDIO_LIB) $(BOUNCE_LIB) $(SPI_LIB) $(WIRE_LIB)
	@echo built $^

clean:
	-rm -f $(OBJ_DIR)/*.[od] *.a

$(OBJ_DIR): ; $(MKDIR) $@

$(OBJ_DIR)/%.o : src/%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o : src/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o : Audio/%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o : Audio/%.cpp
	$(CXX) $(CPPFLAGS) -IWire $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o : Bounce/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o : SPI/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o : Wire/%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

LIB_C_FILES = analog.c mk20dx128.c nonstd.c pins_teensy.c
LIB_C_FILES += usb_desc.c usb_dev.c usb_mem.c usb_midi.c usb_seremu.c usb_serial.c
LIB_CPP_FILES = AudioStream.cpp DMAChannel.cpp EventResponder.cpp \
	HardwareSerial.cpp main.cpp serialEvent.cpp yield.cpp

AUDIO_LIB_C_FILES = data_ulaw.c
AUDIO_LIB_CPP_FILES = control_sgtl5000.cpp output_i2s.cpp mixer.cpp play_memory.cpp
AUDIO_OBJS := $(addprefix $(OBJ_DIR)/,$(AUDIO_LIB_CPP_FILES:.cpp=.o) $(AUDIO_LIB_C_FILES:.c=.o))

BOUNCE_LIB_CPP_FILES = Bounce.cpp
BOUNCE_OBJS := $(addprefix $(OBJ_DIR)/,$(BOUNCE_LIB_CPP_FILES:.cpp=.o))

SPI_LIB_CPP_FILES = SPI.cpp
SPI_OBJS := $(addprefix $(OBJ_DIR)/,$(SPI_LIB_CPP_FILES:.cpp=.o))

WIRE_LIB_CPP_FILES = Wire.cpp WireIMXRT.cpp WireKinetis.cpp
WIRE_OBJS := $(addprefix $(OBJ_DIR)/,$(WIRE_LIB_CPP_FILES:.cpp=.o))

MIDI_LIB_C_FILES = usb.c
MIDI_LIB_CPP_FILES = usb_api.cpp


LIB_OBJS := $(LIB_C_FILES:.c=.o) $(LIB_CPP_FILES:.cpp=.o)
LIB_OBJS := $(addprefix $(OBJ_DIR)/,$(LIB_OBJS))

-include $(LIB_OBJS:.o=.d)

$(TEENSY_LIB): $(OBJ_DIR) $(LIB_OBJS)
	$(AR) crvs $@ $(LIB_OBJS)

$(AUDIO_LIB): $(OBJ_DIR) $(AUDIO_OBJS)
	$(AR) crvs $@ $(AUDIO_OBJS)

$(BOUNCE_LIB): $(OBJ_DIR) $(BOUNCE_OBJS)
	$(AR) crvs $@ $(BOUNCE_OBJS)

$(SPI_LIB): $(OBJ_DIR) $(SPI_OBJS)
	$(AR) crvs $@ $(SPI_OBJS)

$(WIRE_LIB): $(OBJ_DIR) $(WIRE_OBJS)
	$(AR) crvs $@ $(WIRE_OBJS)
