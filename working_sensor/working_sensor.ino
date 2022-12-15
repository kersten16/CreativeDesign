#include <ADCTouch.h>
 
int left, right, top, bot;       //reference values to remove offset
 
void setup()
{
    // No pins to setup, pins can still be used regularly, although it will affect readings
 
    Serial.begin(9600);
 
    left = ADCTouch.read(A0, 500);    //create reference values to
    top = ADCTouch.read(A1, 500);      //account for the capacitance of the pad
    right = ADCTouch.read(A2, 500);    //create reference values to
    bot = ADCTouch.read(A3, 500);
}
 
void loop()
{
    int valueLeft = ADCTouch.read(A0);   //no second parameter
    int valueTop = ADCTouch.read(A1);
    int valueRight = ADCTouch.read(A2); 
    int valueBot = ADCTouch.read(A3);   //no second parameter
        //   --> 100 samples
 
    valueLeft -= left;       //remove offset
    valueRight -= right;
    valueTop -= top;
    valueBot -= bot;
 
    
    if(valueLeft>40){
      Serial.print("left");
    }
    if(valueRight>40){
      Serial.print("right");
    }
     if(valueTop>40){
      Serial.print("up");
    }
    if(valueBot>40){
      Serial.print("down");
    }

    Serial.println();
        //return pressed or not pressed

    //Serial.print(value0);             //return value
    // Serial.print("\t");
    // Serial.println(value1);
    delay(100);
}