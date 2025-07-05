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
            child: NormalText(
              title: 'BLE Controller 1',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: CustomColor.black,
            ),
          ),
          BodyItem(
            top: 20,
            child: Obx((){
              String stateStr = '-';
              Color color = Color(0xFFAAAAAA);
              ConnectedState connectedState = _controller.connectedState.value;

              if(connectedState == ConnectedState.Disconnected){
                stateStr = '연결 안 됨';
              }
              else if(connectedState == ConnectedState.Connecting){
                stateStr = '연결 중...';
                color = Color(0xFF000000);
              }
              else if(connectedState == ConnectedState.Connected){
                stateStr = '연결 완료!';
                color = Color(0xFF0000FF);
              }

              return Align(
                alignment: Alignment.centerLeft,
                child: NormalText(
                  title: '상태: ${stateStr}',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              );
            }),
          ),

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
                  _controller.connectedState.value == ConnectedState.Connected
                  ? null
                  : (){
                    _controller.bleController.connectBle(
                      connectedState: _controller.connectedState,
                      selectedOperationType: _controller.selectedOperationType,

                      startNumber: _controller.selectedStartNumber.value,
                      endNumber: _controller.selectedEndNumber.value,
                    );
                  },
              );
            }),
          ),

          BodyItem(
            child: CustomDivider(),
          ),

          const Gap(10),

          Obx((){
            ConnectedState connectedState = _controller.connectedState.value;
            String selectedOperationType = _controller.selectedOperationType.value;

            return Column(
              children: [
                BodyItem(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'A',
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'A'
                            ? () async {
                              await _controller.bleController.changeOperation('A');
                            }
                            : null,
                        ),
                      ),

                      const Gap(10),

                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'B',
                          color: CustomColor.secondary,
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'B'
                            ? () async {
                              await _controller.bleController.changeOperation('B');
                            }
                            : null,
                        ),
                      ),
                    ],
                  ),
                ),

                BodyItem(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'C',
                          color: CustomColor.secondary,
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'C'
                            ? () async {
                              await _controller.bleController.changeOperation('C');
                            }
                            : null,
                        ),
                      ),

                      const Gap(10),

                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'D',
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'D'
                            ? () async {
                              await _controller.bleController.changeOperation('D');
                            }
                            : null,
                        ),
                      ),
                    ],
                  ),
                ),

                BodyItem(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'E',
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'E'
                            ? () async {
                              await _controller.bleController.changeOperation('E');
                            }
                            : null,
                        ),
                      ),

                      const Gap(10),

                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'F',
                          color: CustomColor.secondary,
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'F'
                            ? () async {
                              await _controller.bleController.changeOperation('F');
                            }
                            : null,
                        ),
                      ),
                    ],
                  ),
                ),

                BodyItem(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'G',
                          color: CustomColor.secondary,
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'G'
                            ? () async {
                              await _controller.bleController.changeOperation('G');
                            }
                            : null,
                        ),
                      ),

                      const Gap(10),

                      Flexible(
                        flex: 50,
                        child: CustomElevatedButton(
                          title: 'H',
                          onTap:
                            connectedState == ConnectedState.Connected
                              && selectedOperationType != 'H'
                            ? () async {
                              await _controller.bleController.changeOperation('H');
                            }
                            : null,
                        ),
                      ),
                    ],
                  ),
                ),

                BodyItem(
                  top: 20,
                  child: CustomElevatedButton(
                    title: 'Disconnect',
                    color: Color(0xFF777777),
                    onTap:
                      connectedState == ConnectedState.Connected
                      ? () async {
                        await _controller.bleController.disconnect();
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
  final List<String> numbers = [AppConfig().defaultValue_dropdownButton, '1', '2', '3', '4', '5', '6', '7', '8', '9',];

  Rx<ConnectedState> connectedState = ConnectedState.Disconnected.obs;
  RxString selectedOperationType = ''.obs;

  RxString selectedStartNumber = AppConfig().defaultValue_dropdownButton.obs;
  RxString selectedEndNumber = AppConfig().defaultValue_dropdownButton.obs;

  //

  BleController bleController = BleController();

  //

  @override
  void onReady(){
    super.onReady();
    //
  }

  //
}

enum ConnectedState {
  Disconnected, Connecting, Connected,
}

class BleController {
  final int maxBytes_ble = 20;
  final String subUuidStr_service = '9B10000-E8F2-537E-4F6C-D104768A121';
  final String subUuidStr_char = '9B10001-E8F2-537E-4F6C-D104768A121';

  late DiscoveredDevice device;
  late QualifiedCharacteristic rxChar;
  late Stream<ConnectionStateUpdate> connection;
  late StreamSubscription<DiscoveredDevice> scanStream;
  
  //

  String? deviceName;
  Uuid? serviceUuid;
  Uuid? charUuid;

  Rx<ConnectedState>? _connectedState;
  RxString? _selectedOperationType;

  String? _startNumber;
  String? _endNumber;
  
  //
  
  DialogController dialogController = DialogController();
  FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  
  //

  void connectBle(
    {
      required Rx<ConnectedState> connectedState,
      required RxString selectedOperationType,

      required String startNumber,
      required String endNumber,
    }
  ){
    if(startNumber.contains('선택')){
      dialogController.showAlertDialog(
        title: '맨 앞 숫자 미선택',
        contents: '맨 앞 숫자를 선택하십시오.'
      );
      return;
    }
    else if(endNumber.contains('선택')){
      dialogController.showAlertDialog(
        title: '맨 뒤 숫자 미선택',
        contents: '맨 뒤 숫자를 선택하십시오.'
      );
      return;
    }

    _connectedState = connectedState;
    _selectedOperationType = selectedOperationType;

    _startNumber = startNumber;
    _endNumber = endNumber;

    flutterReactiveBle.statusStream.listen(
      (status){
        if(status == BleStatus.unknown){
          return;
        }

        _connectBle_statusConfirmed(status);
      },
    );
  }

  Future<void> changeOperation(String type) async {
    if(_connectedState == null){
      return;
    }
    else if(_connectedState!.value != ConnectedState.Connected){
      return;
    }

    _selectedOperationType!.value = type;
    await _sendMessage('c_${type}');
  }

  Future<void> disconnect() async {
    if(_connectedState == null){
      return;
    }
    else if(_connectedState!.value != ConnectedState.Connected){
      return;
    }

    await scanStream.cancel();
    _sendMessage('d');
    _connectedState!.value = ConnectedState.Disconnected;
  }

  //

  void _connectBle_statusConfirmed(BleStatus status){
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

    _connectBle_onReady();
  }

  void _connectBle_onReady(){
    deviceName = "A";
    serviceUuid = Uuid.parse(_startNumber! + subUuidStr_service + _endNumber!);
    charUuid = Uuid.parse(_startNumber! + subUuidStr_char + _endNumber!);

    _scanDevice();
  }

  void _scanDevice(){
    if(_connectedState!.value == ConnectedState.Connected){
      return;
    }

    _connectedState!.value = ConnectedState.Connecting;
    scanStream = flutterReactiveBle.scanForDevices(withServices: [serviceUuid!]).listen((_device){
      if(_device.name == deviceName){
        device = _device;
        _connectToDevice();
      }
    });
  }

  void _connectToDevice(){
    connection = flutterReactiveBle.connectToDevice(id: device.id);
    connection.listen((update){
      if(update.connectionState == DeviceConnectionState.connected){
        _selectedOperationType!.value = 'A';
        _connectedState!.value = ConnectedState.Connected;
        rxChar = QualifiedCharacteristic(serviceId: serviceUuid!, characteristicId: charUuid!, deviceId: device.id);
        _receiveMessage();
      }
    });
  }

  void _receiveMessage(){
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

      /*
      if(parts_reveivedMessage[1] == 'a'){  // 'a'라는 명령 받으면
        //
      }
      else if(parts_reveivedMessage[1] == 'b'){
        //
      }
      */
    });
  }

  Future<void> _sendMessage(String sendingMessage) async {
    /*
    전송하는 문자열
      "[P]_c_A_" : 아두이노 동작 방식 변경 (A~H)
    */

    if(_connectedState == null){
      return;
    }
    else if(_connectedState!.value != ConnectedState.Connected){
      return;
    }

    String clearStr = '';

    for(int n=1; n<=maxBytes_ble; n++){
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
  }
}