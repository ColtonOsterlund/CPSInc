/***************************************************************************//**
 * @file app.c
 * @brief Silicon Labs Empty Example Project
 *
 * This example demonstrates the bare minimum needed for a Blue Gecko C application
 * that allows Over-the-Air Device Firmware Upgrading (OTA DFU). The application
 * starts advertising after boot and restarts advertising after a connection is closed.
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

#include <stdio.h> //this is so that you can use printf / printSWO / flushSWO for debug prints
#include <stdlib.h> //to use the delay function


/* Bluetooth stack headers */
#include "bg_types.h"
#include "native_gecko.h"
#include "gatt_db.h"

#include "em_adc.h" //this is to be able to use the built in Analog to Digital Converter
#include "em_gpio.h" //this is to be able to use the GPIO pin to discharge the capacitor
#include "em_idac.h" //this is the be able to use the built in Digital to Analog Converter

#include "app.h"

/* Print boot message */
static void bootMessage(struct gecko_msg_system_boot_evt_t *bootevt); //can probably take this out


/* Flag for indicating DFU Reset must be performed */
static uint8_t boot_to_dfu = 0; //device firmware upgrade

//ADC global vars
uint32_t adcData;
uint16 stripDetectVoltage;
int16 differentialVoltage;
int16 integratedVoltage;
uint16 referenceVoltage = 1650;
ADC_InitSingle_TypeDef initSingle = ADC_INITSINGLE_DEFAULT;

//global flag to indicate whether or not peripheral device has requested to run a test
uint8 testFlag;

//global var used as flag to indicate test is running
int testRunning = 0;


