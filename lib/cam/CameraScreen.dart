import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:scan_pax/cam/grid.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  // esa vaina para convertir base64 
  void _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _cameraController.takePicture();
      final picBytes = await image.readAsBytes();
      final picBase64 = base64Encode(picBytes);
      print("BASE 64: $picBase64");
      String base64String = picBase64.toString();
      final directory =
          await getExternalStorageDirectory(); // Obtiene el directorio de almacenamiento externo
      final file = File(
          '${directory!.path}/my_string.txt'); // El archivo donde se guardará la cadena
      await file.writeAsString(picBase64.toString());
      print(file.path);
      
      Navigator.pop(context, picBytes);

      // Hacer algo con la imagen capturada, como guardarla o mostrarla en otra pantalla
    } catch (e) {
      // Manejar cualquier error al tomar la foto
      print('Error al tomar la foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          child: CameraPreview(_cameraController)),
                      CustomPaint(
                        painter: GridPainter(),
                        child: Container(),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.12,
                  color: Colors.transparent,
                  child: Center(
                    child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      onPressed: _takePicture,
                      child: Icon(
                        Icons.camera,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
   /*              Container(
                  height: size.height / 5,
                  color: Color.fromARGB(255, 84, 25, 104),
                  child: Center(
                      child: Text(
                    'ENFOCA LA PARTE DELANTERA DEL DNI',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                ), */