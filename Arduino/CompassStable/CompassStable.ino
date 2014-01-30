// Reference the I2C Library
#include <Wire.h>
// Reference the HMC5883L Compass Library
#include <HMC5883L.h>
#include <ST7735.h>
#include <SPI.h>

#define sclk 4
#define mosi 5
#define cs 6
#define dc 7
#define rst 8  // you can also connect this to the Arduino reset

// Color definitions
#define	BLACK           0x0000
#define	BLUE            0xFF00
#define	RED             0xF800
#define	GREEN           0x07E0
#define CYAN            0x07FF
#define MAGENTA         0xF81F
#define YELLOW          0xFFE0  
#define WHITE           0xFFFF

ST7735 tft = ST7735(cs, dc, mosi, sclk, rst);  

// Store our compass as a variable.
HMC5883L compass;
// Record any errors that may occur in the compass.
int error = 0;

//rounding angle
int RoundDegreeInt;

int PreviousDegree = 0;

// Out setup routine, here we will configure the microcontroller and compass.
void setup()
{
  tft.initR();
  //tft.writecommand(ST7735_DISPON);
  
  tft.fillScreen(BLACK);

  tft.drawString(0,10,"HEADING:",WHITE);
  tft.drawString(0,30,"Xaxis:",WHITE);
  tft.drawString(0,50,"Yaxis:",WHITE);
  tft.drawString(0,70,"Zaxis:",WHITE);
  
  pinMode (A11, OUTPUT);
  pinMode (A10, OUTPUT);
  
  pinMode (18, OUTPUT);
  pinMode (19, OUTPUT);
  
  // Initialize the serial port.
  Serial.begin(9600);

  //Wire.begin(); // Start the I2C interface.

  compass = HMC5883L(); // Construct a new HMC5883 compass.
 
  error = compass.SetScale(1.3); // Set the scale of the compass.
  if(error != 0) // If there is an error, print it out.
    Serial.println(compass.GetErrorText(error));

  error = compass.SetMeasurementMode(Measurement_Continuous); // Set the measurement mode to Continuous
  if(error != 0) // If there is an error, print it out.
    Serial.println(compass.GetErrorText(error));
}

// Our main program loop.
void loop()
{
  digitalWrite (A10, LOW);
  digitalWrite (A11, LOW); //POSITIVE
  
  digitalWrite (18, LOW);
  digitalWrite (19, LOW); //POSITIVE
  
  // Retrive the raw values from the compass (not scaled).
  MagnetometerRaw raw = compass.ReadRawAxis();
  // Retrived the scaled values from the compass (scaled to the configured scale).
  MagnetometerScaled scaled = compass.ReadScaledAxis();

  // Values are accessed like so:
  //int MilliGauss_OnThe_XAxis = scaled.XAxis;// (or YAxis, or ZAxis)

  // Calculate heading when the magnetometer is level, then correct for signs of axis.
  float heading = atan2(raw.YAxis, raw.XAxis);

  // Once you have your heading, you must then add your 'Declination Angle', which is the 'Error' of the magnetic field in your location.
  // Find yours here: http://www.magnetic-declination.com/
  // Mine is: 2ÔøΩ 37' W, which is 2.617 Degrees, or (which we need) 0.0456752665 radians, I will use 0.0457
  // If you cannot find your Declination, comment out these two lines, your compass will be slightly off.
  //float declinationAngle = 0.009 ;
  //heading += declinationAngle;

  // Correct for when signs are reversed.
  if(heading < 0)
    heading = heading + (2*PI);
 
  // Check for wrap due to addition of declination.
  //if(heading > 2*PI)
    //heading -= 2*PI;
 
  // Convert radians to degrees for readability.
  float headingDegrees = heading * (180/PI);
  Serial.print(headingDegrees);
  Serial.print("\t\t");
    
  headingDegrees = map(headingDegrees, 62, 104, 0, 360);
  Serial.print("Mapped");
  Serial.print(headingDegrees);
  Serial.print("\t\t");
  
  headingDegrees -= 80;
  Serial.print("Minus80");
  Serial.print(headingDegrees);
  Serial.print("\t\t");
  
  Serial.println();

  //correcting the angle issue
/*
  if (headingDegrees >= 1 && headingDegrees < 260)
  {
    headingDegrees = map(headingDegrees,0,259,180,360);
  }
  else if (headingDegrees >= 260)
  {
    headingDegrees =  map(headingDegrees,260,360,180,360);
  }
*/

  if (headingDegrees >= 360)
    headingDegrees -+ 360;
    
  if (headingDegrees < 0)
    headingDegrees += 360;

  //rounding the angle
  RoundDegreeInt =round(headingDegrees);

  //smoothing value
  if( RoundDegreeInt < (PreviousDegree + 3) && RoundDegreeInt > (PreviousDegree - 3) ) {
    RoundDegreeInt = PreviousDegree;
  }

  Output(RoundDegreeInt, raw.YAxis, scaled.XAxis, scaled.ZAxis);

  PreviousDegree = RoundDegreeInt;

  // Normally we would delay the application by 66ms to allow the loop
  // to run at 15Hz (default bandwidth for the HMC5883L).
  // However since we have a long serial out (104ms at 9600) we will let
  // it run at its natural speed.
  // delay(66);
}

// Output the data down the serial port.
void Output(int RoundDegreeInt, int yaxis, int xaxis, int zaxis)
{
  char headingDeg[32];
  char xaxisArray[32];
  char yaxisArray[32];
  char zaxisArray[32];
  
  tft.fillRect(64, 10, 64, 7, BLACK);
  
  ltoa(RoundDegreeInt, headingDeg, 10);
  ltoa(xaxis, xaxisArray, 10);
  ltoa(yaxis, yaxisArray, 10);
  ltoa(zaxis, zaxisArray, 10);
  
  tft.drawString(64,10,headingDeg,WHITE);
  tft.fillRect(64, 30, 64, 7, BLACK);
  
  tft.drawString(64,30,xaxisArray,WHITE);
  tft.fillRect(64, 50, 64, 7, BLACK);
  
  tft.drawString(64,50,yaxisArray,WHITE);
  tft.fillRect(64, 70, 64, 7, BLACK);
  
  tft.drawString(64,70,zaxisArray,WHITE);
}

