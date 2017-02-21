import processing.serial.*;

Serial myPort;  // Create object from Serial class

void setup() 
{
  size(200,200); //make our canvas 200 x 200 pixels big
  println(Serial.list()[2]);
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
}

String val;
byte[] message;
byte[] messageLength = new byte[2];
int totalLength;
int dataLength;
byte frameType;
byte[] sourceAddress64 = new byte[8];
byte[] sourceAddress16 = new byte[2];
byte recieveOptions;
byte[] data;
byte checksum;
void parsePackets()
{
  
  if ( myPort.available() > 0) 
  {  // If data is available,
    //START DELIMETER
    myPort.readBytes(1);
    //LENGTH
    messageLength = myPort.readBytes(2);
    totalLength = int(messageLength[0]) << 4;
    totalLength += int(messageLength[1]);
    dataLength = totalLength - 13; //00 0C by default, no message
    
    //Frame Type
    frameType = myPort.readBytes(1)[0];
    
    //Source Address 64 bit
    sourceAddress64 = myPort.readBytes(8);
    
    //Source Address 16 bit
    sourceAddress64 = myPort.readBytes(2);
    
    //Recieve options
    recieveOptions = myPort.readBytes(1)[0];
    
    //Total packet data
    data = myPort.readBytes(dataLength);
    
    //Checksum
    checksum = myPort.readBytes(1)[0];
    
    String message = new String(data);
  }
  else
  {
    //myPort.write("Hello!!!!");
  }
  
}

//http://knowledge.digi.com/articles/Knowledge_Base_Article/Calculating-the-Checksum-of-an-API-Packet
byte checksum(byte[] message, int length)
{
  byte sum = 0;
  for (int i = 3; i <length; i ++)
  {
    sum += message[i]; 
  }
  sum = byte(0xFF - sum);
  return sum;
}