import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_pax/socket/socketProvider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket _socket;
  //_socket.emit('cancelScan');

/*   @override
  void initState() {
    _socket = IO.io('http://192.168.1.101:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());
    _connectSocket();
    super.initState();
  }

  _connectSocket() {
    _socket.onConnect((data) => print("Connection established"));
    _socket.onConnectError((data) => print("Connection Error: $data"));
    _socket.onDisconnect((data) => print("Socket.IO server disconnected"));
    _socket.on(
        'ping',
        (data) => {
              print(data),
            });
    _socket.on(
        'sendToFlutter',
        (data) => {
              print(data),
              //openCamera(),
              Get.toNamed('/PicMenu')
            });
  } */

  @override
  Widget build(BuildContext context) {
    final socket = SocketProvider.of(context)?.socket;
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 35, 89, 133),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset('assets/animations/waiting.json'),
            SizedBox(height: 30,),
            Container(
              child: const Text(
                'Esperando conexion para Escaneo...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ));
  }
}
