import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A wrapper around WebSocketChannel to handle real-time connections.
class WebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  final _streamController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _subscription = _channel?.stream.listen(
        (data) {
          try {
            final decoded = jsonDecode(data as String) as Map<String, dynamic>;
            _streamController.add(decoded);
          } catch (_) {
            // Silently ignore invalid JSON
          }
        },
        onError: (Object error) {
          _streamController.addError(error);
        },
        onDone: () {
          // Handle disconnection
        },
      );
    } catch (e) {
      _streamController.addError(e);
    }
  }

  void send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
  }
}
