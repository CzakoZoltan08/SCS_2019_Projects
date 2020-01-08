#include <ETH.h>
#include <ESPmDNS.h>

#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiUdp.h>

#include <WebServer.h>

#include <HTTPClient.h>
#include <HTTPUpdate.h>
#include <Update.h>


#define DEVICE_CONNECTED     1    
#define DEVICE_NOT_CONNECTED 0

#define AVAILABLE            1
#define BLOCKED              0

WiFiUDP UDP;

//Communication port for the running local server is 80
WebServer server(80);

unsigned int UDPPortListen     = 44398; // local port to listen on
unsigned int UDPPortSend       = 44399; // local port to send HTTP MAC response
const    int pulseInSec        = 2000;  // was 5000
unsigned int presenceDetection = 0;

const String keyUDP           = "iPark_TNT_Server";
char         packetBuffer[255];                      // buffer to hold incoming packet
uint8_t      replyBuffer[9]   = "Hi Luci!";          // a string to send back

static bool deviceStatus = DEVICE_NOT_CONNECTED;
static bool ETHConnected = false;

String versio = "| iBariera ver. 1.01 | TNT Computers SRL | www.tntcomputers.ro | office@tntcomputers.ro |";

//WiFi Requirements
//const char* ssid     = "BT_HQ1";
//const char* password = "Synapticlab01";

//Unimplemented server -> still testing...
const String serverName   = "http://192.168.1.177/cmd";      
const String serverUpdate = "http://tntcomputers.ro/iot/update/iBariere.ino.generic.bin"; 

//The two Olimex relays are on the following pins 32 and 33
const uint8_t PIN_OPEN_GATE  = 32;
const uint8_t PIN_CLOSE_GATE = 33;

//Input pins for detecting a car
const uint8_t PIN_INPUT_DETECTOR_ENTER = 12;
const uint8_t PIN_INPUT_DETECTOR_LEAVE = 27;

//Pins for the buttons
const uint8_t BUTTON_TICKET = 34;
const uint8_t BUTTON_INFO   = 5;

uint8_t ticketButtonStatus = 0;
uint8_t infoButtonStatus   = 0;

volatile bool validEntrance = false;
volatile bool validLeave    = false;

volatile bool ticketState = AVAILABLE;
volatile bool infoState   = AVAILABLE;

//Pins for the scanner
const uint8_t PIN_SCANNER_RX = 36;
const uint8_t PIN_SCANNER_TX =  4;

//Pins for the RFID
const uint8_t PIN_RFID_RX = 13;
const uint8_t PIN_RFID_TX = 16;

char   incomingByte;
String readBarCode, barCode;

/*
 * Login page
 */

const char* loginIndex = 
 "<form name='loginForm'>"
    "<table width='20%' bgcolor='A09F9F' align='center'>"
        "<tr>"
            "<td colspan=2>"
                "<center><font size=4><b>ESP32 Login Page</b></font></center>"
                "<br>"
            "</td>"
            "<br>"
            "<br>"
        "</tr>"
        "<td>Username:</td>"
        "<td><input type='text' size=25 name='userid'><br></td>"
        "</tr>"
        "<br>"
        "<br>"
        "<tr>"
            "<td>Password:</td>"
            "<td><input type='Password' size=25 name='pwd'><br></td>"
            "<br>"
            "<br>"
        "</tr>"
        "<tr>"
            "<td><input type='submit' onclick='check(this.form)' value='Login'></td>"
        "</tr>"
    "</table>"
"</form>"
"<script>"
    "function check(form)"
    "{"
      "if(form.userid.value=='admin' && form.pwd.value=='admin')"
      "{"
        "window.open('/serverIndex')"
      "}"
      "else"
      "{"
        " alert('Error Password or Username')/*displays error message*/"
      "}"
    "}"
"</script>";

/*
 * Server Index Page
 */

