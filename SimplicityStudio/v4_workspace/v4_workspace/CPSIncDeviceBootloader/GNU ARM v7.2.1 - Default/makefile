################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include uart-driver/subdir.mk
-include token-management/subdir.mk
-include parser/subdir.mk
-include mbedtls/subdir.mk
-include emlib/subdir.mk
-include delay-driver/subdir.mk
-include crypto/subdir.mk
-include crc/subdir.mk
-include core/EFR32/gcc/subdir.mk
-include core/subdir.mk
-include bgapi-uart-dfu/subdir.mk
-include CMSIS/subdir.mk
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
	arm-none-eabi-gcc -g3 -gdwarf-2 -mcpu=cortex-m4 -mthumb -T "C:/SiliconLabs/SimplicityStudio/v4/developer/sdks/gecko_sdk_suite/v2.5//platform/bootloader/core/GCC/main_btl_main_flash.ld" -L"C:/SiliconLabs/SimplicityStudio/v4/developer/sdks/gecko_sdk_suite/v2.5//platform/bootloader/build/lib/" -Xlinker --gc-sections -Xlinker -Map="CPSIncDeviceBootloader.map" -mfpu=fpv4-sp-d16 -mfloat-abi=softfp --specs=nano.specs -o CPSIncDeviceBootloader.axf -Wl,--start-group "./CMSIS/system_bgm1.o" "./bgapi-uart-dfu/btl_comm_bgapi.o" "./bootloader-callback-stubs.o" "./bootloader-callbacks.o" "./core/EFR32/gcc/main_btl_startup.o" "./core/btl_core.o" "./core/btl_driver_util.o" "./core/btl_main.o" "./crc/btl_crc16.o" "./crc/btl_crc32.o" "./crypto/btl_security_aes.o" "./crypto/btl_security_ecdsa.o" "./crypto/btl_security_sha256.o" "./crypto/ecc.o" "./delay-driver/btl_driver_delay.o" "./emlib/em_assert.o" "./emlib/em_cmu.o" "./emlib/em_core.o" "./emlib/em_crypto.o" "./emlib/em_emu.o" "./emlib/em_gpio.o" "./emlib/em_msc.o" "./emlib/em_rmu.o" "./emlib/em_se.o" "./emlib/em_system.o" "./emlib/em_timer.o" "./emlib/em_usart.o" "./emlib/em_wdog.o" "./mbedtls/crypto_aes.o" "./mbedtls/crypto_management.o" "./mbedtls/crypto_sha.o" "./mbedtls/se_aes.o" "./mbedtls/se_management.o" "./mbedtls/se_sha.o" "./mbedtls/shax.o" "./parser/btl_gbl_custom_tags.o" "./parser/btl_image_parser.o" "./token-management/btl_security_tokens.o" "./uart-driver/btl_driver_uart.o" -lparser_efx32xg11_gcc -lnosys -lbootloader_efx32xg11_gcc -Wl,--end-group -Wl,--start-group -lgcc -lc -lnosys -Wl,--end-group
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
	arm-none-eabi-size "CPSIncDeviceBootloader.axf"
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
