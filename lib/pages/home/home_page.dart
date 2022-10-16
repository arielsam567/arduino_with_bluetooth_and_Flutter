import 'package:bluetooth_brain/configs/themes/color_themes.dart';
import 'package:bluetooth_brain/pages/select_device/select_device_2.dart';
import 'package:bluetooth_brain/provider/bt_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../select_device/select_device_page.dart';
import '../teste.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    final bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return Consumer<BluetoothProvider>(builder: (cont, counter, _){
      return Scaffold(

        appBar: AppBar(
          backgroundColor: bluetoothProvider.isConnected ? CustomColors.connected : CustomColors.primary,

          title: const Text('Bluetooth Brain'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: bluetoothProvider.isConnected ? CustomColors.connected  : CustomColors.primary,
          onPressed: () {
            Get.to(const SelectDevicePage());
            //Get.to( FindDevicesScreen());

          },
          child: const Icon(
            Icons.bluetooth,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    bluetoothProvider.lastSend.name
                ),
              ),
              ElevatedButton(
                  onPressed: (){
                    bluetoothProvider.zerarAcelerometro = true;
                  },
                  child: const Text('Zerar acelerometro',
                    style: TextStyle(
                        color: Colors.white
                    ),)
              ),
              const BolaGiroscopio(title: '',),
            ],
          ),
        ),
      );
    });
  }
}