const char* serverIndex = 
"<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>"
"<form method='POST' action='#' enctype='multipart/form-data' id='upload_form'>"
   "<input type='file' name='update'>"
        "<input type='submit' value='Update'>"
    "</form>"
 "<div id='prg'>progress: 0%</div>"
 "<script>"
    "$('form').submit(function(e){"
      "e.preventDefault();"
      "var form = $('#upload_form')[0];"
      "var data = new FormData(form);"
      " $.ajax({"
        "url: '/update',"
        "type: 'POST',"
        "data: data,"
        "contentType: false,"
        "processData:false,"
        "xhr: function() {"
          "var xhr = new window.XMLHttpRequest();"
          "xhr.upload.addEventListener('progress', function(evt) {"
            "if (evt.lengthComputable) {"
              "var per = evt.loaded / evt.total;"
              "$('#prg').html('progress: ' + Math.round(per*100) + '%');"
            "}"
          "}, false);"
          "return xhr;"
        "},"
        "success:function(d, s) {"
          "console.log('success!')" 
        "},"
        "error: function (a, b, c) {"
        "}"
      "});"
    "});"
 "</script>";
 
/*
 * giveBarCode...
 */

void giveBarCode()
{
  server.send(200, "text/plain", barCode);
  Serial.print("\n");
}

/*
 * giveClientIP...
 */
 
void giveClientIP()
{
  Serial.print(server.client().remoteIP());
  Serial.print("\n");
}

/*
 * getClientIp...
 */

void getClientIp()
{
  Serial.print("\nServer: I got a request from client with IP: ");
  
  Serial.print(server.client().remoteIP());
  Serial.print("\n");
  
  server.send(200, "text/plain", "Server: I got the client's IP.");
}

/*
 * blockButtons...
 */

void blockButtons()
{
  pinMode(BUTTON_TICKET, OUTPUT);
  digitalWrite(BUTTON_TICKET, HIGH);

  pinMode(BUTTON_INFO, OUTPUT);
  digitalWrite(BUTTON_INFO, HIGH);
  
  ticketState = BLOCKED;
  infoState   = BLOCKED;

  Serial.println("\nButtons DISABLED!");
  Serial.println("");
}

/*
 * enableButtons...
 */

void enableButtons()
{
  pinMode(BUTTON_TICKET, INPUT);
  pinMode(BUTTON_INFO, INPUT);
  
  ticketState = AVAILABLE;
  infoState   = AVAILABLE;

  Serial.println("\nButtons ENABLED!");
  Serial.println("");
}

/*
 * openGate...
 */

void openGate()
{
  digitalWrite(PIN_OPEN_GATE, 1);
  
  Serial.print("\nEndpoint: /open by: ");
  giveClientIP();
  
  server.send(200, "text/plain", "I opened the gate.");
  
  delay(pulseInSec);
  
  digitalWrite(PIN_OPEN_GATE, 0);

  validEntrance = true;
  
  blockButtons(); 
}

/*
 * closeGate...
 */

void closeGate()
{
    digitalWrite(PIN_CLOSE_GATE, 1);

    Serial.print("\nEndpoint: /close by:");
    giveClientIP();
  
    server.send(200, "text/plain", "I closed the gate.");
  
    delay(pulseInSec);
  
    digitalWrite(PIN_CLOSE_GATE, 0);

    validLeave = true;
  
    enableButtons();
}

/*
 * handleRoot...
 */

void handleRoot() 
{
  //server.send(200, "text/plain", versio);
  
  server.send(200, "text/plain", ETH.localIP().toString());
  
  server.send(200, "text/plain", "\nServer: Resolved by my mDNS");
}

/*
 * getID...
 */
 
void getID() 
{
  digitalWrite(PIN_OPEN_GATE, 1);
  
  Serial.print("\nEndpoint: /id accesed by:");
  giveClientIP();
  
  server.send(200, "text/plain", "Hello, you received my ID!");
  
  delay(pulseInSec);
  
  digitalWrite(PIN_OPEN_GATE, 0);
}

/*
 * handleNotFound...
 */
 
void handleNotFound() 
{
  String message = "Command Not Found\n\n";
  
  message += "URI: ";
  message += server.uri();
  
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET) ? "GET" : "POST";
  
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  
  for (uint8_t i = 0; i < server.args(); i++) 
  {
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  
  server.send(404, "text/plain", message);
}

/*
 * runningUpdateFirmware...
 */
 
