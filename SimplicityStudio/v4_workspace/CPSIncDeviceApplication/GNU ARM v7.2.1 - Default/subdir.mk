################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../app.c \
../application_properties.c \
../gatt_db.c \
../init_app.c \
../init_board_efr32xg1.c \
../init_mcu_efr32xg1.c \
../main.c 

OBJS += \
./app.o \
./application_properties.o \
./gatt_db.o \
./init_app.o \
./init_board_efr32xg1.o \
./init_mcu_efr32xg1.o \
./main.o 

C_DEPS += \
./app.d \
./application_properties.d \
./gatt_db.d \
./init_app.d \
./init_board_efr32xg1.d \
./init_mcu_efr32xg1.d \
./main.d 


# Each subdirectory must supply rules for building sources it contributes
app.o: ../app.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"app.d" -MT"app.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

application_properties.o: ../application_properties.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"application_properties.d" -MT"application_properties.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

gatt_db.o: ../gatt_db.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"gatt_db.d" -MT"gatt_db.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

init_app.o: ../init_app.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"init_app.d" -MT"init_app.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

init_board_efr32xg1.o: ../init_board_efr32xg1.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"init_board_efr32xg1.d" -MT"init_board_efr32xg1.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

init_mcu_efr32xg1.o: ../init_mcu_efr32xg1.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"init_mcu_efr32xg1.d" -MT"init_mcu_efr32xg1.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

main.o: ../main.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU ARM C Compiler'
	arm-none-eabi-gcc -g -gdwarf-2 -mcpu=cortex-m4 -mthumb -std=c99 '-D__HEAP_SIZE=0xD00' '-D__STACK_SIZE=0x800' '-DHAL_CONFIG=1' '-D__StackLimit=0x20000000' '-DEFR32BG1B232F256GM48=1' -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\CMSIS\Include" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\bsp" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\common" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\drivers" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ble" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emlib\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\hardware\kit\common\halconfig" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\halconfig\inc\hal-config" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\app\bluetooth\common\util" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\protocol\bluetooth\ble_stack\inc\soc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\uartdrv\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\protocol\ieee802154" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\radio\rail_lib\chip\efr32\efr32xg1x" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\common\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\sleep\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\gpiointerrupt\inc" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader\api" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\emdrv\tempdrv\src" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\Device\SiliconLabs\EFR32BG1B\Source\GCC" -I"C:\Users\codytucker\Desktop\CPS revised code\CPSInc\SimplicityStudio\v4_workspace\CPSIncDeviceApplication\platform\bootloader" -O2 -Wall -c -fmessage-length=0 -ffunction-sections -fdata-sections -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -MMD -MP -MF"main.d" -MT"main.o" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


