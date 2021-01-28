
ifdef TEENSY
ifeq (${TEENSY},TEENSY41)
MCU = IMXRT1062
CPUARCH = cortex-m7
endif # 41
ifeq (${TEENSY},TEENSY40)
MCU = IMXRT1062
CPUARCH = cortex-m7
endif # 40
ifeq (${TEENSY},TEENSY36)
MCU = MK66FX1M0
CPUARCH = cortex-m4
endif # 36
ifeq (${TEENSY},TEENSY35)
MCU = MK64FX512
CPUARCH = cortex-m4
endif # 35
ifeq (${TEENSY},TEENSY32)
MCU = MK20DX256
CPUARCH = cortex-m4
endif # 32
ifeq ($(TEENSY),TEENSYLC)
MCU = MKL26Z64
CPUARCH = cortex-m0plus
endif # LC
else
$(error you have to define TEENSY)
endif # def TEENSY

ifndef MCU
$(error you have to define TEENSY as one of TEENSYLC or TEEENSY32)
endif

MCU_LD = $(LIBRARYPATH)/$(shell echo ${MCU} | tr A-Z a-z).ld
TEENSYDUINO = 153

# names for the compiler programs
CROSS_COMPILE=arm-none-eabi-
CC      = $(CROSS_COMPILE)gcc
CXX     = $(CROSS_COMPILE)g++
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE    = $(CROSS_COMPILE)size
AR      = $(CROSS_COMPILE)ar
RANLIB  = $(CROSS_COMPILE)ranlib

MKDIR   = mkdir -p
