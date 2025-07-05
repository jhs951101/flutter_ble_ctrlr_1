#include <Servo.h>
#include <ArduinoBLE.h>

#define PIN_BASIC_LED1 3  // 3번 핀 - 기본 LED1
#define PIN_BASIC_LED2 4  // 4번 핀 - 기본 LED2
#define PIN_SERVO 6  // 6번 핀 - 서보 모터

#define LOCAL_NAME "A"  // 기기명 (BLE 연결 시 쓰임)
#define DEVICE_NAME "AD"  // 기기명

#define MAX_BYTES_BLE 20  // BLE로 데이터를 주고받을 때 1회당 최대 bytes (ex: 값이 20이면 1회당 최대 20개의 영문 or 숫자 or 특수문자를 보낼 수 있음)
#define NUM_OF_ALLOWED_CHARS 4
#define MAX_NUM_OF_PARTS_SPLIT 10

#define UUID_SERVICE "19B10000-E8F2-537E-4F6C-D104768A1212"  // 연결을 관리하기 위한 UUID 중 일부 (맨 앞, 맨 뒤, 문자 제외)
#define UUID_CHAR "19B10001-E8F2-537E-4F6C-D104768A1212"  // 문자를 주고 받기 위한 UUID 중 일부 (맨 앞, 맨 뒤, 문자 제외)

String operationType = "";
char allowingChars[NUM_OF_ALLOWED_CHARS] = { ' ', '_', '[', ']' };

Servo servo_cover;
BLEService customService(UUID_SERVICE);  // 연결을 관리하는 객체
BLECharacteristic customCharacteristic(UUID_CHAR, BLERead | BLEWrite | BLENotify, MAX_BYTES_BLE);  // 문자를 주고 받는 객체

//

void setup(){
  // 시리얼 모니터 세팅
  Serial.begin(9600);
  while(!Serial);
  
  // LED 세팅
  pinMode(PIN_BASIC_LED1, OUTPUT);
  pinMode(PIN_BASIC_LED2, OUTPUT);
  
  // 서보 모터 세팅
  servo_cover.attach(PIN_SERVO);

  // BLE 세팅
  if(!BLE.begin()){
    Serial.println("Error: Setting BLE failed! \n");
    while(1);
  }

  BLE.setLocalName(LOCAL_NAME);
  BLE.setDeviceName(DEVICE_NAME);
  BLE.setAdvertisedService(customService);

  customService.addCharacteristic(customCharacteristic);
  BLE.addService(customService);

  Serial.println("BLE device is now advertising \n");
  BLE.advertise();

  // 모두 초기화
  initialize();
}

void loop(){
  // BLE 연결 요청이 있는지 항상 확인
  BLEDevice central = BLE.central();
  String address = central.address();

  if(!central){
    return;
  }

  // BLE 연결 요청이 있으면 진행
  operationType = "A";
  Serial.println("Connected to central: " + address);

  while(central.connected()) {
    String receivedMessage = receiveMessage();

    if(receivedMessage != ""){
      String parts_receivedMessage[MAX_NUM_OF_PARTS_SPLIT];
      int numOfParts = split(receivedMessage, '_', parts_receivedMessage, MAX_NUM_OF_PARTS_SPLIT);

      if(parts_receivedMessage[0] == "[P]"){
        if(parts_receivedMessage[1] == "d"){  // 연결 해제 요청 시 연결 끊음
          break;
        }

        if(parts_receivedMessage[1] == "c"){  // 동작 유형 변경 요청을 받으면
          if(numOfParts >= 3){
            initialize();
            String type = parts_receivedMessage[2];
            operationType = type;
            Serial.println("type: " + type);
          }
        }
      }
    }
    
    execute();
  }

  // BLE 연결 종료
  central.disconnect();
  initialize();
  Serial.println("Disconnected from central: " + address + "\n");
}

//

void initialize(){
  operationType = "";
  digitalWrite(PIN_BASIC_LED1, LOW);
  digitalWrite(PIN_BASIC_LED2, LOW);
  servo_cover.write(0);
}

void execute(){
  if(operationType == ""){
    return;
  }
  
  if(operationType == "A"){
    digitalWrite(PIN_BASIC_LED1, HIGH);
    digitalWrite(PIN_BASIC_LED2, HIGH);
  }
  else if(operationType == "B"){
    digitalWrite(PIN_BASIC_LED1, HIGH);
    digitalWrite(PIN_BASIC_LED2, LOW);
    delay(100);

    digitalWrite(PIN_BASIC_LED1, LOW);
    digitalWrite(PIN_BASIC_LED2, HIGH);
    delay(100);
  }
}

/*
bool sendMessage(String message){
  bool result = false;
  message = "[E]_" + message + "_";
  customCharacteristic.writeValue(message.c_str());

  Serial.println("Sent: " + message);
  result = true;
  return result;
}
*/

String receiveMessage(){
  String result = "";

  if(!customCharacteristic.written()){
    return result;
  }

  const uint8_t * message_uint8t_arr = customCharacteristic.value();
  const char* message_char_arr = (const char*)message_uint8t_arr;
  String message_str(message_char_arr);
  String receivedMessage = "";

  for(int a=0; a<message_str.length(); a++){
    char c1 = message_str.charAt(a);
    bool allowedChar = false;

    if(c1 >= 'a' && c1 <= 'z'){
      allowedChar = true;
    }
    else if(c1 >= 'A' && c1 <= 'Z'){
      allowedChar = true;
    }
    else if(c1 >= '0' && c1 <= '9'){
      allowedChar = true;
    }
    else{
      for(int b=0; b<NUM_OF_ALLOWED_CHARS; b++){
        char c2 = allowingChars[b];

        if(c1 == c2){
          allowedChar = true;
          break;
        }
      }
    }

    if(allowedChar){
      receivedMessage += c1;
    }
  }

  String parts_receivedMessage[MAX_NUM_OF_PARTS_SPLIT];
  int numOfParts = split(receivedMessage, '_', parts_receivedMessage, MAX_NUM_OF_PARTS_SPLIT);

  if(numOfParts < 2){
    return result;
  }

  result = receivedMessage;
  Serial.println("Received: " + receivedMessage);
  return result;
}

//

int split(String input, char delimiter, String result[], int maxParts) {
  int count = 0;
  int startIndex = 0;
  int delimIndex;

  while ((delimIndex = input.indexOf(delimiter, startIndex)) != -1) {
    if (count >= maxParts) break;
    result[count++] = input.substring(startIndex, delimIndex);
    startIndex = delimIndex + 1;
  }

  if (count < maxParts && startIndex < input.length()) {
    result[count++] = input.substring(startIndex);
  }

  return count;
}