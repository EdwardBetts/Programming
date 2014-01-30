  //1000 is full ANTI-CLOCKWISE
  //1500 is full CLOCKWISE
  //1300 is neutral


#include <Servo.h> 
 
Servo myservo;
int turnSpeed = 1620; // Between 1000 and 1610 (1280 is neutral). <1000 = Full CC. >1610 = Full C
int turnDelay = 10; // In milliseconds ... 1000 = 1 second
 
void setup() 
{ 
  myservo.attach(8);  // attaches the servo on pin 9 to the servo object 
  Serial.begin(9600);
  pinMode(14, OUTPUT);
} 
 
 
void loop() 
{ 
  digitalWrite(14, HIGH);
    myservo.writeMicroseconds(turnSpeed);
    //superSlow();  //Altra slow stuff... Adds a delay in between clock cycles
} 

void superSlow()
{
  digitalWrite(14, LOW);
    delay(turnDelay);
    myservo.writeMicroseconds(1290);
    delay(20000); //Somehow multiplies by 5 if REALLY slow...
}
