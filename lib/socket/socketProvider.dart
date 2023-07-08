import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider extends InheritedWidget {
  final IO.Socket socket;

  SocketProvider({Key? key, required this.socket, required Widget child})
      : super(key: key, child: child);

  static SocketProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SocketProvider>();
  }

  @override
  bool updateShouldNotify(SocketProvider old) => socket != old.socket;
}
