int pinRelay = 1;

void setup ()
{
  //  67890
  // |=====|
  // |     |
  // |    *|
  // |=====|
  //  54321
  
  // LOW  = ON
  // HIGH = OFF
  pinMode (1, OUTPUT); //DOT
  pinMode (2, OUTPUT); //BOTTOM RIGHT
  pinMode (3, OUTPUT); //LIVE
  pinMode (4, OUTPUT); //BOTTOM
  pinMode (5, OUTPUT); //BOTTOM LEFT
  pinMode (6, OUTPUT); //TOP RIGHT
  pinMode (7, OUTPUT); //TOP
  pinMode (8, OUTPUT); //LIVE
  pinMode (9, OUTPUT); //TOP LEFT
  pinMode (10, OUTPUT); //MIDDLE
  
  pinMode (14, OUTPUT); //TRIGGER
  pinMode (15, INPUT); //ECHO
  
  pinMode (17, OUTPUT); //LED
  pinMode (18, OUTPUT); //LED
  pinMode (19, OUTPUT); //LED
  pinMode (20, OUTPUT); //LED
  pinMode (21, OUTPUT); //LED
  
  pinMode (11, OUTPUT); //SIREN
  
  Serial.begin(9600);
}

int findDistance()
{
  digitalWrite(14, LOW);
  delay(2);
  
  digitalWrite(14, HIGH);
  delay(10);
  
  digitalWrite(14, LOW);
  int tempDistance = pulseIn(15, HIGH);
  return (tempDistance/58.2);
}

void loop ()
{
  digitalWrite(21, LOW);
  digitalWrite(20, LOW);
  digitalWrite(19, LOW);
  digitalWrite(18, LOW);
  digitalWrite(17, LOW);
  analogWrite(11, 0); //SIREN
  
 int distance = findDistance();
  if (distance < 11)
  {
    switch(distance)
    {
      case 0:
  digitalWrite(2, LOW);
  digitalWrite(4, LOW);
  digitalWrite(5, LOW);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, HIGH);
  analogWrite(11, 150); //SIREN
  break;
  
  case 1:  
  digitalWrite(2, LOW);
  digitalWrite(4, HIGH);
  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);
  digitalWrite(7, HIGH);
  digitalWrite(9, HIGH);
  digitalWrite(10, HIGH);
  analogWrite(11, 150); //SIREN
  break;
  
  case 2:
  //2
  digitalWrite(2, HIGH);
  digitalWrite(4, LOW);
  digitalWrite(5, LOW);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(9, HIGH);
  digitalWrite(10, LOW);
  analogWrite(11, 150); //SIREN
  break;
  
  case 3:
  digitalWrite(2, LOW);
  digitalWrite(4, LOW);
  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(9, HIGH);
  digitalWrite(10, LOW);
  analogWrite(11, 150); //SIREN
  break;
  
  case 4:
  //4
  digitalWrite(2, LOW);
  digitalWrite(4, HIGH);
  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);
  digitalWrite(7, HIGH);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  break;
  
  case 5:
  //5
  digitalWrite(2, LOW);
  digitalWrite(4, LOW);
  digitalWrite(5, HIGH);
  digitalWrite(6, HIGH);
  digitalWrite(7, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  break;
  
  case 6:
  //6
  digitalWrite(2, LOW);
  digitalWrite(4, LOW);
  digitalWrite(5, LOW);
  digitalWrite(6, HIGH);
  digitalWrite(7, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  break;
  
  case 7:
  //7
  digitalWrite(2, LOW);
  digitalWrite(4, HIGH);
  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(9, HIGH);
  digitalWrite(10, HIGH);
  break;
  
  case 8:
  //8
  digitalWrite(2, LOW);
  digitalWrite(4, LOW);
  digitalWrite(5, LOW);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  break;
  
  case 9:
  //9
  digitalWrite(2, LOW);
  digitalWrite(4, LOW);
  digitalWrite(5, HIGH);
  digitalWrite(6, LOW);
  digitalWrite(7, LOW);
  digitalWrite(9, LOW);
  digitalWrite(10, LOW);
  break;
  
  default:
  digitalWrite(2, HIGH);
  digitalWrite(4, HIGH);
  digitalWrite(5, HIGH);
  digitalWrite(6, HIGH);
  digitalWrite(7, HIGH);
  digitalWrite(9, HIGH);
  digitalWrite(10, HIGH);
  break;
    }
  }
    
    if (distance > 10)
    {
  digitalWrite(2, HIGH);
  digitalWrite(4, HIGH);
  digitalWrite(5, HIGH);
  digitalWrite(6, HIGH);
  digitalWrite(7, HIGH);
  digitalWrite(9, HIGH);
  digitalWrite(10, HIGH);
  
      if (distance > 10 && distance < 21)
      {
        digitalWrite(21, HIGH);
      }
      
      if (distance > 20 && distance < 41)
      {
        digitalWrite(20, HIGH);
      }
      
      if (distance > 40 && distance < 61)
      {
        digitalWrite(19, HIGH);
      }
      
      if (distance > 60 && distance < 81)
      {
        digitalWrite(18, HIGH);
      }
      
      if (distance > 80 && distance < 101)
      {
        digitalWrite(17, HIGH);
      }
      
      if (distance > 100)
      {
        digitalWrite(21, HIGH);
        digitalWrite(20, HIGH);
        digitalWrite(19, HIGH);
        digitalWrite(18, HIGH);
        digitalWrite(17, HIGH);
      }
    }
    delay(100);
}
