/***************************************************************************//**
 * @brief app.h
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

#ifndef APP_H_
#define APP_H_

#include "gecko_configuration.h"

/* DEBUG_LEVEL is used to enable/disable debug prints. Set DEBUG_LEVEL to 1 to enable debug prints */
#define DEBUG_LEVEL 1

/* Set this value to 1 if you want to disable deep sleep completely */
#define DISABLE_SLEEP 0

#if DEBUG_LEVEL
#include "pg_retargetswo.h"
#include <stdio.h>
#endif

#if DEBUG_LEVEL
#define initSWOPrinting()     setupSWOForPrint()
#define printSWO(...) printf(__VA_ARGS__)
#define flushSWO() swoFlush()
#else
#define initSWOPrinting()
#define printSWO(...)
#define flushSWO()
#endif

/* Main application */
void appMain(gecko_configuration_t *pconfig);

#endif
