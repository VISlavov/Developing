const int button = PUSH2;
int clicks = 0;
int isButtonPressed = 0;
int isFinished = 0;
int check_if_odd(int clicks);

//-----------------------------------------
void setup() {
  pinMode(button, INPUT_PULLUP);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  
  digitalWrite(GREEN_LED, LOW);
  digitalWrite(RED_LED, LOW);
}
//-----------------------------------------
void loop(){
  if(isFinished == 0)
    stageOne();
}
//-----------------------------------------
void lightLedInitially() {
  int i = 0;
  int buttonState = 0;
  int led = GREEN_LED;
  
  for (i = 0; i < 1000; i++) {
    buttonState = digitalRead(button);
    
    if(buttonState == LOW){
      led = RED_LED;
    }
    
    delay(1);
  }
  digitalWrite(led, HIGH);
  stageTwo();
  digitalWrite(led, LOW);
}
//-----------------------------------------
void stageOne() {
  int buttonState = digitalRead(button);
  if(isButtonPressed) {
    if (buttonState == HIGH) {
      lightLedInitially();
    }
  }
  if (buttonState == LOW) {
    isButtonPressed = 1;
  }
}
//-----------------------------------------
void stageTwo() {
  int  buttonReleased = 1;
  int i = 0;
  int buttonState;
  for (i = 0; i < 5000; i++) {
    buttonState = digitalRead(button);
    if(buttonState == LOW){
      if(buttonReleased == 1) {
        clicks += 1;
        buttonReleased = 0;
      }
    }
    if (buttonState == HIGH) {
      buttonReleased = 1;
    }
    delay(1);
  }
  int isOdd = check_if_odd(clicks);
  if (isOdd == 1) {
    clicks = clicks * 2; 
  }
  delay(200);
  analogWrite(A5, clicks + 820);
  
  while(clicks > 0) {
    digitalWrite(GREEN_LED, HIGH);
    delay(500);
    digitalWrite(GREEN_LED, LOW);
    delay(500);
    clicks -=1;
  }
  
  isFinished = 1;
}
//-----------------------------------------
int check_if_odd(int clicks) {
  int isOdd;
  if (clicks % 2 == 0) { // Clicks = 0 is handled in this if condition
    isOdd = 0;
  } else if (clicks % 2 != 0) {
    isOdd = 1;
  }
  return isOdd;
}
