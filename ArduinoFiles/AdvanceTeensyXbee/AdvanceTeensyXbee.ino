#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>
#include <DroneCom.h>


#define BNO055_SAMPLERATE_DELAY_MS (100)
Adafruit_BNO055 bno = Adafruit_BNO055(55);

DroneCom comm;

String mIn = "";

double ct = 0.00;
double pt = 0.00;
double dt = 0.00;

double roll = 0.00, pitch = 0.00, yaw = 0.00;
double droll = 0.00, dpitch = 0.00, dyaw = 0.00;
double proll = 0.00, ppitch = 0.00, pyaw = 0.00;

void setup()
{
  comm.init();
  if(!bno.begin())
  {
    Serial.print("Ooops, no BNO055 detected ... Check your wiring or I2C ADDR!");
    while(1);
  }
  delay(1000);
  sensor_t sensor;
  bno.getSensor(&sensor);
}

void loop()
{
  ////////////////////////////////// IMU UPDATE PORTION ///////////////////////////////////
  /* Get a new sensor event */
  sensors_event_t event;
  bno.getEvent(&event);
  
  // calculating change in time since last loop
  //pt = ct;
  ct = millis();
  //dt = ct-pt;

  // calculating change in angles since last loop
  proll = roll;
  ppitch = pitch;
  pyaw = yaw;
  roll = event.orientation.z;
  pitch = event.orientation.y;
  yaw = event.orientation.x;
  droll = roll - proll;
  dpitch = pitch - ppitch;
  dyaw = yaw - pyaw;
  ///////////////////////////////////////// END ///////////////////////////////////////////////
  
  ////////////////////////////////// XBEE COMMUNICATION PORTION //////////////////////////////
  //Serial.println("xbee com portion");
  /*if(ct - pt > 10000)
  {
    pt = ct;
    comm.sendOrientation(roll, pitch, yaw);
    Serial.print("outgoing: ");
  }*/
  comm.updateRXMsg();
  if(comm.checkInFlag())
  {
    
      mIn = comm.getMessage();
      Serial.print("incoming: ");
      Serial.println(mIn);
    
  }
  //Serial.println("end of portion");
  /////////////////////////////////////// END ////////////////////////////////////////////////
  //Wait to reduce serial load
  delay(5);
}


/*
char* tx_headerGen(char* message, unsigned int sizet)
{
    unsigned char nBytes = 17 + sizet + 1;
    char *header = new char[nBytes];
    header[0] = 0x7E;
  
    // size of message is two bytes
    header[2] = (unsigned char) ((nBytes-4) & 0xFF);
    header[1] = (unsigned char) (((nBytes-4) >> 8) & 0xFF);
  
    //frame type and id
    header[3] = 0x10;
    header[4] = 0x01;
  
    // destination address
    for(int i = 0; i < 8; i++)
    {
      header[i+5] = 0x00;
    }
    header[13] = 0xFF;
    header[14] = 0xFE;
    // end of both 64 bit and 16 bit addresses
  
    // options
    header[15] = 0x00;
    header[16] = 0x00;
  
    // message
    for(int i = 0; i < sizet; i++)
    {
      header[17+i] = message[i];
    }
  
    // checksum where sum is from frame type to end of rfdata
    unsigned char sum = 0x00;
    unsigned char checking[14+sizet];
    for(int i = 3; i < (3+14+sizet); i++)
    {
          checking[i-3] = header[i];
    }
    sum = chksum8(checking, 14 + sizet);
    unsigned char checksum = (0xFF) - (sum);
    header[17 + sizet] = checksum;

    
    return header;
    String out;
    for(int i = 0; i < 17+sizet; i++)
    {
      out += header[i]; 
    }
}*/



