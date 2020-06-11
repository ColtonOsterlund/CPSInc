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
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\colto\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"hardware/kit/common/bsp/bsp_stk.d" -MT"hardware/kit/common/bsp/bsp_stk.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


