/*
 * Blinky - CI Build monitor
 */

// LATCH (GREEN)
int latchPin = 8;

// CLOCK (YELLOW)
int clockPin = 12;

// DATA (BLUE)
int dataPin = 11;

// passthrough data byte
int dataByte = 1;
unsigned char value = 1;
unsigned char blinker = 1;

void setup() {
  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);  
  pinMode(clockPin, OUTPUT);
  
  Serial.begin(9600);
  Serial.println("ready");
  resetLEDs();
}

void loop() {
  int avail = Serial.available();
  if (avail) {
    digitalWrite(latchPin, LOW);
    while (Serial.available()) {
      int data = Serial.read();
      Serial.println(data);
      shiftOut(dataPin, clockPin, MSBFIRST, data);
    }
    digitalWrite(latchPin, HIGH);
  }
}
  
void alert() {
  digitalWrite(latchPin, LOW);
  int data = blinker == 1 ? 0x00 : 0xFF;
  shiftOut(dataPin, clockPin, LSBFIRST, data);
  shiftOut(dataPin, clockPin, LSBFIRST, data);
  shiftOut(dataPin, clockPin, LSBFIRST, data);
  shiftOut(dataPin, clockPin, LSBFIRST, data);
  digitalWrite(latchPin, HIGH);
  
  digitalWrite(13, blinker);
  blinker = !blinker;
  
  delay(300);
}

void resetLEDs() {
  Serial.println("reset");
  digitalWrite(latchPin, LOW);
  for (int i = 0; i < 4; i++) {
    shiftOut(dataPin, clockPin, LSBFIRST, 0x00);
  }
  digitalWrite(latchPin, HIGH);
}
