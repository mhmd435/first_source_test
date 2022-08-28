import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceApiProvider {

  /// get all active symbols
  WebSocketChannel callAllSymbol() {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'),
    );

    /// send data for socket
    channel.sink.add(
      jsonEncode(
          {
            "active_symbols": "brief",
            "product_type": "basic"
          }
      ),
    );

    return channel;
  }

  /// get all active symbols
  WebSocketChannel callSymbolTicks(symbol) {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'),
    );

    /// send data for socket
    channel.sink.add(
      jsonEncode(
          {
            "ticks": symbol,
            "subscribe": 1
          }
      ),
    );

    return channel;
  }

  /// cancel symbols Ticks
  WebSocketChannel callCancelTicks(id) {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'),
    );

    /// send data for socket
    channel.sink.add(
      jsonEncode(
          {
            "forget": id
          }
      ),
    );

    return channel;
  }
}