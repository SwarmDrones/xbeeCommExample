bool verifyIncoming(String header)
    {
        // checksum where sum is from frame type to end of rfdata
        //Serial.println("verifyIncoming: ");
        /*for(int i = 0; i < header.length(); i++)
        {
            Serial.print(header[i], HEX);
            Serial.print(" ");
        }*/*
        
        uint8_t sum = 0x00;
        //Serial.println("");
        uint8_t checking[header.length()-3];
        for(int i = 0; i < (header.length()-3); i++)
        {
                checking[i] = header[i+2];
                //Serial.print(checking[i], HEX);
                //Serial.print(" ");
        }
        //Serial.println("");
        sum = chksum8(checking, header.length()-3);
        uint8_t checksum = (0xFF) - (sum);
        //Serial.print(checksum, HEX);
        //Serial.print(" == ");
        //Serial.print(header[header.length()-1], HEX);
        //Serial.println("");
        if(header[header.length()-1]== (checksum))
        {
            return true;
            //Serial.println("true message");
        }
        else 
        {
            msgInFlag = false;
            Serial.println("false message");
            return false;
        }
    }