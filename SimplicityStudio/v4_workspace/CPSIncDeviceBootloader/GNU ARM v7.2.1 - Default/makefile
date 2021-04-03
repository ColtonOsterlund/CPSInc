################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 

# All Target
all: CPSIncDeviceBootloader.axf

# Tool invocations
CPSIncDeviceBootloader.axf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: GNU ARM C Linker'
	arm-none-eabi-gcc -g3 -gdwarf-2 -mcpu=cortex-m4 -mthumb -T "C:/SiliconLabs/SimplicityStudio/v4/developer/sdks/gecko_sdk_suite/v2.7//platform/bootloader/core/GCC/main_btl_main_flash.ld" -L"C:/SiliconLabs/SimplicityStudio/v4/developer/sdks/gecko_sdk_suite/v2.7//platform/bootloader/build/lib/" -Xlinker --gc-sections -Xlinker -Map="CPSIncDeviceBootloader.map" -mfpu=fpv4-sp-d16 -mfloat-abi=softfp --specs=nano.specs -o CPSIncDeviceBootloader.axf -Wl,--start-group "./bootloader-callback-stubs.o" "./bootloader-callbacks.o" -lparser_efx32xg11_gcc -lnosys -lbootloader_efx32xg11_gcc -Wl,--end-group -Wl,--start-group -lgcc -lc -lnosys -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

	@echo 'Building hex file: CPSIncDeviceBootloader.hex'
	arm-none-eabi-objcopy -O ihex "CPSIncDeviceBootloader.axf" "CPSIncDeviceBootloader.hex"
	@echo ' '

	@echo 'Building bin file: CPSIncDeviceBootloader.bin'
	arm-none-eabi-objcopy -O binary "CPSIncDeviceBootloader.axf" "CPSIncDeviceBootloader.bin"
	@echo ' '

	@echo 'Building s37 file: CPSIncDeviceBootloader.s37'
	arm-none-eabi-objcopy -O srec "CPSIncDeviceBootloader.axf" "CPSIncDeviceBootloader.s37"
	@echo ' '

	@echo 'Running size tool'
	arm-none-eabi-size "CPSIncDeviceBootloader.axf" -A
	@echo ' '

	$(MAKE) --no-print-directory post-build

# Other Targets
clean:
	-$(RM) $(EXECUTABLES)$(OBJS)$(C_DEPS) CPSIncDeviceBootloader.axf
	-@echo ' '

post-build:
	-sh "C:\Users\colto\SIMPLI~1\V4_WOR~1\CPSINC~1/CPSIncDeviceBootloader_postbuild.sh" CPSIncDeviceBootloader
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY: post-build

-include ../makefile.targets
