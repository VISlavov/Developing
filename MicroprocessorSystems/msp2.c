const int button = PUSH2;

int isButtonPressed = 0;
int timesToLightUp = 1000;
int isFinished = 0;
  
void setup() {
  pinMode(button, INPUT_PULLUP);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  
  digitalWrite(GREEN_LED, LOW);
  digitalWrite(RED_LED, LOW);
}

void loop(){
  if(isFinished == 0)
    mainProcess();
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
  
  timesToLightUp -= 820;
  
  while(timesToLightUp > 0) {
    digitalWrite(led, HIGH);
    delay(500);
    digitalWrite(led, LOW);
    delay(500);
    timesToLightUp -= 1; 
  }
  
  isFinished = 1;
}

void mainProcess() {
   if(timesToLightUp >= 820 && timesToLightUp <= 840) {
     timesToLightUp -= 320;  
    int buttonState = digitalRead(button);
    
    if(isButtonPressed) {
      if (buttonState == HIGH) {
        stageOne();
      }
    } 
    
    if (buttonState == LOW) {
      isButtonPressed = 1;
    }
  } else {
    timesToLightUp = analogRead(A5);
    
    if(timesToLightUp >= 820 && timesToLightUp <= 840) {
      digitalWrite(GREEN_LED, HIGH);
      delay(5000);
      digitalWrite(GREEN_LED, LOW);
    }
  }
}