/* Main application */
void appMain(gecko_configuration_t *pconfig)
{
#if DISABLE_SLEEP > 0 //if device is currently sleeping and must be woken up, then DISABLE_SLEEP will have been defined to 1
  pconfig->sleep.flags = 0; //set the gecko_config sleep flag to 0 in order to wake up the device
#endif


  initSWOPrinting(); /* Initialize debug prints VIA PRINTF() FUNCTION. Note: debug prints are off by default. See DEBUG_LEVEL in app.h */
  	  	  	  	  	  //needs a \n character to print, must have something to do with when/how its flushing
//  printf("DEBUG PRINT TEST\n");
  printSWO("PRINT TEST");
  flushSWO();

  //USE printSWO() and swoFlush() FOR DEBUG PRINTING TO THE SWO CONSOLE***


//initial setup for ADC
  initSingle.acqTime = adcAcqTime16; //changed from 16
  initSingle.reference = adcRefVDD; //uses the power suply voltage as the reference voltage
  //CMU_ClockEnable(cmuClock_ADC0, true); //this is performed in init_board initBoard function because it results in a compilarion error here
  	  	  	  	  	  	  	  	  	  	  //not sure why it results in a compilation error here - look into this
  	  	  	  	  	  	  	  	  	  	  //hopefully putting it in init_board still works
  initSingle.diff = false; //single ended mode
  //initSingle.resolution = adcRes12Bit;


//initial setup for GPIO pin to discharge capacitor
  //GPIO_DriveModeSet(gpioPortD, gpioDriveStrengthStrongAlternateStrong); //sets GPIO drive strength to STRONG,
        	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	//not sure if this is necessary
  //try this using IDAC instead
  GPIO_PinModeSet(gpioPortD, 13, gpioModePushPull, 1); // push-pull mode means a transistor connects to high, and a transistor connects to low (only one is operated at a time)
  GPIO_PinOutSet(gpioPortD, 13); //initially set SWITCH pin to LOW
  //printSWO("\n\n%d\n\n", GPIO_PinOutGet(gpioPortD, 13));


  //initializing IDAC
//  IDAC_Init_TypeDef init = IDAC_INIT_DEFAULT;
//  init.outMode = idacOutputAPORT1YCH5; //set output pin to PD13 (SWITCH pin)
//  IDAC_Init(IDAC0, &init);
//  IDAC_StepSet(IDAC0, 31); //set output step to max current (I think - might need to ask Katrin)
//  IDAC_OutEnable(IDAC0, true); //disable IDAC output

  /* Initialize stack */
  gecko_init(pconfig); //initializes bluetooth stack I believe? - look up where this function is implemented

  while (1) {
    /* Event pointer for handling events */
    struct gecko_cmd_packet* evt; //this will point at the most recent event that was thrown


    /* Check for stack event. This is a blocking event listener. If you want non-blocking please see UG136. */
    evt = gecko_wait_event(); //evt waits for the next event to be thrown

    /* Handle events */
    switch (BGLIB_MSG_ID(evt->header)) { //BGLIB_MSG_ID returns the message id of the event after taking in the event header as an argument
    									//ex. gecko_evt_system_boot_id
      /* This boot event is generated when the system boots up after reset.
       * Do not call any stack commands before receiving the boot event.
       * Here the system is set to start advertising immediately after boot procedure. */
      case gecko_evt_system_boot_id:

        bootMessage(&(evt->data.evt_system_boot));
        printSWO("boot event - starting advertising\r\n");

//        printf("test");
//        stdoutStreamFlush();

        /* Set advertising parameters. 100ms advertisement interval.
         * The first parameter is advertising set handle
         * The next two parameters are minimum and maximum advertising interval, both in
         * units of (milliseconds * 1.6).
         * The last two parameters are duration and maxtime and maxevents left as default. */
        gecko_cmd_le_gap_set_advertise_timing(0, 160, 160, 0, 0); //this advertises continuously until a connection is made
        															//ask Jeroen if this is how he wants to do it in the end or
        															//if he would prefer for it to advertise for a specific amount of
        															//time and then you must reset to start advertising again in order
        															//to save battery

        /* Start general advertising and enable connections. */
        gecko_cmd_le_gap_start_advertising(0, le_gap_general_discoverable, le_gap_connectable_scannable);


        break;

      case gecko_evt_le_connection_opened_id: //event is thrown when a connection is made with a central device ie. the phone

        printSWO("connection opened\r\n");

        //second argument is the timer handle to be returned upon termination of the timer, third argument is the mode: 0 - repeating, 1 - runs once
        gecko_cmd_hardware_set_soft_timer(6554, 0, 0); //sets a soft timer that fires every second. The strip detect
        												//will be updated upon each firing of the timer, and it will
        												//notify the phone user when it detects that a strip has been inserted.
        												//Phone user must do a read upon connection to check if strip was
        												//inserted before connection.
        												//Will also notify phone user if the value changes after the strip has
        												//been detected indicating that the strip has been removed.

        //32768 = 1 second
        break;



      case gecko_evt_hardware_soft_timer_id: //this will trigger when the soft timer in the gecko_evt_le_connection_opened_id fires (once every second)

    	  if(evt->data.handle == 0){ //timer from gecko_evt_le_connection_opened_id event
    		  readStripDetectVoltage();
    		  updateStripDetectVoltage();
    		  notifyStripDetectVoltage();

    		  if(testRunning == 1){
    			  readIntegratedVoltage();
    			  updateIntegratedVoltage();
    			  notifyIntegratedVoltage();

    			  readDifferentialVoltage();
    			  updateDifferentialVoltage();
    			  notifyDifferentialVoltage();
    		  }
    	  }
    	  else if(evt->data.handle == 1){ //timer from dischargeCapacitor()
    		  //try this using IDAC instead
    		  GPIO_PinOutClear(gpioPortD, 13); //reset SWITCH pin to LOW

    		  //printSWO("\n\n%d\n\n", GPIO_PinOutGet(gpioPortD, 13));

    		  //IDAC_OutEnable(IDAC0, true); //disable IDAC output

    	  }

    	break;


      case gecko_evt_gatt_server_attribute_value_id: //this will be triggered when Test Flag characteristic is changed by the central device

    	  testFlag = (uint8)*(evt->data.evt_gatt_server_attribute_value.value.data); //the characteristic is named poorly,
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	 //it is not actually discharging the capacitor,
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	 //it is starting the test - capacitor gets
    	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	  	 //discharged automatically

    	  if(testFlag == 0){
    		  testRunning = 0;
    		  dischargeCapacitor();
    	  }
    	  else if(testFlag == 1){
    		  testRunning = 1;
    	  }

    	break;


      case gecko_evt_le_connection_closed_id:

        printSWO("connection closed, reason: 0x%2.2x\r\n", evt->data.evt_le_connection_closed.reason);

        /* Check if need to boot to OTA DFU mode */
        if (boot_to_dfu) { //this will be called if the boot_to_dfu flag was set to 1 - device firmware upgrade
          /* Enter to OTA DFU mode */
          gecko_cmd_system_reset(2); //0 - normal reset
          	  	  	  	  	  	  	  //1 - UART DFU reset (through the Simplicity Mini Debug Adapter)
          	  	  	  	  	  	  	  //OTA DFU reset (over the air)
        } else { //if not going into DFU then it will start advertising again
          /* Restart advertising after client has disconnected */
          gecko_cmd_le_gap_start_advertising(0, le_gap_general_discoverable, le_gap_connectable_scannable);
        }
        break;

      /* Events related to OTA upgrading
         ----------------------------------------------------------------------------- */

      /* Check if the user-type OTA Control Characteristic was written.
       * If ota_control was written, boot the device into Device Firmware Upgrade (DFU) mode. */
      case gecko_evt_gatt_server_user_write_request_id:

        if (evt->data.evt_gatt_server_user_write_request.characteristic == gattdb_ota_control) {
          /* Set flag to enter to OTA mode */
          boot_to_dfu = 1;
          /* Send response to Write Request */
          gecko_cmd_gatt_server_send_user_write_response(
            evt->data.evt_gatt_server_user_write_request.connection,
            gattdb_ota_control,
            bg_err_success);

          /* Close connection to enter to DFU OTA mode */
          gecko_cmd_le_connection_close(evt->data.evt_gatt_server_user_write_request.connection);
        }
        break;

      /* Add additional event handlers as your application requires */

      default:
        break;
    }
  }
}

