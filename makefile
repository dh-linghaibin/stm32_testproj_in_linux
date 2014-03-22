#TOOL CHAIN
CROSS_COMPILE = arm-none-eabi-
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
CC = $(CROSS_COMPILE)gcc
AR = $(CROSS_COMPILE)ar
NM = $(CROSS_COMPILE)nm
STRIP = $(CROSS_COMPILE)strip
OBJDUMP = $(CROSS_COMPILE)objdump
OBJCOPY = $(CROSS_COMPILE)objcopy
SIZE = $(CROSS_COMPILE)size

#PATH
LIB = stm32f10x_lib
PATH_STD_LIB = stm32f10x_lib/STM32F1xx_DFP/1.0.4/Device/StdPeriph_Driver
PATH_CMSIS = stm32f10x_lib/CMSIS

#LINKER SCRIPTS
LD_SCRIPT = stm32f10x_lib/STM32F1xx_DFP/1.0.4/Device/Source/link.lds

#FLAGS
INCLUDES += -Isys/inc/ \
	    -Iuser/inc/ \
	    -I$(PATH_STD_LIB)/inc \
	    -I$(PATH_CMSIS)/Include \
	    -I$(LIB)/STM32F1xx_DFP/1.0.4/Device/Include
STM_DEFS = -DUSE_STM32F10X_HD -DUSE_STDPERIPH_DRIVER
ASFLAGS = -mcpu=cortex-m3 -mthumb
CFLAGS  = $(INCLUDES) $(STM_DEFS) -g -O0 -Wall -MMD -mcpu=cortex-m3 -mthumb -march=armv7-m
LDFLAGS  = -T$(LD_SCRIPT) \
	   -L$(LIB)/STM32F1xx_DFP/1.0.4/Device/Source/ \
	   -L$(PATH_STD_LIB)/ \
	   -Luser/src/ \
	   -Lsys/src/

#CMSIS OBJs
CMSIS_OBJS += $(LIB)/STM32F1xx_DFP/1.0.4/Device/Source/system_stm32f10x.o
CMSIS_OBJS += $(LIB)/STM32F1xx_DFP/1.0.4/Device/Source/startup_stm32f10x_hd.o

#StdPeriph_Driver OBJS
STD_LIB_OBJS += $(PATH_STD_LIB)/src/misc.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_adc.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_bkp.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_can.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_cec.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_crc.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_dac.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_dbgmcu.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_dma.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_exti.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_flash.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_fsmc.o
STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_gpio.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_i2c.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_iwdg.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_pwr.o
STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_rcc.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_rtc.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_sdio.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_spi.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_tim.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_usart.o
#STD_LIB_OBJS += $(PATH_STD_LIB)/src/stm32f10x_wwdg.o 

#USER OBJs
USER_OBJS += user/src/main.o
USER_OBJS += sys/src/stm32f10x_it.o

#ALL OBJs
OBJS = $(CMSIS_OBJS) $(STD_LIB_OBJS) $(USER_OBJS)

#rule for to .c files
%.o:

.PHONY: all elf bin
all: bin elf

bin: elf
	@echo "************Create Bin File...***********************"
	$(OBJCOPY) -O binary build/target.elf build/target.bin
	@echo "********Create Bin File Finished...******************"

elf: $(OBJS)
	-mkdir build
	@echo "*********************Linking...**********************"
	$(CC) $(LDFLAGS) -nostdlib $(OBJS) -o build/target.elf
	@echo "*****************Linking Finished!*******************"

.PHONY : clean
clean:
	-rm user/src/*.{d,o}
	-rm sys/src/*.{d,o}
	-rm $(PATH_STD_LIB)/src/*.{d,o}
	-rm $(LIB)/STM32F1xx_DFP/1.0.4/Device/Source/*.{d,o}
