#include <Servo.h>
#include <ArduinoBLE.h>

// Start - 필요한 경우 각 값을 수정해도 됨 (이 외에는 왠만하면 건드리지 말 것!!!)

#define DEGREE_SERVO_LOCKED 90  // 서보 모터의 각도 (0 ~ 180) - 개폐기가 잠긴 상태
#define DEGREE_SERVO_UNLOCKED 0  // 서보 모터의 각도 - 개폐기가 열린(잠김 해제) 상태
#define DISTANCE_CM_ADMITTING 20  // 거리 감지 센서의 거리 - 쓰레기를 넣었다고 인정하는 거리 (cm 단위)

#define SECONDS_DURATION_PUT_TRASH 10  // 쓰레기 투하를 대기하는 시간 (초 단위)
#define SECONDS_DURATION_AUTH_PHONE 5  // 스마트폰 인증을 기다리는 시간 (초 단위)
#define SECONDS_DURATION_WAIT_DISCONNECT 3  // 스마트폰과의 연결 종료를 대기하는 시간 (초 단위)

// End - 필요한 경우 각 값을 수정해도 됨 (이 외에는 왠만하면 건드리지 말 것!!!)

#define PIN_SERVO 7  // 7번 핀 - 서보 모터
#define PIN_DISTANCE_TRIG 8  // 8번 핀 - 거리 감지 센서 - trig
#define PIN_DISTANCE_ECHO 9  // 9번 핀 - 거리 감지 센서 - echo

#define LOCAL_NAME "ArduinoBLE"  // 기기명 (BLE 연결 시 쓰임)
#define DEVICE_NAME "ArduinoBLE_Device"  // 기기명

#define MAX_BYTES_BLE 20  // BLE로 데이터를 주고받을 때 1회당 최대 bytes (ex: 값이 20이면 1회당 최대 20개의 영문 or 숫자 or 특수문자를 보낼 수 있음)
#define NUM_OF_ALLOWED_CHARS 4
#define MAX_NUM_OF_PARTS_SPLIT 10

#define SERVICE_UUID "19B10000-E8F2-537E-4F6C-D104768A1214"  // 연결을 관리하기 위한 ID
#define CHARACTERISTIC_UUID "19B10001-E8F2-537E-4F6C-D104768A1214"  // 문자를 주고 받기 위한 ID

Servo servo_cover;
char allowingChars[NUM_OF_ALLOWED_CHARS] = { ' ', '_', '[', ']' };
BLEService customService(SERVICE_UUID);  // 연결을 관리하는 객체
BLECharacteristic customCharacteristic(CHARACTERISTIC_UUID, BLERead | BLEWrite | BLENotify, MAX_BYTES_BLE);  // 문자를 주고 받는 객체

//

void setup(){
  // 시리얼 모니터 세팅
  Serial.begin(9600);
  while(!Serial);
  
  // 서보 모터 세팅
  servo_cover.attach(PIN_SERVO);
  servo_cover.write(DEGREE_SERVO_LOCKED);

  // 거리 감지 센서 세팅
  pinMode(PIN_DISTANCE_TRIG, OUTPUT);
  pinMode(PIN_DISTANCE_ECHO, INPUT);

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
}