void readStripDetectVoltage(){ //needs function prototype
	//pin PA1 (the strip detect) was set in the ADC to be the positive input for Single Channel Mode, the channel for the negative input is VSS
	//to allow for single-ended conversion - check that this is working correctly/this is the proper way to do it
	initSingle.posSel = adcPosSelAPORT4XCH9; //this is the PA1 pin that the Strip Detect is connected to - see ADC Reference Manual and BGM113 Data Sheet
	initSingle.negSel = adcNegSelVSS;

	//reading voltage from Strip Detect Pin
	ADC_InitSingle(ADC0, &initSingle); //initializing adc single sample mode
	ADC_Start(ADC0, adcStartSingle); //starting adc single sample
	while((ADC_IntGet(ADC0) & ADC_IF_SINGLE) != ADC_IF_SINGLE); //unsure of this looping condition - look into this - something to do with ADC interrupts
	adcData = ADC_DataSingleGet(ADC0); //get the value of the single sample from the adc
	stripDetectVoltage = (uint16)(adcData * 3300 / 4096); //convert the value from the single sample from the adc into a readable voltage(adc signal goes from 0 - 4096, our voltage goes from 0-3300mV)
	printSWO("strip detect voltage: %d mV\r\n", stripDetectVoltage); //print the voltage to the SWO console
}

void updateStripDetectVoltage(){ //needs function prototype
	//writing voltage from Strip Detect pin into gatt db
	stripDetectVoltage = ((stripDetectVoltage & 0x00FF) << 8) | ((stripDetectVoltage & 0xFF00) >> 8); //convert stripDetectVoltage to hex
	gecko_cmd_gatt_server_write_attribute_value(gattdb_sd_voltage, 0, 2, (const uint8*)&stripDetectVoltage); //write stripDetectVoltage to the gatt db
}

void notifyStripDetectVoltage(){ //needs function prototype
	 gecko_cmd_gatt_server_send_characteristic_notification(0xff, gattdb_sd_voltage, 2, (const uint8*)&stripDetectVoltage);
}

void readDifferentialVoltage(){ //needs function prototype
	initSingle.posSel = adcPosSelAPORT3XCH28; //PB12
	initSingle.negSel = adcNegSelVSS;

	//reading voltage from Differential Voltage Pin
	ADC_InitSingle(ADC0, &initSingle); //initializing adc single sample mode
	ADC_Start(ADC0, adcStartSingle); //starting adc single sample
	while((ADC_IntGet(ADC0) & ADC_IF_SINGLE) != ADC_IF_SINGLE); //unsure of this looping condition - look into this - something to do with ADC interrupts
	adcData = ADC_DataSingleGet(ADC0); //get the value of the single sample from the adc

	//printSWO("ADC DIFF = %d\n", ((adcData * 3300) / 4096));

	differentialVoltage = (int16)(adcData * 3300 / 4096) - referenceVoltage; //convert the value from the single sample from the adc into a readable voltage (adc signal goes from 0 - 4096, our voltage goes from 0-3300mV)
	printSWO("differential voltage: %d mV\r\n", differentialVoltage); //print the voltage to the SWO console
}

