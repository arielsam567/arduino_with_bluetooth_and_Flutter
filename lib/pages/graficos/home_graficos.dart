import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'graficos.dart';

class Graficos extends StatefulWidget {
  const Graficos({Key? key}) : super(key: key);

  @override
  State<Graficos> createState() => _GraficosState();
}

class _GraficosState extends State<Graficos> {
  List<LinearSales> dadosX = [];
  List<LinearSales> dadosY = [];
  List<LinearSales> dadosZ = [];
  int segundos = 5;



  @override
  Widget build(BuildContext context) {

    int t = 0;
    double time = segundos / dadosX.length;
    double area = 0;
    time = 0.166666;
    for(int t = 0;t< dadosX.length - 1;t++){
      int value = double.parse(dadosX[t].event.toStringAsFixed(1)).round();
      int nextValue = double.parse(dadosX[t + 1].event.toStringAsFixed(1)).round();


      print('$t value $value');
      if(value == nextValue){
        area += value*time;
      }else if(value != 0 || nextValue != 0){
        area += ((value + nextValue) * time)/2;
      }else if(value == 0 || nextValue == 0){
        area += (time*value)/2 + (time*nextValue)/2;
      }else{
        print('caso ferrou');
      }
    }
    print('terminou area ${area}, deslocamento: ${(area*segundos).toStringAsFixed(2)}');


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: PointsLineChart.withSampleData(dadosX),
          ),
          SizedBox(
            height: 200,
            child: PointsLineChart.withSampleData(dadosY),
          ),
          SizedBox(
            height: 200,
            child: PointsLineChart.withSampleData(dadosZ),
          ),
          TextButton(
            onPressed: (){
              double t = 0;
              dadosX = [];
              dadosY = [];
              dadosZ = [];
              StreamSubscription? streamAce;

              streamAce = accelerometerEvents.listen(( event) {
                print('${dadosX.length} ${event.toString()}');
                dadosX.add(LinearSales(event.x + 0.12 , t));
                dadosY.add(LinearSales(event.y - 0.28  , t));
                dadosZ.add(LinearSales(event.z - 9.85, t));
                t += 16.6666;
              });

              Future.delayed(Duration(seconds: segundos), (){
                streamAce?.cancel();
                print("dados.leng ${dadosX.length}");
                setState(() {
                  dadosX;
                });
              });


            },
              child: const Text('GRAVAR DADOS'),
          )
        ],
      ),
    );
  }
}
