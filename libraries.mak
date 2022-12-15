#
# Makefile snippet to build libraries for teensy-duino in your project space.
#

LIB_C_FILES = analog.c mk20dx128.c nonstd.c pins_teensy.c serial1.c
LIB_C_FILES += usb_desc.c usb_dev.c usb_inst.c usb_mem.c usb_midi.c usb_seremu.c usb_serial.c
LIB_CPP_FILES = AudioStream.cpp DMAChannel.cpp EventResponder.cpp \
	HardwareSerial.cpp HardwareSerial1.cpp IntervalTimer.cpp Print.cpp \
	WMath.cpp WString.cpp avr_emulation.cpp i2c_t3.cpp main.cpp \
	new.cpp serialEvent.cpp usb_audio.cpp yield.cpp

LIBOBJDIR ?= ${OBJDIR}

LIB_OBJS := $(LIB_C_FILES:.c=.o) $(LIB_CPP_FILES:.cpp=.o)
LIB_OBJS := $(addprefix $(LIBOBJDIR)/,$(LIB_OBJS))

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/src/%.c | ${LIBOBJDIR}
	@echo Compiling $@ from $<
	@$(COMPILE.c) $(OUTPUT_OPTION) $<

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/src/%.cpp | ${LIBOBJDIR}
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(TEENSY_LIB): $(LIB_OBJS) | ${LIBDIR}
	@echo Collecting library $@
	@$(AR) $(ARFLAGS) $@ $(LIB_OBJS)

AUDIO_LIB_CPP_FILES = control_sgtl5000.cpp effect_multiply.cpp filter_biquad.cpp \
	mixer.cpp output_i2s.cpp output_pt8211.cpp play_memory.cpp synth_dc.cpp \
	synth_simple_drum.cpp synth_sine.cpp synth_whitenoise.cpp
AUDIO_LIB_C_FILES = data_ulaw.c data_waveforms.c
AUDIO_LIB_S_FILES = memcpy_audio.S
AUDIO_OBJS := $(addprefix $(LIBOBJDIR)/,$(AUDIO_LIB_C_FILES:.c=.o) \
	$(AUDIO_LIB_CPP_FILES:.cpp=.o) $(AUDIO_LIB_S_FILES:.S=.o))

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Audio/%.c
	@echo Compiling $@ from $<
	@$(COMPILE.c) $(OUTPUT_OPTION) $<

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Audio/%.S
	@echo Compiling $@ from $<
	@$(COMPILE.S) $(OUTPUT_OPTION) $<

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Audio/%.cpp
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(AUDIO_LIB): $(AUDIO_OBJS) | ${LIBDIR}
	@echo Collecting library $@
	@$(AR) $(ARFLAGS) $@ $(AUDIO_OBJS)

BOUNCE_LIB_CPP_FILES = Bounce.cpp
BOUNCE_LIB_C_FILES = 
BOUNCE_OBJS := $(addprefix $(LIBOBJDIR)/,$(BOUNCE_LIB_C_FILES:.c=.o) \
	$(BOUNCE_LIB_CPP_FILES:.cpp=.o))

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Bounce/%.c
	@echo Compiling $@ from $<
	@$(COMPILE.c) $(OUTPUT_OPTION) $<

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Bounce/%.cpp
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(BOUNCE_LIB): $(BOUNCE_OBJS) | ${LIBDIR}
	@echo Collecting library $@
	@$(AR) $(ARFLAGS) $@ $(BOUNCE_OBJS)

WIRE_LIB_CPP_FILES = Wire.cpp WireKinetis.cpp
WIRE_LIB_C_FILES = 
WIRE_OBJS := $(addprefix $(LIBOBJDIR)/,$(WIRE_LIB_C_FILES:.c=.o) \
	$(WIRE_LIB_CPP_FILES:.cpp=.o))

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Wire/%.c
	@echo Compiling $@ from $<
	@$(COMPILE.c) $(OUTPUT_OPTION) $<

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/Wire/%.cpp
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(WIRE_LIB): $(WIRE_OBJS) | ${LIBDIR}
	@echo Collecting library $@
	@$(AR) $(ARFLAGS) $@ $(WIRE_OBJS)

SD_LIB_CPP_FILES = File.cpp SD.cpp Sd2Card.cpp SdFile.cpp SdVolume.cpp
SD_OBJS := $(addprefix $(LIBOBJDIR)/,$(SD_LIB_CPP_FILES:.cpp=.o))

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/SD/%.cpp
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/SD/utility/%.cpp
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) -I$(LIBRARYPATH)/SD/utility $(OUTPUT_OPTION) $<

$(SD_LIB): $(SD_OBJS) | ${LIBDIR}
	@echo Collecting library $@
	@$(AR) $(ARFLAGS) $@ $(SD_OBJS)

SPI_LIB_CPP_FILES = SPI.cpp
SPI_OBJS := $(addprefix $(LIBOBJDIR)/,$(SPI_LIB_CPP_FILES:.cpp=.o))

$(LIBOBJDIR)/%.o : $(LIBRARYPATH)/SPI/%.cpp
	@echo Compiling $@ from $<
	@$(COMPILE.cpp) $(OUTPUT_OPTION) $<

$(SPI_LIB): $(SPI_OBJS) | ${LIBDIR}
	@echo Collecting library $@
	@$(AR) $(ARFLAGS) $@ $(SPI_OBJS)
