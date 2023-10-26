import 'dart:async';
import 'dart:io';

class NetworkAnalyzerHelper {
  static discover(String subnet, int port,
      {Duration timeout = const Duration(seconds: 5)}) {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }
    // TODO : validate subnet

    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];
    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> f = _ping(host, port, timeout);
      futures.add(f);
      f.then((socket) {
        socket.destroy();
        out.sink.add(NetworkAddress(host, true));
      }).catchError((dynamic e) {
        if (e is! SocketException) {
          throw e;
        }

        // Check if connection timed out or we got one of predefined errors
        if (e.osError == null || _errorCodes.contains(e.osError?.errorCode)) {
          out.sink.add(NetworkAddress(host, false));
        } else {
          // Error 23,24: Too many open files in system
          throw e;
        }
      });
    }

    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }

  static Future<Socket> _ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  static Future<bool> ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      socket.destroy();
      return true;
    }).onError((error, stackTrace) => Future.value(false));
  }

  static final _errorCodes = [13, 49, 61, 64, 65, 101, 111, 113];
}

class NetworkAddress {
  NetworkAddress(this.ip, this.exists);
  bool exists;
  String ip;

  Map<String, dynamic> toJson() => {'ip': ip, 'exists': exists};
}
