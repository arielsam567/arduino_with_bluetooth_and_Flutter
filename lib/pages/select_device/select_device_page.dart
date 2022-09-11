import 'package:bluetooth_brain/configs/themes/color_themes.dart';
import 'package:bluetooth_brain/provider/bt_provider.dart';
import 'package:bluetooth_brain/pages/select_device/widgets/device_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SelectDevicePage extends StatefulWidget {
  const SelectDevicePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SelectDevicePageState();
  }
}

class SelectDevicePageState extends State<SelectDevicePage> {
  late BluetoothProvider bluetoothProvider;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500),(){
      bluetoothProvider.init();
    });
  }


  @override
  Widget build(BuildContext context) {

    bluetoothProvider = Provider.of<BluetoothProvider>(context);
    return Consumer<BluetoothProvider>(
        builder: (BuildContext context, count, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Select device'),
              backgroundColor: bluetoothProvider.isConnected ? CustomColors.connected  : null,
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Visibility(
                visible: bluetoothProvider.loading,
                child: const Center(
                    child: CircularProgressIndicator(color: Colors.black,)
                ),
                replacement: Visibility(
                  visible: bluetoothProvider.devices.isNotEmpty,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: bluetoothProvider.devices.length,
                        itemBuilder: (context, index) {
                          return DeviceItem(
                            device: bluetoothProvider.devices[index],
                            connected: bluetoothProvider.devices[index].id == bluetoothProvider.idConnected,
                            onTap: () async {
                              if(bluetoothProvider.isConnected == false){
                                print('CONNECTANDO');
                                await bluetoothProvider.connectDevice(bluetoothProvider.devices[index].id);
                                print('CONNECTADO');
                              }else{
                                print('DESCONNECTANDO');
                                await bluetoothProvider.disconnect();
                                print('DESCONNECTADO');
                              }
                              setState(() {});
                            },
                          );
                        }),
                  ),
                  replacement: const Center(
                    child: Text(
                      'Nenhum disposito encontrado',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                  ,
                ),
              ),
            ),
            floatingActionButton:  FloatingActionButton(
              backgroundColor: bluetoothProvider.isConnected ? CustomColors.connected  : CustomColors.primary,
              onPressed: () async {
                if(bluetoothProvider.isConnected){
                  await bluetoothProvider.disconnect();
                  setState(() {});
                }else{
                  bluetoothProvider.reloadDevices();
                }

              },
              child:  Icon( bluetoothProvider.isConnected ?  Icons.close : Icons.search,
                color: Colors.white,
              ),
            ),
          );
        });
  }

}
