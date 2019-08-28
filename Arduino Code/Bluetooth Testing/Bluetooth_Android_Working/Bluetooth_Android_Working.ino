/*
  ReadAnalogVoltage
  A0 = Output of instrumentation amplifier (voltage)
  A1 = Output of integrator (voltage)
  A2 = 1.65V midpoint of opamp
  A7 = Working Electrode voltage 1 
  A6 = Working Electrode voltage 2

  D10 = Red LED
  D11 = Test Strip detect
  D12 = Analog Switch
  D13 = Internal LED

  15 Seconds
  [Glucose] = -8.464(FifteenSecIV) + 12.

*/
#define GLUCOSE_DECIMALS (1)
typedef unsigned long int t_U32;

typedef long int t_I32;

double FiveSecDV;
double FiveSecIV;
double TenSecDV;
double TenSecIV;
double FifteenSecDV;
double FifteenSecIV;

int FillDetect1;
int FillDetect2;
int DifferentialSignal;
int IntegratedSignal;
int ReferenceSignal;
int StripDetect;
int j;
int state;
int start;
int counter;

float FillDetect1Voltage;
float FillDetect2Voltage;
float DifferentialVoltage;
float IntegratedVoltage;
float ReferenceVoltage;
float intVolt;

char outputdata[13]={'0','1','2','3','4','\t','\t','\t','9','a','b','c','\n'};

float GlucoseConc_15;

char* pc;

static const long int
  int_digit_value[] = {1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000};

void(* resetFunc) (void) = 0;  // declare reset fuction at address 0 (runs a software reset)
static void addsign(float fval);
static void m_ltoa(char** str, t_I32 ival, t_U32 precision, bool zero_fill);

// the setup routine runs once when you press reset:
void setup() {
  Serial.begin(9600);       // initialize serial communication at 9600 bits per second
  pinMode(10, OUTPUT);      // D10 is used to drive the red LED
  digitalWrite(10, LOW);    // D10 will be defaulted to 0V (LED off)
  pinMode (11, INPUT);      // D11 is used to detec both test strips inserted. No default value is assigned.
  //digitalWrite(11, HIGH); // No default value is assigned     
  pinMode (12, OUTPUT);     // D12 is used to discharge the 100uF capacitor on the integrator op-amp till the start of measurements
  digitalWrite(12, HIGH);   // D12 default HIGH to discharge by shorting
  pinMode(13, OUTPUT);      // D13 is used to drive the internal LED
  digitalWrite(13, LOW);    // D13 will be defaulted to 0V (LED off)  
  
}

