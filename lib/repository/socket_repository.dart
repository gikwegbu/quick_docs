import 'package:quick_docs/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  // The value can't be null, if it is, then it'll run the connection function and connect
  final _socketClient = SocketClient.instance.socket!;
  
  // So it can be accessed from any file that needs it.
  Socket get socketClient => _socketClient;

  void joinRoom(String documentId) {
    _socketClient.emit('join', documentId);
  }
}