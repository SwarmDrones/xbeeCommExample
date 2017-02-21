

class Comm
{
  boolean msgInFlag;
  String mIn;
  String mOut;
  byte[] messageOut;
  byte[] messageIn;
  Comm()
  {
      msgInFlag = false;
      mIn = "";
      mOut = "";
  }
  
  public byte[] tx_headerGen(String message, byte sizet)
  { 
      byte nBytes = (byte)(17 + sizet + 1);
      byte[] header = new byte[nBytes] ;
      //start delimeter
      header[0] = (byte)(0x7E);
      
      // size of meassage is in two bytes
      header[1] = (byte)(((nBytes-4) >> 8) & 0xFF);
      header[2] = (byte)((nBytes-4) & 0xFF);
      
      // frame type and id
      header[3] = (byte)(0x10);
      header[4] = (byte)(0x01);

      // destination address
      for(int i = 0; i < 8; i++)
      {
          header[5+i] =(byte)(0x00); 
      }
      header[13]= (byte)(0xFF);
      header[14]= (byte)(0xFE);

      //options
      header[15]= (byte)(0x00);
      header[16]= (byte)(0x00);

      //message
      for(byte i = 0; i < sizet; i++)
      {
          header[17+i] = (byte)message.charAt(i);
          
      }

      // checksum where sum is from frame type to end of rfdata
      byte sum = 0x00;
      byte[] checking = new byte[14+sizet];
      for(int i = 3; i < (17+sizet); i++)
      {
                  checking[i-3] = header[i];
      }
      sum = chksum8(checking, 14 + sizet);
      byte checksum = (byte)(0xFF-sum);
      header[17+sizet]= (checksum);
            
      return header;        

  }



  public String rx_headerInter(String rx_message, int sizet)
  {
              
          
          
      final int dataLen = sizet - 16;// length of data in message
      final int addLen = 10; // length of address
      //int totalLen = (dataLen + addLen +1);
  
      String out = "";
  
      // parsing the address portion in the header
      
      for(int i = 0; i < addLen; i++)
      {
              out+= rx_message.charAt(i+4);
      }
      
      print("out address: ");
      
      println(out);
      
      out += ':';   //out[addLen] = ':';
      // parsing the data portion of the header
      for(int i = 0; i < dataLen; i++)
      {
              out+= rx_message.charAt(i+15);//out[i + addLen] = rx_message[i+16];
      }
      //int total = dataLen + addLen;
      println(out);
      return out;
      
  }
  byte chksum8( byte[] buff, int len)
  {
      byte sum = 0;       // nothing gained in using smaller types!
      for ( int i = 0; i < len; i++)
      {
        sum += buff[i];
      }
             
     return (byte)sum;
   }
}