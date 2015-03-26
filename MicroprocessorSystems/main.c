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
  
  while(timeout < 1000) {
    timeout += 1;
    if(buttonReleased) {
      if (buttonState == LOW) {
        startingLed = firstLed;
      }
    } else if (buttonState == HIGH) {
        buttonReleased = true;
    }
    
    buttonState = digitalRead(button);
    delay(1);
  }
  
  return startingLed;
}

int lightLedInitially() {
  led = chooseStartingLed();
  digitalWrite(led, HIGH);
  delay(5000);
}