void runningUpdateFirmware()
{
   /*return index page which is stored in serverIndex */
   
  server.on("/", HTTP_GET, 
  []() 
  {
    server.sendHeader("Connection", "close");	
    server.send(200, "text/html", loginIndex);
  });
  
  server.on("/serverIndex", HTTP_GET, 
  []() 
  {
    server.sendHeader("Connection", "close");
    server.send(200, "text/html", serverIndex);
  });

  /*handling uploading firmware file */
  
  server.on("/update", HTTP_POST, 
	[]() 
	{
		server.sendHeader("Connection", "close");	
		server.send(200, "text/plain", (Update.hasError()) ? "FAIL" : "OK");
		
		ESP.restart();
	}, 
	[]() 
	{
		HTTPUpload& upload = server.upload();
		
		if (upload.status == UPLOAD_FILE_START) 
		{
			Serial.printf("Update: %s\n", upload.filename.c_str());
			
			if (!Update.begin(UPDATE_SIZE_UNKNOWN)) 
			{ 
				//start with max available size
				Update.printError(Serial);
			}
		} 
		else if (upload.status == UPLOAD_FILE_WRITE) 
		{
			/* flashing firmware to ESP*/
			if (Update.write(upload.buf, upload.currentSize) != upload.currentSize) 
			{
				Update.printError(Serial);
			}
		} 
		else if (upload.status == UPLOAD_FILE_END) 
		{
			if (Update.end(true)) 
			{ 
				//true to set the size to the current progress
				Serial.printf("Update Success: %u\nRebooting...\n", upload.totalSize);
			} 
			else 
			{
				Update.printError(Serial);
			}
		}
  });
}

/*
 * startHTTPServer...
 */
 
void startHTTPServer()
{
  server.on("/", handleRoot);
  
  //server.send(200, "text/plain", version);  
  
  server.on("/open"    , openGate); 
  server.on("/close"   , closeGate);
  server.on("/scan"    , closeGate);
  server.on("/show"    , closeGate);
  server.on("/id"      , getID);
  server.on("/clientip", giveClientIP);
  server.on("/barcode" , giveBarCode);
  
  server.onNotFound(handleNotFound);
  
  server.begin();
    
  Serial.println("HTTP server opened!");
} 

/*
 * WiFiEvent...
 */
 
void WiFiEvent(WiFiEvent_t event)
{
  switch (event) 
  {
    case SYSTEM_EVENT_ETH_START:
      Serial.println("ETH Started");
      //set eth hostname here
      ETH.setHostname("ESP32-Ethernet");
      break;
	  
    case SYSTEM_EVENT_ETH_CONNECTED:
      Serial.println("ETH Connected");
      break;
	  
    case SYSTEM_EVENT_ETH_GOT_IP:
      Serial.print("ETH MAC: ");
      Serial.print(ETH.macAddress());
	  
      Serial.print(", IPv4: ");
      Serial.print(ETH.localIP());
	  
      if (ETH.fullDuplex()) 
	  {
        Serial.print(", FULL_DUPLEX");
      }
      Serial.print(", ");
	  
      Serial.print(ETH.linkSpeed());
      Serial.println("Mbps");
	  
      ETHConnected = true;
      break;
	  
    case SYSTEM_EVENT_ETH_DISCONNECTED:
      Serial.println("ETH Disconnected");
	  
      ETHConnected = false;
	  
      deviceStatus = DEVICE_NOT_CONNECTED;
      break;
	  
    case SYSTEM_EVENT_ETH_STOP:
      Serial.println("ETH Stopped");
	  
      ETHConnected = false;
	  
      deviceStatus = DEVICE_NOT_CONNECTED;
      break;
	  
    default:
      break;
  }
}

/*
 * UDPHandling...
 */
 