void loop(){
  BLEDevice central = BLE.central();
  String address = central.address();

  // BLE 연결 요청이 없으면 end
  if(!central){
    return;
  }

  // BLE 연결 요청이 있으면 진행
  Serial.println("스마트폰과 연결!");
  Serial.println("Connected to central: " + address);

  /*
  전송하는 문자열
    "[E]_af_te_" : 인증 실패. 시간 초과.
    "[E]_af_wa_" : 인증 실패. 잘못된 문자열.
    "[E]_as_" : 인증 성공. (쓰레기 투하 팝업 출력)

    "[E]_tf_te_" : 쓰레기 투하 실패. 시간 초과. (인식 실패로 인한 쓰레기 투하 팝업 출력)
    "[E]_ts_" : 쓰레기 투하 성공. (쓰레기통 문 닫으라는 팝업 출력)

    "[E]_ls_" : 개폐기 잠금 성공. (서버한테 쓰레기 배출 성공 사실 알림)
  */


  // 스마트폰 인증
  String disconnectMessage = "";
  bool authenticated = false;
  disconnectMessage = "af_te";

  unsigned long connectedTime = millis();
  unsigned long millis_duration_auth_phone = SECONDS_DURATION_AUTH_PHONE * 1000;

  while(central.connected()) {
    unsigned long now = millis();
    unsigned long elapsedTime = now - connectedTime;

    if(elapsedTime >= millis_duration_auth_phone){  // 제한 시간 안에 인증 못 하면 연결 끊음
      Serial.println("Error: 시간 초과 - 제한 시간 안에 인증 못 함");
      break;
    }

    String receivedMessage = receiveMessage();

    if(receivedMessage == ""){
      continue;
    }


    String parts_receivedMessage[MAX_NUM_OF_PARTS_SPLIT];
    int numOfParts = split(receivedMessage, '_', parts_receivedMessage, MAX_NUM_OF_PARTS_SPLIT);

    if(parts_receivedMessage[0] != "[P]"){
      continue;
    }

    if(parts_receivedMessage[1] == "a"){
      if(numOfParts < 3){
        continue;
      }

      if(parts_receivedMessage[2] != "abc"){  // 인증용 문자열이 서로 다르면 연결 끊음
        disconnectMessage = "af_wa";
        Serial.println("Error: 잘못된 인증 코드");
        break;
      }

      authenticated = true;
      break;
    }
  }


  if(authenticated){
    disconnectMessage = "";
    servo_cover.write(DEGREE_SERVO_UNLOCKED);  // 쓰레기통 개폐기 열기

    Serial.println("인증 성공!");
    sendMessage("as");  // 인증 성공하였으므로 스마트폰에 팝업 띄움
    
    while(central.connected()) {
      // 항상 명령문 받음. 명령문에 따라 다르게 동작.
      String receivedMessage = receiveMessage();

      if(receivedMessage == ""){
        continue;
      }
      

      String parts_receivedMessage[MAX_NUM_OF_PARTS_SPLIT];
      int numOfParts = split(receivedMessage, '_', parts_receivedMessage, MAX_NUM_OF_PARTS_SPLIT);

      if(parts_receivedMessage[0] != "[P]"){
        continue;
      }

      if(parts_receivedMessage[1] == "t"){  // 거리 감지 센서에 접근한 후 제한 시간 동안 쓰레기를 넣었는지 체크함
        unsigned long openedTime = millis();
        unsigned long millis_duration_put_trash = SECONDS_DURATION_PUT_TRASH * 1000;
        bool success = false;
        Serial.println("제한 시간 동안만 쓰레기 넣었는지 체크");

        while(true){
          unsigned long now = millis();
          unsigned long elapsedTime = now - openedTime;

          if(elapsedTime >= millis_duration_put_trash){  // 제한 시간 안에 쓰레기 넣지 않으면 빠져나옴.
            break;
          }

          if(elapsedTime % 100 != 0){  // 0.1초마다 거리 감지 센서로 접근. 이렇게 해주지 않으면 제대로 동작 안함.
            continue;
          }

          digitalWrite(PIN_DISTANCE_TRIG, LOW);
          delayMicroseconds(2);
          digitalWrite(PIN_DISTANCE_TRIG, HIGH);
          delayMicroseconds(10);
          digitalWrite(PIN_DISTANCE_TRIG, LOW);

          long duration = pulseIn(PIN_DISTANCE_ECHO, PIN_DISTANCE_TRIG);
          long distanceCm = duration * 17 / 1000;
          //Serial.println(distanceCm);
          //Serial.println(" cm");

          if(distanceCm < DISTANCE_CM_ADMITTING){  // 제한 시간 안에 쓰레기 넣으면 표시 후 빠져나옴.
            success = true;
            break;
          }
        }

        if(success){  // 제한 시간 안에 쓰레기 넣었다고 알림
          sendMessage("ts");
          Serial.println("쓰레기 투하 감지!");
        }
        else{  // 제한 시간 안에 쓰레기 넣지 못 했다고 알림
          sendMessage("tf_te");
          Serial.println("Error: 시간 초과 - 제한 시간 안에 쓰레기 넣지 않음");
        }        
      }
      else if(parts_receivedMessage[1] == "l"){  // 개폐기를 잠금
        servo_cover.write(DEGREE_SERVO_LOCKED);
        Serial.println("개폐기 잠금 완료!");

        disconnectMessage = "ls";  // 개폐기를 잠궜다고 알림
        break;
      }
    }
  }


  // 연결 끊기 (서로 신호 보냄)

  if(central.connected()){
    sendMessage(disconnectMessage);

    unsigned long disconnectedTime = millis();
    unsigned long millis_duration_wait_disconnect = SECONDS_DURATION_WAIT_DISCONNECT * 1000;
    
    while(central.connected()) {
      unsigned long now = millis();
      unsigned long elapsedTime = now - disconnectedTime;

      if(elapsedTime >= millis_duration_wait_disconnect){
        break;
      }
      
      String receivedMessage = receiveMessage();

      if(receivedMessage == ""){
        continue;
      }

      
      String parts_receivedMessage[MAX_NUM_OF_PARTS_SPLIT];
      int numOfParts = split(receivedMessage, '_', parts_receivedMessage, MAX_NUM_OF_PARTS_SPLIT);

      if(parts_receivedMessage[0] != "[P]"){
        continue;
      }

      if(parts_receivedMessage[1] == "d"){
        Serial.println("연결 종료 신호 주고 받음");
        break;
      }
    }
  }

  central.disconnect();
  Serial.println("스마트폰과 연결 종료");
  Serial.println("Disconnected from central: " + address + "\n");
}

//

bool sendMessage(String message){
  bool result = false;
  message = "[E]_" + message + "_";
  customCharacteristic.writeValue(message.c_str());

  Serial.println("Sent: " + message);
  result = true;
  return result;
}

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

  while((delimIndex = input.indexOf(delimiter, startIndex)) != -1) {
    if (count >= maxParts) break;
    result[count++] = input.substring(startIndex, delimIndex);
    startIndex = delimIndex + 1;
  }

  if (count < maxParts && startIndex < input.length()) {
    result[count++] = input.substring(startIndex);
  }

  return count;
}