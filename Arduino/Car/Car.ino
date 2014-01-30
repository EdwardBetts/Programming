//int pinState = 0;
int trigger = 39;
int echo = 37;

void setup()
{
  pinMode(12, OUTPUT);
  pinMode(35, OUTPUT);
  pinMode(37, INPUT);
  pinMode(39, OUTPUT);
  pinMode(41, OUTPUT);
  
  pinMode(34, OUTPUT); //LED
  pinMode(36, OUTPUT);
  
  pinMode(40, OUTPUT);
  pinMode(38, OUTPUT);
  
  Serial.begin(9600);
}

int findDistance ()
{
  digitalWrite(trigger, LOW);
  delay(2);
  
  digitalWrite(trigger, HIGH);
  delay(10);
  
  digitalWrite(trigger, LOW);
  int distance = pulseIn(echo, HIGH);
  distance = distance / 58.2;
  return distance;
}

void loop()
{
  digitalWrite(12, HIGH); //Motor
  digitalWrite(35, LOW); //Ground
  digitalWrite(41, HIGH); //Vcc
  
  digitalWrite(34, LOW);
  digitalWrite(36, LOW);
  
  digitalWrite(40, LOW);
  digitalWrite(38, LOW);
  
  int distance = findDistance();
  
  Serial.println(distance);
  
  if (distance < 21)
  {
    //digitalWrite(12, LOW);
    analogWrite(12, 150);
    digitalWrite (34, HIGH); //LED ON
    digitalWrite (40, HIGH); //LED ON
    while (distance < 21 && distance > 9)
    {
      distance = findDistance();
    }
  }
  
  if (distance < 11)
  {
    digitalWrite(12, LOW); //MOTOR OFF
    while (distance < 20)
    {
      distance = findDistance();
      delay(500);
    }
  }

/*
  {
  int num = (Serial.read() - '0');
  if(num == 1)
  {
    for (int i =0; i <255; i=i+10)
    {
    analogWrite(12, i);
    delay(100);
    }
  }
  else
  {
    digitalWrite(12,LOW);
  }
  Serial.flush();
  while (Serial.available() == 0); 
  */
}
