import 'package:socket_io_client/socket_io_client.dart' as IO;

main() {
  IO.Socket socket = IO.io('http://localhost:3000/', <String, dynamic>{
    'transports': ['websocket'],
  });

  print("socketttt");
  print(socket);

  socket.onConnect((_) => {print("connected")});
  //socket.emit('join', 'room1');
  // socket.emit('join',)
}
