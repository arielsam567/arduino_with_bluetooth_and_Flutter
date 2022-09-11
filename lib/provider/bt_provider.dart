// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_brain/models/bluetooth_model.dart';
import 'package:bluetooth_brain/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

enum comandos { FRENTE, TRAS, ESQUERDA, DIREIRA, PARADO }


class BluetoothProvider extends ChangeNotifier{


  BluetoothConnection? connection;
  String idConnected = '';
  bool isConnected = false;
  bool loading = true;
  List<BluetoothModel> devices = [];
  StreamSubscription? streamAce;
  AccelerometerEvent? lastAce;
  bool zerarAcelerometro = false;
  comandos lastSend = comandos.PARADO;


  init()  async {
    _startDiscovery();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }

  Future<void> _startDiscovery() async {

    try {
      await FlutterBluetoothSerial.instance.getBondedDevices()
          .then((List<BluetoothDevice> bondedDevices) {
        for (var element in bondedDevices) {
          devices.add(
            BluetoothModel(name:
            element.name ?? '',
              id: element.address,
            ),
          );
        }

        loading = false;
        notifyListeners();
      });
    }catch(error){
      loading = false;
      notifyListeners();
    }
  }

  void reloadDevices(){
    loading = true;
    notifyListeners();
    devices = [];
    _startDiscovery();
  }

  Future<void> disconnect() async {
    await connection?.close();
    await connection?.finish();
    streamAce?.cancel();
    idConnected = '';
    isConnected = false;
    notifyListeners();
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(pattern: [200, 200, 200, 200]);
    }
  }

  Future<void> _setAsConnected(String id) async {
    isConnected = true;
    print('FUCCCK $isConnected');
    idConnected = id;
    notifyListeners();
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(duration: 300);
    }
  }

  Future<bool> connectDevice(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);

      connection!.input!.listen((Uint8List data) {
        print('Data incoming a: $data');

        print('Data incoming: ${ascii.decode(data)}');
        connection!.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
          connection!.finish(); // Closing connection
          print('Disconnecting by local host');
        }
      }).onDone(() {
        print('Disconnected by remote request');
        disconnect();
      });


      _setAsConnected(address);
      teste();

      return true;
    } catch (exception) {
      print('ERROR $exception)');
      Get.snackbar(
          'ERROR',
          exception.toString(),
          duration:const Duration(seconds: 10),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM
      );
      disconnect();
      return false;
    }
  }




  void teste() {

    // Timer.periodic(const Duration(milliseconds: 500), (_) {
    //   // if count has increased greater than 3 call pause timer to handle success
    //   if(lastSend == comandos.PARADO){
    //     connection!.output.add(ascii.encode('0:255'));
    //   }
    // });

    streamAce = accelerometerEvents.listen((AccelerometerEvent event) {
      if(zerarAcelerometro || lastAce == null){
        lastAce = event;
        zerarAcelerometro = false;
        print('ZEROR');
      }

      final xVariation = event.x - lastAce!.x;
      final yVariation = event.y - lastAce!.y;

      double trash = 4;
      if (modulo(xVariation) > trash || modulo(yVariation) > trash) {
        // print('[AccelerometerEvent ('
        //     'x: $xVariation, '
        //     'y: $yVariation ) ] ');
        //ESQUEDA X+
        //DIREITO X-

        //FRENTE Y-
        //TRAS Y+

        if(connection != null){
          if(modulo(yVariation) > modulo(xVariation)){
            if(yVariation < -trash && lastSend != comandos.FRENTE ){
              lastSend = comandos.FRENTE;
              connection!.output.add(ascii.encode('8:255'));
            }else if(yVariation > trash && lastSend != comandos.TRAS){
              lastSend = comandos.TRAS;
              connection!.output.add(ascii.encode('2:255'));
            }
          }else{
            if(xVariation < -trash && lastSend != comandos.DIREIRA){
              lastSend = comandos.DIREIRA;
              connection!.output.add(ascii.encode('6:255'));

            }else if(xVariation > trash && lastSend != comandos.ESQUERDA){
              lastSend = comandos.ESQUERDA;
              connection!.output.add(ascii.encode('4:255'));
            }
          }
        }
      }else if(lastSend != comandos.PARADO){
        lastSend = comandos.PARADO;
        connection!.output.add(ascii.encode('0:255'));
      }
      notifyListeners();
    });
  }





}