#include <Adafruit_GFX.h>

#include <Servo.h>

#include <Wire.h>

#include <HMC5883L.h>

// You can use any (4 or) 5 pins 
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

#include <ST7735.h>
#include <SPI.h>

//char headingDeg[32];
// Option 1: use any pins but a little slower
ST7735 tft = ST7735(cs, dc, mosi, sclk, rst);  

HMC5883L compass;
Servo servo;

int total;
int count;

void setup()
{
  
  tft.initR();
  //tft.writecommand(ST7735_DISPON);
  
  tft.fillScreen(BLACK);

  tft.drawString(0,10,"HEADING:",WHITE);
  tft.drawString(0,30,"Xaxis:",WHITE);
  tft.drawString(0,50,"Yaxis:",WHITE);
  tft.drawString(0,70,"Zaxis:",WHITE);
  
  servo.attach(8);
  Wire.begin();
  Serial.begin(9600);
  Serial.println("Serial Started");
  
  compass = HMC5883L();
  int error = compass.SetScale(1.3);
  
  //if (error != 0)
    //Serial.println(compass.GetErrorText(error));
  
  error = compass.SetMeasurementMode(Measurement_Continuous);
  
  //if (error != 0)
    //Serial.println(compass.GetErrorText(error));
}

void loop()
{
  // Retrive the raw values from the compass (not scaled).
  MagnetometerRaw raw = compass.ReadRawAxis();
  // Retrived the scaled values from the compass (scaled to the configured scale).
  MagnetometerScaled scaled = compass.ReadScaledAxis();
  
  // Calculate heading when the magnetometer is level, then correct for signs of axis.
  float heading = atan2((raw.YAxis + 100), (raw.XAxis + 50));
   
  // Correct for when signs are reversed.
  if(heading < 0)
    heading += 2*PI;
   
  // Convert radians to degrees for readability.
  long headingDegrees = heading * 180/M_PI; 
  headingDegrees = headingDegrees + 180;
  if (headingDegrees > 360)
    headingDegrees = headingDegrees - 360;
    

  // Output the data via the serial port.

  Output(raw, scaled, heading, headingDegrees);
  
  delay(100);
}

void Output(MagnetometerRaw raw, MagnetometerScaled scaled, float heading, long headingDegrees)
{
  char headingDeg[32];
  char xaxis[32];
  char yaxis[32];
  char zaxis[32];
  
  tft.fillRect(64, 10, 64, 7, BLACK);
  
  
  ltoa(headingDegrees, headingDeg, 10);
  ltoa(scaled.XAxis, xaxis, 10);
  ltoa(scaled.YAxis, yaxis, 10);
  ltoa(scaled.ZAxis, zaxis, 10);
  
  //sprintf(headingDeg, "%d", headingDegrees);
  
  tft.drawString(64,10,headingDeg,WHITE);
  tft.fillRect(64, 30, 64, 7, BLACK);
  
  tft.drawString(64,30,xaxis,WHITE);
  tft.fillRect(64, 50, 64, 7, BLACK);
  
  tft.drawString(64,50,yaxis,WHITE);
  tft.fillRect(64, 70, 64, 7, BLACK);
  
  tft.drawString(64,70,zaxis,WHITE);
}
