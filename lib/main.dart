import 'package:bluetooth_brain/provider/bt_provider.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_brain/pages/home/home_page.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'configs/themes/custom_themes.dart';
import 'pages/graficos/home_graficos.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BluetoothProvider(),
      child: GetMaterialApp(
        theme: CustomThemes.defaultTheme,
        home: const Graficos(),
      ),
    );
  }
}


