int val_X;
int val_Y;
int val_Z;

int prev_x;
int prev_y;
int prev_z;

int dx;
int dy;
int dz;

int threshold = 10000; // 초기 임계값
int val = 0;

int mode = 0;

const int ledPin = 9;
const int piezo = 10;

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600); // 시리얼 통신
pinMode(ledPin, OUTPUT);
pinMode(piezo, OUTPUT);
}

void loop() {
  val_X = analogRead(A0); // 변수 val_X에 A0값 대입
  val_Y = analogRead(A1); // 변수 val_Y에 A1값 대입
  val_Z = analogRead(A2); // 변수 val_Z에 A2값 대입

  dx = val_X - prev_x;
  dy = val_Y - prev_y;
  dz = val_Z - prev_z;

  prev_x = val_X;
  prev_y = val_Y;
  prev_z = val_Z;

  //Serial.println(threshold);

  //Serial.println((sq(dx) + sq(dy) + sq(dz)));
 Serial.print("threshold:");
  Serial.println(threshold);
  //Serial.println(mode);


  //Serial.write((sq(dx) + sq(dy) + sq(dz)));

  delay(10); // 1초 딜레이
    if((sq(dx) + sq(dy) + sq(dz)) > threshold) {

    Serial.println("1");

    switch (mode) {
    case 0:

      digitalWrite(ledPin, HIGH);
      tone(piezo, 440, 250);
      break;

    case 1:
      digitalWrite(ledPin, HIGH);
      
      break;

    case 2:
      digitalWrite(ledPin, LOW);
      
      break;

  }
  }
    else {
    digitalWrite(ledPin, LOW);
  }


  if (Serial.available() > 0) { // If data is available to read,
    val = Serial.read(); // read it and store it in val

    if(val == '0') //if we get a 1
    {
       threshold += 100;
        Serial.println("Threshold increased");

    }
    else if(val == '1') //if we get a 1
    {
       threshold -= 100;
        Serial.println("Threshold decreased");
    }
    else if(val == '2') //if we get a 1
    {
       mode = 0;
    }
    else if(val == '3') //if we get a 1
    {
       mode = 1;
    }

    else if(val == '4') //if we get a 1
    {
       mode = 2;
    }

  } 
  
}

void establishContact() {
  while (Serial.available() <= 0) {
  //Serial.println("A");   // send a capital A
  delay(10);
  }
}