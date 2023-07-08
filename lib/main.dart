import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scan_pax/Home.dart';
import 'package:scan_pax/pages/PicsMenu.dart';
import 'package:scan_pax/socket/socketProvider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key) {
    _socket = IO.io('http://192.168.43.2:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());
    _connectSocket();
  }
  late IO.Socket _socket;
  void _connectSocket() {
    _socket.onConnect((data) => print("Connection established"));
    _socket.onConnectError((data) => print("Connection Error: $data"));
    _socket.onDisconnect((data) => print("Socket.IO server disconnected"));
    _socket.on('ping', (data) => {print(data)});
    _socket.on('sendToFlutter',
        (data) => {print(data), Get.toNamed('/PicMenu', arguments: data)});
  }

  final IO.Socket socket = IO.io('http://192.168.129.214:3000',
      IO.OptionBuilder().setTransports(['websocket']).build());

  @override
  Widget build(BuildContext context) {
    return SocketProvider(
      socket: socket,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => HomePage()),
          GetPage(name: '/PicMenu', page: () => PicMenu()),
        ],
      ),
    );
  }
}
