import 'package:bluetooth_brain/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadCamera() {
    cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    try{
      if (cameraImage != null) {
        //print('\n\n\n cameraImage!.planes ${cameraImage!.planes.length}');
        List? predictions = await Tflite.runModelOnFrame(
            bytesList: cameraImage!.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: cameraImage!.height,
            imageWidth: cameraImage!.width,
            imageMean: 127.5,
            imageStd: 127.5,
            rotation: 90,
            numResults: 1,
            threshold: 0.8,
            asynch: true);
        for (var element in predictions!) {
          print('element  ${element}');

          if(element['confidence'] > 0.95 && element['label'] == '0 CONE'){
            if(output != 'CONE'){
              setState(() {
                output = 'CONE';
              });
            }
          }else if(output != 'NADA'){
            setState(() {
              output = 'NADA';
            });
          }

        }
      }
    }catch(error){
      //print('FLUTTER ERROR $error');
    }
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model3.tflite",
      labels: "assets/labels3.txt",
      numThreads: 5,
      useGpuDelegate: false,
    );
    loadCamera();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Emotion Detection App')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: !cameraController!.value.isInitialized
                ? Container()
                : AspectRatio(
              aspectRatio: cameraController!.value.aspectRatio,
              child: CameraPreview(cameraController!),
            ),
          ),
        ),
        Text(
          output,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )
      ]),
    );
  }
}
