
import '../../../../core/resources/data_state.dart';

abstract class PriceTrackerRepository {
  Future<DataState<dynamic>> fetchSymbols();
  Future<DataState<dynamic>> fetchSymbolTicks(symbol);
  Future<DataState<String>> cancelSymbolTicks(id);
}