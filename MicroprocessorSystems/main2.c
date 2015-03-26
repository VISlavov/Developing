const int button = PUSH2;
const int firstLed =  RED_LED;
const int secondLed = GREEN_LED;

int buttonState = 0;
int timeout = 0;
int buttonReleased = false;
int led = secondLed;

void setup() {
  pinMode(firstLed, OUTPUT);
  pinMode(secondLed, OUTPUT);
  pinMode(button, INPUT_PULLUP);     
}

void loop(){
  buttonState = digitalRead(button);
  digitalWrite(secondLed, LOW);
  digitalWrite(firstLed, LOW);

  if (buttonState == LOW) {
    lightLedInitially();
  }
}

int chooseStartingLed() {
  int startingLed = secondLed;
  
  timeout(1000, &chooseLed, startingLed);
  
  return startingLed;
}

void chooseLed(int startingLed) {
  if(buttonReleased) {
    if (buttonState == LOW) {
      startingLed = firstLed;
    }
  } else if (buttonState == HIGH) {
      buttonReleased = true;
  }
  
  buttonState = digitalRead(button);
}

void timeout(int time, void (*callback)(const byte*), int callbackArg) {
  while(timeout < time) {
    timeout += 1;
    (*callback)(callbackArg);
    delay(1);
  }
}

int lightLedInitially() {
  led = chooseStartingLed();
  digitalWrite(led, HIGH);
  delay(5000);
}
