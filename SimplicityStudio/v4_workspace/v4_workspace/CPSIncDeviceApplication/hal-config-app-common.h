/***************************************************************************//**
 * @file
 * @brief hal-config-app-common.h
 *******************************************************************************
 * # License
 * <b>Copyright 2018 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#ifndef HAL_CONFIG_APP_COMMON_H
#define HAL_CONFIG_APP_COMMON_H

#include "em_device.h"
#include "hal-config-types.h"

#if defined(FEATURE_IOEXPANDER)
#include "hal-config-ioexp.h"
#endif

#if defined(FEATURE_FEM)
#include "hal-config-fem.h"
#endif


#if (HAL_PA_ENABLE)
#define HAL_PA_RAMP                                   (10)
#define HAL_PA_2P4_LOWPOWER                           (0)
#define HAL_PA_POWER                                  (252)
#define HAL_PA_CURVE_HEADER                            "pa_curves_efr32.h"
#endif

#ifdef FEATURE_PA_HIGH_POWER
#define HAL_PA_VOLTAGE                                (3300)
#else // FEATURE_PA_HIGH_POWER
#define HAL_PA_VOLTAGE                                (1800)
#endif // FEATURE_PA_HIGH_POWER

#define HAL_VCOM_ENABLE                   (0)
#define HAL_I2CSENSOR_ENABLE              (0)
#define HAL_SPIDISPLAY_ENABLE             (0)

#endif /* HAL_CONFIG_APP_COMMON_H */