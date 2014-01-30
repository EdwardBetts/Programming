int num = 0;
int pinState = 0;

void setup()
{
  pinMode(22, INPUT); //RECIEVER
  pinMode(2, INPUT); //TEST ANALOG
  pinMode(52, OUTPUT); //TRANSMITTER
  pinMode(11, OUTPUT); //BLUE
  pinMode(30, OUTPUT); //TEST LED
  Serial.begin(9600);
  
  digitalWrite(22, LOW);
  digitalWrite(52, LOW);
}

void loop()
{
  //digitalWrite(11, HIGH); //TEST

  while (!(Serial.available() > 0))
  {
    //read RECIEVER
    Serial.println(analogRead(2));
    Serial.print("number: ");
    Serial.println(num);
    delay(200);
  }
  
  num = (Serial.read() - '0');
  
    //enable TRANSMIT
  if (num == 1)
  {
    digitalWrite(52, HIGH);
    digitalWrite(11, HIGH);
    delay(100);
  }
  else
  {
    digitalWrite(52, LOW);
  }
  
  //enable BLUE
  if (analogRead(2) > 550)
  {
    digitalWrite(11, HIGH);
  }
  
  if (analogRead(2) < 550)
  {
    digitalWrite(11, LOW);
  }
  
  delay(100);
  Serial.flush();
}
