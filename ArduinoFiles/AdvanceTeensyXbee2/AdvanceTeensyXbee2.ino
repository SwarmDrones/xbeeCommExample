/** 
 *  @author : Ariel Feliz
 *  @date : 2/21/17
 *  @brief : Arduino sketch utilized to have arduino board(teensy3.6) 
 *  manage communication between xbee and Processing
 *  @todo : varify that the data comming in is of the correct frame type 
 *  @todo : varify TCP by looking out for a recieved string with messave number from the teensy. 
*/
//#include <Wire.h>
String mInX = "";// messages comming in throught from xbee
String mOutX = "";// messages going out to xbee

String mInP = ""; // messages comming in from processing
String mOutP = ""; // messages going out to processing

bool rxX = false;
bool txX = false;

bool rxP = false;
bool txP = false;

void setup()
{
  Serial.begin(115200); // Hardware Serial to r/w communication with processing
  Serial1.begin(115200); // Hardware Serial for r/w communication with xbee coordinator modules
}

void loop()
{
  ////////////////////////////////// XBEE COMMUNICATION PORTION //////////////////////////////
  // recieving messages from Processing 
  while(Serial.available())
  {
    mInP += Serial.readString();
    rxP = true;
  }
  // recieving messages from Xbee  
  while(Serial1.available())
  {
    mInX += Serial1.readString();
    rxX = true;
  }
  // check if recieved from xbee
  if(rxX)
  {
    txP = true;
    rxX = false;
  }
  // send out to processing if messaged recieved from xbee
  if(txP)
  {
    txP = false;
    mOutP = mInX;
    Serial.println(mOutP);
  }
  // check if recieved from processing 
  if(rxP)
  {
    rxP = false;
    txX = true; 
  }
  // send out to Xbee if messaged recieved from Processing
  if(txX)
  {
    txX = false;
    mOutX = mInP;
    Serial1.print(mOutP);
  }
  /////////////////////////////////////// END ////////////////////////////////////////////////
  //Wait to reduce serial load
  delay(5);
}



