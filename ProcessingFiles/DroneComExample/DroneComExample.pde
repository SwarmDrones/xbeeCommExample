import processing.serial.*;

Serial myPort;  // Create object from Serial class

//TO GET THE TEENSY AND PROCESSING TO WORK ON THE SAME PORT, PROGRAM THE ARDUINO
//HIT RESET BUTTON AND WITHIN A SMALL TIME FRAME START THE SERIAL PORT IN PROCESSING

Comm Arielsthing = new Comm();
void setup() 
{
  size(200,200); //make our canvas 200 x 200 pixels big
  println(Serial.list()[1]);
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
}
String val;
void draw()
{
  
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    String blah = Arielsthing.rx_headerInter(val, val.length());
    
  }
  else
  {
    //myPort.write("Hello!!!!");
  }
  
}