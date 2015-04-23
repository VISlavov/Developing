const int button = PUSH2;

int isButtonPressed = 0;
  
void setup() {
  pinMode(button, INPUT_PULLUP);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  
  digitalWrite(GREEN_LED, LOW);
  digitalWrite(RED_LED, LOW);
}

void loop(){
  int buttonState = digitalRead(button);
  
  if(isButtonPressed) {
    if (buttonState == HIGH) {
      stageOne();
    }
  }
  
  if (buttonState == LOW) {
    isButtonPressed = 1;
  }
}

void stageOne() {
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
  delay(5000);
  digitalWrite(led, LOW);
}
