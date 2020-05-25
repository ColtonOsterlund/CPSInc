################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../hardware/kit/common/bsp/bsp_stk.c 

OBJS += \
./hardware/kit/common/bsp/bsp_stk.o 

C_DEPS += \
./hardware/kit/common/bsp/bsp_stk.d 


# Each subdirectory must supply rules for building sources it contributes
hardware/kit/common/bsp/bsp_stk.o: ../hardware/kit/common/bsp/bsp_stk.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-D__StackLimit=0x20000000' '-DHAL_CONFIG=1' '-DBGM113A256V2=1' -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emlib\src" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\CMSIS\Include" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\Device\SiliconLabs\BGM1\Include" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\radio\rail_lib\common" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\app\bluetooth\common\util" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\hardware\kit\common\bsp" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emlib\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\hardware\kit\common\halconfig" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\hardware\module\config" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\tempdrv\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\tempdrv\src" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\Device\SiliconLabs\BGM1\Source\GCC" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\sleep\src" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\hardware\kit\common\drivers" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\sleep\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\common\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\halconfig\inc\hal-config" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\Device\SiliconLabs\BGM1\Source" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\radio\rail_lib\protocol\ble" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\uartdrv\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\bootloader\api" -I"C:\Users\colto\SimplicityStudio\v4_workspace\testt\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"hardware/kit/common/bsp/bsp_stk.d" -MT"hardware/kit/common/bsp/bsp_stk.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


