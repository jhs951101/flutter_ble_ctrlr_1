import 'dart:async';
import 'dart:convert';
import 'package:arduino_ble_controller1/the_others/config/config.dart';
import 'package:arduino_ble_controller1/the_others/controller/controller.dart';
import 'package:arduino_ble_controller1/the_others/widget/widget.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BodyItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDropdownButton(
                  values: _controller.numbers,
                  selectedValue: _controller.selectedStartNumber,
                ),

                CustomDropdownButton(
                  values: _controller.numbers,
                  selectedValue: _controller.selectedEndNumber,
                ),
              ],
            ),
          ),

          BodyItem(
            top: 20,
            child: Obx((){
              return CustomElevatedButton(
                title: 'Connect',
                onTap:
                  _controller.connected.value
                  ? null
                  : (){
                    _controller.connected.value = true;  // 임시 방편
                  },
              );
            }),
          ),

          BodyItem(
            child: CustomDivider(),
          ),

          const Gap(10),

          Obx((){
            bool connected = _controller.connected.value;

            return Column(
              children: [
                BodyItem(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'LED Mode 1',
                          onTap:
                            connected
                            ? (){
                              //
                            }
                            : null,
                        ),
                      ),

                      const Gap(10),

                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'LED Mode 2',
                          color: CustomColor.secondary,
                          onTap:
                            connected
                            ? (){
                              //
                            }
                            : null,
                        ),
                      ),
                    ],
                  ),
                ),

                BodyItem(
                  child: CustomElevatedButton(
                    title: 'Disconnect',
                    color: Color(0xFF777777),
                    onTap:
                      connected
                      ? (){
                        _controller.connected.value = false;  // 임시 방편
                      }
                      : null,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class HomeController extends GetxController {
  final List<String> numbers = [AppConfig().defaultValue_dropdownButton, '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',];

  RxBool connected = false.obs;
  RxString selectedStartNumber = AppConfig().defaultValue_dropdownButton.obs;
  RxString selectedEndNumber = AppConfig().defaultValue_dropdownButton.obs;

  //

  @override
  void onReady(){
    super.onReady();
    //
  }

  //
}

class QrBleAuthenticator {
  final int maxBytes_BLE = 20;

  late DiscoveredDevice device;
  late QualifiedCharacteristic rxChar;
  late Stream<ConnectionStateUpdate> connection;
  late StreamSubscription<DiscoveredDevice> scanStream;
  
  //

  bool connected = false;
  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();

  String? deviceName;
  Uuid? serviceUuid;
  Uuid? charUuid;

  Function(Map<String, dynamic>? data)? _onSuccess;
  Function(String? errorMsg)? _onFailed;
  
  //
  
  DialogController dialogController = DialogController();
  
  //

  void authenticateQrBle(
    {
      Function(Map<String, dynamic>? data)? onSuccess,
      Function(String? message)? onFailed,
    }
  ){
    _onSuccess = onSuccess;
    _onFailed = onFailed;

    flutterReactiveBle.statusStream.listen(
      (status){
        if(status == BleStatus.unknown){
          return;
        }

        _authenticateQrBle_statusConfirmed(status);
      },
    );
  }

  void _authenticateQrBle_statusConfirmed(BleStatus status){
    //print('--- status: ${status}');

    if(status == BleStatus.unauthorized){
      dialogController.showAlertDialog(
        title: '블루투스 권한 미허용',
        contents: '블루투스 권한을 허용해야 합니다.',
      );

      AppConfig().essentialPermissions.request();
      return;
    }
    else if(status == BleStatus.poweredOff){
      dialogController.showAlertDialog(
        title: '블루투스 꺼짐',
        contents: '현재 블루투스가 꺼진 상태입니다.'
          + '\n' + '켠 후 다시 이용하십시오.',
      );
      return;
    }

    _authenticateQrBle_onReady();
  }

  void _authenticateQrBle_onReady(){
    /*
    Params.setParam('onDetect',
      (){
        onDetect();
      }
    );

    Get.toNamed(RouteName().scan_qr);
    */
  }

  void onDetect(){
    /*
    Params.deleteParam('onDetect');
    String? _deviceName = Params.getParam('deviceName');
    String? _serviceUuidStr = Params.getParam('serviceUuidStr');
    String? _charUuidStr = Params.getParam('charUuidStr');

    if(
      _deviceName == null
      || _serviceUuidStr == null
      || _charUuidStr == null
    ){
      print('error 8');
      dialogController.showAlertDialog(
        title: '미지원 OR 코드',
        contents: '지원하지 않는 QR 코드입니다.'
          + '\n' + '올바른 QR 코드를 스캔하십시오.',
      );
      return;
    }

    deviceName = _deviceName;
    serviceUuid = Uuid.parse(_serviceUuidStr);
    charUuid = Uuid.parse(_charUuidStr);
    scanDevice();
    */
  }

  void scanDevice(){
    if(connected){
      return;
    }

    scanStream = flutterReactiveBle.scanForDevices(withServices: [serviceUuid!]).listen((_device){
      if(_device.name == deviceName){
        device = _device;
        connectToDevice();
      }
    });
  }

  void connectToDevice(){
    connection = flutterReactiveBle.connectToDevice(id: device.id);
    connection.listen((update){
      if(update.connectionState == DeviceConnectionState.connected){
        connected = true;
        rxChar = QualifiedCharacteristic(serviceId: serviceUuid!, characteristicId: charUuid!, deviceId: device.id);
        receiveMessage();

        sendMessage('a_abc');
      }
    });
  }

  void receiveMessage(){
    flutterReactiveBle.subscribeToCharacteristic(rxChar).listen((data){
      String receivedMessage = utf8.decode(data).trim();
      print('Received: ${receivedMessage}');

      List<String> parts_reveivedMessage = receivedMessage.split('_');

      if(parts_reveivedMessage.length < 2){
        return;
      }

      /*
      parts_reveivedMessage[0]
        [P] : 스마트폰에서 보낸 메시지
        [E] : 임베디드 기기(아두이노, 라즈베리파이 등)에서 보낸 메시지
      */

      if(parts_reveivedMessage[0] != '[E]'){
        return;
      }

      // on failed
      if(parts_reveivedMessage[1] == 'af'){
        if(parts_reveivedMessage.length < 3){
          return;
        }

        if(parts_reveivedMessage[2] == 'te'){
          print('Error: 인증 시간 초과');
        
          if(_onFailed != null){
            _onFailed!('timeExceeded_authenticating');
          }
        }
        else if(parts_reveivedMessage[2] == 'wa'){
          print('Error: 잘못된 인증 코드');

          if(_onFailed != null){
            _onFailed!('wrongAuth_authenticating');
          }
        }

        sendMessage('d');
      }

      // on issued
      else if(parts_reveivedMessage[1] == 'as'){
        print('인증 성공!');
        _onIssued('success_authenticating');
      }
      else if(parts_reveivedMessage[1] == 'tf'){
        if(parts_reveivedMessage.length < 3){
          return;
        }

        if(parts_reveivedMessage[2] == 'te'){
          print('Error: 쓰레기 투하 시간 초과');
          _onIssued('timeExceeded_throwing');
        }
      }
      else if(parts_reveivedMessage[1] == 'ts'){
        print('쓰레기 투하 성공!');
        _onIssued('success_throwing');
      }

      // on success
      else if(parts_reveivedMessage[1] == 'ls'){
        print('개폐기 잠금 성공!');

        if(_onSuccess != null){
          _onSuccess!(null);
        }

        sendMessage('d');
      }
    });
  }

  Future<void> sendMessage(String sendingMessage) async {
    /*
    전송하는 문자열
      "[P]_a_{authCode}_" : 스마트폰 인증을 위한 인증 번호 전송.

      "[P]_t_" : 쓰레기 투하 실시. (일정 시간동안 쓰레기를 투하했는지 체크)
      "[P]_l_" : 개폐기 잠금. (서보 모터를 움직여서 개폐기를 잠금)

      "[P]_d_" : 블루투스 연결 종료.
    */
    
    if(!connected){
      return;
    }

    String clearStr = '';

    for(int n=1; n<=maxBytes_BLE; n++){
      clearStr += ' ';
    }

    await flutterReactiveBle.writeCharacteristicWithResponse(
      rxChar,
      value: utf8.encode(clearStr)
    );

    //

    String realSendingMessage = '[P]_${sendingMessage}_';

    await flutterReactiveBle.writeCharacteristicWithResponse(
      rxChar,
      value: utf8.encode(realSendingMessage)
    );
    
    print('Sent: ${realSendingMessage}');

    if(sendingMessage == 'd'){
      await scanStream.cancel();
      connected = false;
    }
  }

  //

  void _onIssued(String? message){
    if(message != null){
      if(message == 'success_authenticating'){
        dialogController.showAlertDialog(
          title: '휴대폰 인증 성공',
          contents: '정상 인증되었습니다.'
            + '\n' + '확인을 누른 후'
            + '\n' + '10초 안에 쓰레기를 넣으십시오.',
          canPop: false,
          barrierDismissible: false,
          closeBtnPressed: (){
            sendMessage('t');
          }
        );
        return;
      }
      else if(message == 'timeExceeded_throwing'){
        dialogController.showAlertDialog(
          title: '쓰레기 인식 실패',
          contents: '인식하지 못했습니다.'
            + '\n' + '확인을 누른 후'
            + '\n' + '10초 안에 쓰레기를 넣으십시오.',
          canPop: false,
          barrierDismissible: false,
          closeBtnPressed: (){
            sendMessage('t');
          }
        );
        return;
      }
      else if(message == 'success_throwing'){
        dialogController.showAlertDialog(
          title: '쓰레기 인식 성공',
          contents: '정상 인식하였습니다.'
            + '\n' + '10초 안에 쓰레기통 문을 닫은 후'
            + '\n' + '확인을 누르십시오.',
          canPop: false,
          barrierDismissible: false,
          closeBtnPressed: (){
            sendMessage('l');
          }
        );
        return;
      }
    }
  }
}