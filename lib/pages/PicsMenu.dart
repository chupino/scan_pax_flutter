import 'dart:convert';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:scan_pax/cam/CameraScreen.dart';
import 'package:scan_pax/components/ItemPicsMenu.dart';
import 'package:scan_pax/components/SimpleHeader.dart';
import 'package:scan_pax/components/itemButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:scan_pax/socket/socketProvider.dart';
import 'package:http/http.dart' as http;

class PicMenu extends StatefulWidget {
  const PicMenu({Key? key}) : super(key: key);

  static const String routeName = '/PicMenu';

  @override
  State<PicMenu> createState() => _PicMenuState();
}

class _PicMenuState extends State<PicMenu> {
  List<String> fotos = [];
  Uint8List? fotoDelantera;
  Uint8List? fotoTrasera;
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final nombre = Get.arguments;
    final socket = SocketProvider.of(context)?.socket;

    return WillPopScope(
      onWillPop: () async {
        socket?.emit("cancelScan");
        return true;
      },
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 35, 89, 133),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SimpleHeader(
                size: size,
                title: "Toma las fotos para la reserva de $nombre",
                height: 180,
                onTap: () {
                  socket?.emit("cancelScan");
                  Get.back();
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    /* ItemChangePax(
                      key: _itemCountGuest,
                      initData: 1,
                      icon: AssetHelper.icoGuest,
                      value: 'Acompañantes',
                    ), */
                    SizedBox(
                      height: 10,
                    ),
                    ItemPicMenu(
                        title: "Tomar Foto Delantera",
                        imagen: fotoDelantera,
                        icon: Icons.document_scanner,
                        onTap: () async {
                          final cameras = await availableCameras();
                          final camera = cameras.firstWhere(
                            (camera) =>
                                camera.lensDirection ==
                                CameraLensDirection.back,
                            orElse: () => cameras.first,
                          );

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraScreen(camera: camera),
                            ),
                          );

                          if (result != null) {
                            fotoDelantera = result;
                          } else {}
                        },
                        color: Colors.purple),
                    SizedBox(
                      height: 10,
                    ),
                    ItemPicMenu(
                        title: "Tomar Foto Trasera",
                        imagen: fotoTrasera,
                        icon: Icons.document_scanner,
                        onTap: () async {
                          final cameras = await availableCameras();
                          final camera = cameras.firstWhere(
                            (camera) =>
                                camera.lensDirection ==
                                CameraLensDirection.back,
                            orElse: () => cameras.first,
                          );

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CameraScreen(camera: camera),
                            ),
                          );

                          if (result != null) {
                            fotoTrasera = result;
                          } else {}
                        },
                        color: Colors.purple),
                    SizedBox(
                      height: 10,
                    ),
                    ItemButtonWidget(
                      color: Color.fromARGB(255, 75, 30, 114),
                      data: 'Hecho',
                      onTap: () async {
                        print(fotoDelantera);
                        if (fotoDelantera != null || fotoTrasera != null) {
                          //LLAMADO AL API DE DJANGO PARA ESCANEAR LAS FOTOS
                          //Bla Bla Bla

                          //SIMULACION DE OBTENCION DE JSON
                          /* final response2=await http.post(Uri.parse("https://2ff6-132-157-128-235.ngrok-free.app/convertir_imagen/"),body: {
                            "image_bytes1":fotoDelantera.toString(),
                            "image_bytes2":fotoTrasera.toString()
                          }); */

                          var request = http.MultipartRequest(
                            'POST',
                            Uri.parse(
                                'https://2ff6-132-157-128-235.ngrok-free.app/convertir_imagen/'),
                          );

                          // Agregar la primera imagen
                          var multipartFile1 = http.MultipartFile.fromBytes(
                            'image_bytes1',
                            fotoDelantera!,
                            filename: 'image1.jpg',
                            contentType: MediaType('image', 'jpeg'),
                          );
                          request.files.add(multipartFile1);

                          // Agregar la segunda imagen
                          var multipartFile2 = http.MultipartFile.fromBytes(
                            'image_bytes2',
                            fotoTrasera!,
                            filename: 'image2.jpg',
                            contentType: MediaType('image', 'jpeg'),
                          );
                          request.files.add(multipartFile2);

                          // Enviar la solicitud y obtener la respuesta
                          var response2 = await request.send();
                          var responseData =
                              await response2.stream.bytesToString();
                          print(responseData);

                          final Map<String, dynamic> response = {
                            "status": 200,
                            "message":
                                "Se escanearon las fotos satisfactoriamente",
                            "data": {
                              "nombres": "Mauricio Diego",
                              "apellidos": "Escalante Cunurana",
                              "nro_documento": "76010300",
                              "fecha_nacimiento": "09-04-2005",
                              "sexo": "Masculino",
                              "region": "Ilo",
                              "direccion": "Alto Ilo A-12"
                            }
                          };
                          socket?.emit('sendToVue', response);
                          Get.toNamed('/');
                        } else {
                          Get.snackbar("Atención",
                              "Debes de tomar las fotografias del dni para continuar",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                                  const Color.fromARGB(255, 96, 169, 229),
                              colorText: Colors.white);
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