void UDPHandling() //checks if there is an UDP broadcast and handles it
{
  // if there's data available, read a packet
  int packetSize = UDP.parsePacket();
  
  if(packetSize) 
  {
    Serial.print("Received packet of size ");
    Serial.println(packetSize);
    
    Serial.print("From ");
    IPAddress remoteIp = UDP.remoteIP();
    Serial.print(remoteIp);
    
    Serial.print(", port ");
    Serial.println(UDP.remotePort());

    // read the packet into packetBufffer
    int len = UDP.read(packetBuffer, 255);
    
    if (len > 0) 
    {
      packetBuffer[len] = 0;
    }
    
    Serial.println("Contents:");
    Serial.println(packetBuffer);

    String packetBuff(packetBuffer); //converting to string to check with the key of the UDP payload
    String returnAddress = UDPResponseBuild();

    if(packetBuff == keyUDP) //checks if the UDP payload is the one expected 
    {
      HTTPSendMAC(returnAddress); //sending http response with device MAC 
      deviceStatus = DEVICE_CONNECTED;
    } 
  }
}

/*
 * HTTPSendMAC...
 * function that sends the MAC to the server via HTTP
 */
 
void HTTPSendMAC(String hostName) 
{
  HTTPClient HTTP;

  Serial.print("[HTTP] begin... \n");
  HTTP.begin(hostName); //HTTP  hostName
  
  Serial.print("[HTTP] GET... \n");
  int HTTPCode = HTTP.GET();
  Serial.println(HTTPCode);
  
  if(HTTPCode > 0)
  {
    Serial.printf("[HTTP] GET... code %d\n", HTTPCode);
    if(HTTPCode == 302) //HTTP_CODE_OK
    {
      String payload = "TRĂIASCĂ POPORUL ROMÂN!"; //HTTP.getString();
      Serial.println(payload);
    }
    if(HTTPCode == HTTP_CODE_OK)
    {
      String payload = HTTP.getString(); //will be used later 
      Serial.println(payload);
    }
    else
    {
      Serial.printf("[HTTP] GET... failed, error: %s\n", HTTP.errorToString(HTTPCode).c_str()); //for 404 error
    } 
    HTTP.end();
  }
  Serial.println("Here I should respond to the server/Luci!"); //debug
}

/*
 * UDPResponseBuild...
 * function that prepares the string for the HTTP response after UDP broadcast
 */
 
String UDPResponseBuild()
{
  String IPServer = UDP.remoteIP().toString(); //Constructing return address for response
  
  String returnAddress = "http://" + IPServer +":" + UDPPortSend + "/Barriers/Register/?MAC=" + ETH.macAddress();
  
  Serial.println("The return address with endpoint as STRING is:" + returnAddress); //debug

  return returnAddress; 
}

/*
 * handleDetectionEnter...
 */
 
bool handleDetectionEnter()
{
  uint8_t buttonStateForEnter = digitalRead(PIN_INPUT_DETECTOR_ENTER);
  
  if(buttonStateForEnter == 1)
  {
    Serial.println("\nA car is present at entrance!");
    return true;
  }
  else 
  {
    Serial.println("\nWaiting for a car at entrance!");
    return false;
  }
}

/*
 * handleDetectionLeave...
 */
 
bool handleDetectionLeave()
{
  uint8_t buttonStateForLeave = digitalRead(PIN_INPUT_DETECTOR_LEAVE);

  if(buttonStateForLeave == 1)
  {
    Serial.println("\nA car is present at leave!");
    return true;
  }
  else 
  {
    Serial.println("\nWaiting for a car at leave!\n");
    return false;
  }
}

/*
 * handleButtonTicket...
 * 
 * This button is normally closed, in this code it means that the button
 * was pushed when his state is active low.
 * 
 * His state is affected by the delay set in loop(), meaning that if
 * the button is not hold pushed down at least the delay period the
 * button changed state won't be recognized by Olimex.
 * 
 * Once can change the delay period in order to make more responsive.
 * 
 * The button is responsive only if Olimex knows that a car is waiting at entrance.
 */
 
void handleButtonTicket()
{
  while(handleDetectionEnter() == true)
  {
    if(ticketState == AVAILABLE)
    {
      Serial.println("Button for ticket is allowed to be pressed."); 
	  
      ticketButtonStatus = digitalRead(BUTTON_TICKET); //takes value of the button
	  
      if (ticketButtonStatus == LOW) // check if the input is LOW (button pressed)
      {         
        Serial.print("\nButton for ticket PRESSED!\n");
        //need to send request to server for a ticket
      }
      else
      {
        Serial.println("Button for ticket was NOT PRESSED!");
        Serial.println("");
      }
    }
    else
    {
      Serial.println("Button for ticket is NOT allowed to be pressed.");
      Serial.println("");
    }
    
    break;
  }
}

