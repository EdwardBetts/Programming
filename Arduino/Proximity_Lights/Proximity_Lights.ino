#include <Servo.h>

int echoPin = 8;
int trigPin = 7;
int number = 0;


void setup()
{
  pinMode(18, OUTPUT);
  pinMode(17, OUTPUT);
  pinMode(16, OUTPUT);
  pinMode(15, OUTPUT);
  pinMode(14, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(trigPin, OUTPUT);
  
  
  Serial.begin(9600);
    Serial.println("Enter a number between 1 and 5");
}

int findDistance()
{
   digitalWrite(trigPin, LOW); 
 delayMicroseconds(2); 

 digitalWrite(trigPin, HIGH);
 delayMicroseconds(10); 
 
 digitalWrite(trigPin, LOW);
 int duration = pulseIn(echoPin, HIGH);
 
 return (duration/58.2);
}

void loop()
{
  while (Serial.available() > 0)
  {
    number = Serial.read();
    number = number - '0';
    Serial.print(number, DEC);
    
    if (Serial.available() == 0) Serial.println();
  }
  if (number > -1)
  {
    digitalWrite(14, LOW);
    digitalWrite(15, LOW);
    digitalWrite(16, LOW);
    digitalWrite(17, LOW);
    digitalWrite(18, LOW);
    
    switch (number)
    {
    case 1:
    digitalWrite(14, HIGH);
    break;
    
        case 2:
    digitalWrite(15, HIGH);
    break;
    
        case 3:
    digitalWrite(16, HIGH);
    break;
    
        case 4:
    digitalWrite(17, HIGH);
    break;
    
        case 5:
    digitalWrite(18, HIGH);
    break;
    
    case 99:
    digitalWrite(14, HIGH);
    digitalWrite(15, HIGH);
    digitalWrite(16, HIGH);
    digitalWrite(17, HIGH);
    digitalWrite(18, HIGH);
    break;
    }
  }
  else
  {
    Serial.println("Out of range");
  }
}
