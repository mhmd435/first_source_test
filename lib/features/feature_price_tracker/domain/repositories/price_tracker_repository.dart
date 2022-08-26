
import '../../../../core/resources/data_state.dart';

abstract class PriceTrackerRepository {
  Future<DataState<Stream>> fetchSymbols();
  Future<DataState<Stream>> fetchSymbolTicks(symbol);
  Future<DataState<String>> cancelSymbolTicks(id);
}