/*
 * handleButtonInfo...
 * 
 * This button is normally open, in this code it means that the button
 * was pushed when his state is active high.
 * 
 * His state is affected by the delay set in loop(), meaning that if
 * the button is not hold pushed down at least the delay period the
 * button changed state won't be recognized by Olimex.
 * 
 * Once can change the delay period in order to make more responsive.
 * 
 * The button is responsive only if Olimex knows that a car is waiting at entrance.
 */

void handleButtonInfo()
{
  while(handleDetectionEnter() == true) //try with if!!!!
  {
    if(infoState == AVAILABLE)
    {
      Serial.println("Button for info is allowed to be pressed.");
       
      infoButtonStatus = digitalRead(BUTTON_INFO); //takes value of the button
	  
      if (infoButtonStatus == HIGH)// check if the input is LOW (button pressed)
      {         
        Serial.print("\nButton for info PRESSED, info REQUIRED!\n");
        
        server.send(200, "text/plain", "Request for information!");
      }
      else
      {
        Serial.println("Button for info was NOT PRESSED!");
        Serial.println("");
      }
    }
    else
    {
      Serial.println("Button for info is NOT allowed to be pressed.");
      Serial.println(""); 
    }
    
    break;
  }
}

/*
 * handleScanner...
 */

void handleScanner()
{
  while(Serial1.available())
  {
    incomingByte = Serial1.read();

    readBarCode += incomingByte;

    if(incomingByte == '\r')
    {
      Serial.println("\nOlimex: I got the Scanner Bar Code --> ");
      Serial.print(readBarCode + "\n\n");
      Serial.flush();

      barCode = readBarCode;

      Serial.print(barCode + "\n\n");
      readBarCode = "";
    }
  }
  
}


void handleRFID()
{
  while(Serial2.available())
  {
    incomingByte = Serial2.read();

    readBarCode += incomingByte;

    if(incomingByte == '\r')
    {
      Serial.println("\nOlimex: I got the RFID Bar Code --> ");
      Serial.print(readBarCode + "\n\n");
      Serial.flush();

      barCode = readBarCode;

      Serial.print(barCode + "\n\n");
      readBarCode = "";
    }
  }
  
}


void setup() 
{
  Serial.begin(9600);

  //Serial communication through Olimex and the Scanner
  Serial1.begin(2400, SERIAL_8N1, PIN_SCANNER_RX, PIN_SCANNER_TX);
  
  //Serial communication through Olimex and the RFID
  Serial2.begin(57600, SERIAL_8N1, PIN_RFID_RX, PIN_RFID_TX);

  pinMode(PIN_CLOSE_GATE , OUTPUT);
  digitalWrite(PIN_CLOSE_GATE , 0);
  
  pinMode(PIN_OPEN_GATE  , OUTPUT);
  digitalWrite(PIN_OPEN_GATE  , 0);

  pinMode(PIN_INPUT_DETECTOR_ENTER , INPUT);
  pinMode(PIN_INPUT_DETECTOR_LEAVE , INPUT);

  pinMode(BUTTON_TICKET , INPUT); 
  pinMode(BUTTON_INFO   , INPUT);

  runningUpdateFirmware();	
  
  Serial.print("IP Address: ");
  Serial.println(ETH.localIP());
  
  Serial.println("MAC Address: ");
  Serial.println(ETH.macAddress());
  
  WiFi.onEvent(WiFiEvent);
  
  ETH.begin();

  startHTTPServer();
  
  UDP.begin(UDPPortListen);
  
  Serial.println("Finished the setup!");
}


void loop() 
{   
  server.handleClient();
  
  handleButtonTicket();
  handleButtonInfo();
  
  handleScanner();
  
  handleRFID();
  
  handleDetectionLeave();
  
  if (ETHConnected) 
  {
    if(deviceStatus == DEVICE_NOT_CONNECTED)
    {
      UDPHandling();
    }
  }
  
  Serial.println("My IP is: ...");
  Serial.println(ETH.localIP());
  
  delay(1000);
}