void updateDifferentialVoltage(){ //needs function prototype
	 //writing voltage from Differential Voltage pin into gatt db
	 differentialVoltage = ((differentialVoltage & 0x00FF) << 8) | ((differentialVoltage & 0xFF00) >> 8); //convert differentialVoltage to hex
	 gecko_cmd_gatt_server_write_attribute_value(gattdb_diff_voltage, 0, 2, (const uint8*)&differentialVoltage); //write differentialVoltage to the gatt db
}

void notifyDifferentialVoltage(){ //needs function prototype
	gecko_cmd_gatt_server_send_characteristic_notification(0xff, gattdb_diff_voltage, 2, (const uint8*)&differentialVoltage);
}

void readIntegratedVoltage(){ //need function prototype
	//INTEGRATED VOLTAGE
	initSingle.posSel = adcPosSelAPORT4XCH29; //PB13
	initSingle.negSel = adcNegSelVSS;

	//reading voltage from Integrated Voltage Pin
	ADC_InitSingle(ADC0, &initSingle); //initializing adc single sample mode
	ADC_Start(ADC0, adcStartSingle); //starting adc single sample
	while((ADC_IntGet(ADC0) & ADC_IF_SINGLE) != ADC_IF_SINGLE); //unsure of this looping condition - look into this - something to do with ADC interrupts
	adcData = ADC_DataSingleGet(ADC0); //get the value of the single sample from the adc

	//printSWO("ADC DATA = %d\n", adcData);
	printSWO("ADC INT = %d\n", ((adcData * 3300) / 4096));

	integratedVoltage = (int16)(adcData * 3300 / 4096) - referenceVoltage; //convert the value from the single sample from the adc into a readable voltage (adc signal goes from 0 - 4096, our voltage goes from 0-3300mV)
	printSWO("integrated voltage: %d mV\r\n", integratedVoltage); //print the voltage to the SWO console
}

void updateIntegratedVoltage(){ //needs function prototype
	//writing voltage from Integrated Votltage pin into gatt db
	integratedVoltage = ((integratedVoltage & 0x00FF) << 8) | ((integratedVoltage & 0xFF00) >> 8); //convert integratedVoltage to hex
	gecko_cmd_gatt_server_write_attribute_value(gattdb_int_voltage, 0, 2, (const uint8*)&integratedVoltage); //write integratedVoltage to the gatt db
}

void notifyIntegratedVoltage(){ //needs function prototype
	gecko_cmd_gatt_server_send_characteristic_notification(0xff, gattdb_int_voltage, 2, (const uint8*)&integratedVoltage);
}

void dischargeCapacitor(){ //needs function prototype
	//set SWITCH pin to high to short & discharge the capacitor

	//try this using IDAC instead
	GPIO_PinOutSet(gpioPortD, 13); //set SWITCH pin to HIGH
	//printSWO("\n\n%d\n\n", GPIO_PinOutGet(gpioPortD, 13));

	//IDAC_OutEnable(IDAC0, false); //enable IDAC output

	gecko_cmd_hardware_set_soft_timer(65536, 1, 1); //sets a 2 second timer. SWITCH pin stays LOW for 2 second to ensure
													//it is fully discharging the capacitor

}

/* Print stack version and local Bluetooth address as boot message */
static void bootMessage(struct gecko_msg_system_boot_evt_t *bootevt) //probably not necessary
{
#if DEBUG_LEVEL
  bd_addr local_addr;
  int i;

  printSWO("stack version: %u.%u.%u\r\n", bootevt->major, bootevt->minor, bootevt->patch);
  local_addr = gecko_cmd_system_get_bt_address()->address;

  printSWO("local BT device address: ");
  for (i = 0; i < 5; i++) {
    printSWO("%2.2x:", local_addr.addr[5 - i]);
  }
  printSWO("%2.2x\r\n", local_addr.addr[0]);
#endif
}
