import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeController extends ChangeNotifier{

  AccelerometerEvent? lastAce;
  MagnetometerEvent? lastMag;
  final bool startMag = false;


  HomeController(){
    //init();
  }

  init() async {

    accelerometerEvents.listen((AccelerometerEvent event) {
      lastAce ??= event;

      final xVariation = event.x - lastAce!.x;
      final yVariation = event.y - lastAce!.y;

      if (modulo(xVariation) > 2 ||
          modulo(yVariation) > 2
      ) {
        print('[AccelerometerEvent ('
            'x: $xVariation, '
            'y: $yVariation ) ] ');
        //ESQUEDA X+
        //DIREITO X-

        //FRENTE Y-
        //TRAS Y+

      }
    });


    //ERROR
    // userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    //   print(event);
    //   // [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]
    // });


    // gyroscopeEvents.listen((GyroscopeEvent event) {
    //   //print(event);
    //   // [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]
    // });


    //

    if(startMag) {
      magnetometerEvents.listen((MagnetometerEvent event) {
        lastMag ??= event;

        final xVariation = event.x - lastMag!.x;
        final yVariation = event.y - lastMag!.y;
        final zVariation = event.z - lastMag!.z;


        if (modulo(xVariation) > 1 ||
            modulo(yVariation) > 1 ||
            modulo(zVariation) > 1
        ) {
          print('[MagnetometerEvent ('
              'x: $xVariation, '
              'y: $yVariation, '
              'z: $zVariation ');
        }
      });
    }



  }



}

double modulo(double value){
  return sqrt(value*value);
}