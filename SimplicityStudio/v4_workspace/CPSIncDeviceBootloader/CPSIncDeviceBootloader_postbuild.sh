#!/bin/sh

# This file was generated by Simplicity Studio from the following template:
#   platform/bootloader/meta-inf/template/efr32/efr32-postbuild.sh
# Please do not edit it directly.

# Post Build processing for bootloader

COMBINE_BOOTLOADER=1
if [ "${COMBINE_BOOTLOADER}" -eq 0 ]; then
  echo "Nothing to do in postbuild script"
  exit
fi

# use PATH_SCMD env var to override default path for Simplicity Commander
if [ -z "${PATH_SCMD}" ]; then
  COMMANDER="C:\SiliconLabs\SimplicityStudio\v4\developer\adapter_packs\commander\commander.exe"
  case `uname` in CYGWIN*) COMMANDER="`cygpath ${COMMANDER}`";; esac
else
  COMMANDER="${PATH_SCMD}/commander"
fi

if [ ! -f "${COMMANDER}" ]; then
  echo "Error: Simplicity Commander not found at '${COMMANDER}'"
  echo "Use PATH_SCMD env var to override default path for Simplicity Commander."
  exit
fi

FILENAME=$1

echo " "
echo "Add first stage bootloader to image (${FILENAME}-combined.s37)"
echo " "
"${COMMANDER}" convert "C:\SiliconLabs\SimplicityStudio\v4\developer\sdks\gecko_sdk_suite\v2.5/platform/bootloader/build/first_stage/gcc/first_stage_btl_efx32xg11.s37" "${FILENAME}.s37" -o "${FILENAME}-combined.s37"
