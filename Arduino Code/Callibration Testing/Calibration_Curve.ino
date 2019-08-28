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

*/

double TwoSecDV;
double TwoSecIV;
double FiveSecDV;
double FiveSecIV;
double TenSecDV;
double TenSecIV;
double MaxDifferentialVoltage = 0.0;

int FillDetect1;
int FillDetect2;
int DifferentialSignal;
int IntegratedSignal;
int ReferenceSignal;
int StripDetect;

double FillDetect1Voltage;
double FillDetect2Voltage;
double DifferentialVoltage;
double IntegratedVoltage;
double ReferenceVoltage;

void(* resetFunc) (void) = 0;  // declare reset fuction at address 0 (runs a software reset)

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
  
  Serial.print("#  ");
  Serial.print("\t");       //print tab
  Serial.print("\t");
  Serial.print("Diff. V");
  Serial.print("\t");
  Serial.print("\t");
  Serial.print("Int. V");
  Serial.print("\t");
  Serial.print("\t");  
  Serial.print("Max Diff.V");
  Serial.print("\t");  
  Serial.print("WE 1");
  Serial.print("\t"); 
  Serial.print("\t"); 
  Serial.print("WE 2");
  Serial.print("\t");
  Serial.print("\t"); 
  Serial.print("Ref");
  Serial.print("\t"); 
  Serial.println();
}


void loop() {
 // put your main code here, to run repeatedly:
       
  digitalWrite(12, LOW); //close analog switch and unshort integrator capacitor

  delay(50);
      
  for (int i = 0; i < 150; i++) {   
    DifferentialSignal = analogRead(A3); // volt difference after instumentation amp (with gain)
    IntegratedSignal = analogRead(A2);   // integrated volt difference
    ReferenceSignal = analogRead(A1);    // reference voltage 1.65V from voltage divider
    FillDetect1 = analogRead(A6);       // update working electrode reading
    FillDetect2 = analogRead(A7);       // update working electrode reading
  
    // Convert the sampled signal reading (which goes from 0 - 1023) to a voltage (0 - 3.3V)
    // Minus ReferenceSignal (1.65V) because the input voltage to the op-amps is 1.65V, providing an offset
    ReferenceVoltage = (ReferenceSignal * (3.3 / 1023.0));
    DifferentialVoltage = (DifferentialSignal * (3.3 / 1023.0)) - ReferenceVoltage;
    IntegratedVoltage = (IntegratedSignal * (3.3 / 1023.0)) - ReferenceVoltage;
    FillDetect1Voltage = (FillDetect1 * (3.3 / 1023.0));
    FillDetect2Voltage = (FillDetect2 * (3.3 / 1023.0));
          
    if (abs(DifferentialVoltage) > abs(MaxDifferentialVoltage)) {   // to capture the peak voltage corresponding to highest glucose measurement
      MaxDifferentialVoltage = DifferentialVoltage; 
      }
          
    if (i == 10) {  //to log the voltage and integrated voltage at 2sec
       TwoSecDV = DifferentialVoltage;
       TwoSecIV = IntegratedVoltage;
       }
    if (i == 25) {  //to log the voltage and integrated voltage at 5sec
       FiveSecDV = DifferentialVoltage;
       FiveSecIV = IntegratedVoltage;
       }
    if (i == 50) {  //to log the voltage and integrated voltage at 10sec
       TenSecDV = DifferentialVoltage;
       TenSecIV = IntegratedVoltage;
       }              
          
   // digitalWrite(10, HIGH); //Turn on LED
    Serial.print(i);
    Serial.print("\t");
    Serial.print("\t");
    Serial.print(DifferentialVoltage);
    Serial.print("\t");
    Serial.print("\t");
    Serial.print(IntegratedVoltage);
    Serial.print("\t");
    Serial.print("\t");
    Serial.print(MaxDifferentialVoltage); 
    Serial.print("\t");
    Serial.print("\t");
    Serial.print(FillDetect1Voltage);
    Serial.print("\t");
    Serial.print("\t");
    Serial.print(FillDetect2Voltage);
    Serial.print("\t");
    Serial.print("\t");
    Serial.print(ReferenceVoltage);  
    Serial.print("\t");
    Serial.println();
  
          
    //digitalWrite(10, LOW);  //Turn off LED
    delay(200);
    }
    
  Serial.println("Reset"); //indicate pseudo reset is triggered when measurement time is up
  digitalWrite(12, HIGH); // open analog switch and discharges the capacitor
  digitalWrite(13, HIGH); // Turn on internal LED to display end of measurement time
  delay(1000);
  
  resetFunc(); //call reset (this just starts the code at line 0 and thus resets variables to desired values)
  
}