void loop() {
 // put your main code here, to run repeatedly:
       
  digitalWrite(12, LOW); //close analog switch and unshort integrator capacitor
  delay(50);
  
  GlucoseConc_15=0;
  j=0;
  

 //if (Serial.available() > 0) {
    //digitalWrite(13, HIGH); // Turn on internal LED to display end of measurement time
    //delay(50);
    start= Serial.read(); // Reads the data from the serial port
    if (start == 1){
       for (int i = 0; i < 150; i++) {   
          DifferentialSignal = analogRead(A3); // volt difference after instumentation amp (with gain)
          IntegratedSignal = analogRead(A2);   // integrated volt difference
          ReferenceSignal = analogRead(A1);    // reference voltage 1.65V from voltage divider
          FillDetect1 = analogRead(A6);       // update working electrode reading
          FillDetect2 = analogRead(A7);       // update working electrode reading
  
          // Convert the sampled signal reading (which goes from 0 - 1023) to a voltage (0 - 3.3V)
          // Minus ReferenceSignal (1.65V) because the input voltage to the op-amps is 1.65V, providing an offset
          ReferenceVoltage = (ReferenceSignal * (3.3 / 1023.0));
          DifferentialVoltage = (DifferentialSignal * (3.3 / 1023.0)); //- ReferenceVoltage;
          IntegratedVoltage = (IntegratedSignal * (3.3 / 1023.0)); //- ReferenceVoltage;
          FillDetect1Voltage = (FillDetect1 * (3.3 / 1023.0));
          FillDetect2Voltage = (FillDetect2 * (3.3 / 1023.0));
          
          if(DifferentialVoltage - ReferenceVoltage > 0.05) {
            j++;   
            if (j == 75) {  //to log the voltage and integrated voltage at 2sec
              FifteenSecDV = DifferentialVoltage;
              FifteenSecIV = IntegratedVoltage;
              GlucoseConc_15 = -8.464*FifteenSecIV + 12.452;
            }   
          }             

          
          intVolt = IntegratedVoltage-ReferenceVoltage;
 
          addsign(intVolt);
          pc=&outputdata[1];
          m_ltoa( &pc, (t_U32)intVolt, 1, true);
          outputdata[2] = '.';
          // str_len += 1;
          pc=&outputdata[3];
          m_ltoa( &pc, (t_U32)(((intVolt - (t_U32)intVolt) * int_digit_value[2])), 2, true); 
 
          //state = Serial.read(); // Reads the data from the serial port
          //if (state == 49) {
            if(GlucoseConc_15!=0) {
                pc=&outputdata[8];
                m_ltoa( &pc, (t_U32)GlucoseConc_15, 2, true); //add two digets before decimal and add zeroes if needed
                outputdata[10] = '.';
                // str_len += 1;
                pc=&outputdata[11];
                m_ltoa( &pc, (t_U32)(((GlucoseConc_15 - (t_U32)GlucoseConc_15) * int_digit_value[GLUCOSE_DECIMALS])), GLUCOSE_DECIMALS, true);  //add one digit after decimal
   
            }
            else if (GlucoseConc_15==0){  
              outputdata[8] = 'W';
              outputdata[9] = 'a';
              outputdata[10] = 'i';
              outputdata[11] = 't';
            }
           
           if(counter++ & 0x1)
              Serial.write(outputdata, 13);
              //Serial.println();
          //} 
         delay(200);
       } 
   }


  //}

  digitalWrite(12, HIGH); // open analog switch and discharges the capacitor
 // digitalWrite(13, HIGH); // Turn on internal LED to display end of measurement time
  delay(1000);
  
  //resetFunc(); //call reset (this just starts the code at line 0 and thus resets variables to desired values)

  
}


static void addsign(float fval)
{
   if (fval < 0)
            {
                fval = -fval;
                outputdata[0] = '-';
           //     str_len += 1;
           //     field1 -= 1;
            }
            else
            {
                outputdata[0] = '+';
           //     str_len += 1;
           //     field1 -= 1;
            }

}



static void m_ltoa(char** str, t_I32 ival, t_U32 precision, bool zero_fill)
{
 // t_U32
 //   max_chars;

 //   max_chars = (*len > (max_length-10)) ? (max_length - *len) : 9;
 //   if (ival >= int_digit_value[max_chars])  /* Number does not fit line */
 //       return;  /* abort display of number */
    if(ival <0)
    {
      ival*=-1;
    }
    if (precision > 0)  /* Precision was specified */
    {
        while ((int_digit_value[precision-1] > ival) && (precision > 1))
        {
            if (zero_fill)
                *(*str)++ = '0';  /* Write leading zero to output string */
            else
                *(*str)++ = ' ';  /* Write leading space to output string */
            //*len += 1;
            precision -= 1;
        }
    }
    else  /* No precision given, determine field width */
    {
        precision = 0;
        while (int_digit_value[precision] < ival)
            precision += 1;
    }
    if (ival >= int_digit_value[precision])  /* Number does not fit field */
        ival = int_digit_value[precision] - 1;  /* Set number to all 9's */
        /* Note: '9's are used to avoid editing problems with non-digits */
    while (precision > 0)
    {
        precision -= 1;
        *(*str)++ = (ival / int_digit_value[precision]) + 0x30;  /* Write digit to output string */
        ival %= int_digit_value[precision];
        //*len += 1;
    }

}

