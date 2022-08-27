
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/resources/data_state.dart';

abstract class PriceTrackerRepository {
  Future<DataState<dynamic>> fetchSymbols();
  Future<DataState<WebSocketChannel>> fetchSymbolTicks(symbol);
  Future<DataState<String>> cancelSymbolTicks(id);
}