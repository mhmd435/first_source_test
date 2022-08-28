
import 'package:first_source_test/core/resources/data_state.dart';
import 'package:first_source_test/features/feature_price_tracker/data/data_source/price_api_provider.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceTrackerRepositoryImpl extends PriceTrackerRepository {
  PriceApiProvider apiProvider;
  PriceTrackerRepositoryImpl(this.apiProvider);

  WebSocketChannel? tickChannel;

  @override
  Future<DataState<dynamic>> fetchSymbols() async {
    try{
      final channel = apiProvider.callAllSymbol();

       return DataSuccess(channel.stream);
    }catch(e){
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState<dynamic>> fetchSymbolTicks(symbol) async{
    try{
      tickChannel = apiProvider.callSymbolTicks(symbol);

      return DataSuccess(tickChannel!.stream);
    }catch(e){
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState<String>> cancelSymbolTicks(id) async{
    try{
      /// close tick
      if(tickChannel != null){
        tickChannel!.sink.close();
      }
      WebSocketChannel webSocketChannel = apiProvider.callCancelTicks(id);

      /// convert json to models class
      // final SymbolEntity symbolEntity = SymbolModel.fromJson(streamData);
      return const DataSuccess("previous Ticks canceled");
    }catch(e){
      return const DataFailed("please check your connection...");
    }
  }
}
