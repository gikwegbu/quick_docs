import 'package:quick_docs/utils/api.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  io.Socket? socket;

  static SocketClient? _instance;

  SocketClient._internal() {
    socket = io.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });

    socket?.connect();
  }

  static SocketClient get instance {
    // Checks in there's an instance already called, if yes, return it.
    // Else, call the _internal() again to create an instance.
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
