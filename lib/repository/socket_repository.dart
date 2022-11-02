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

  void typing(Map<String, dynamic> data) {
    // Same feature as when someone is typing on whatsapp
    // typing...
    _socketClient.emit('typing', data);
  }

  void autoSave(Map<String, dynamic> data) {
    _socketClient.emit('save', data);
  }

  void changeListener (Function(Map<String, dynamic>) func) {
    // Here, we need to listen to the emitted 'changes' from the socket,
    // Then since we can't access the quill editor from this our current file (socketRepository file)
    // We'd have a callback function, that will allow us have the returned 'data';
    _socketClient.on('changes', (data) => func(data));
  }
}