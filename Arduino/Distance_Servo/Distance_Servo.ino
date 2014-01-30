
#include <Servo.h>

int trig = 36;
int echo = 38;
Servo servo;

void setup()
{
  pinMode(34, OUTPUT); //Sensor Vcc
  pinMode(40, OUTPUT); //Sensor gnd
  pinMode(trig, OUTPUT); //Sensor trigger
  pinMode(echo, INPUT); //Sensor echo
  Serial.begin(9600);
  servo.attach(8);
  pinMode(13, OUTPUT);
  
  digitalWrite(34, HIGH);
  digitalWrite(40, LOW);
}

void loop()
{
  digitalWrite(trig, LOW);
  delay(2);
  digitalWrite(trig, HIGH);
  delay(10);
  digitalWrite(trig, LOW);
  int distance = pulseIn(echo, HIGH);
  distance = distance/58.2;
  int pos = map(distance, 0, 72, 0, 180);
  Serial.println(pos);
  servo.write(pos);
  if (distance < 10) 
  {
    digitalWrite(13, HIGH);
  }
}
