
import 'package:first_source_test/core/resources/data_state.dart';
import 'package:first_source_test/features/feature_price_tracker/data/data_source/price_api_provider.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PriceTrackerRepositoryImpl extends PriceTrackerRepository {
  PriceApiProvider apiProvider;
  PriceTrackerRepositoryImpl(this.apiProvider);

  WebSocketChannel? tickChannel;

  @override
  Future<DataState<Stream>> fetchSymbols() async {
    try{
      var channel = apiProvider.callAllSymbol();

       /// convert json to models class
       // final SymbolEntity symbolEntity = SymbolModel.fromJson(streamData);
       return DataSuccess(channel.stream);
    }catch(e){
      print(e.toString());
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState<Stream>> fetchSymbolTicks(symbol) async{
    try{
      tickChannel = apiProvider.callSymbolTicks(symbol);

      /// convert json to models class
      // final SymbolEntity symbolEntity = SymbolModel.fromJson(streamData);
      return DataSuccess(tickChannel!.stream);
    }catch(e){
      print(e.toString());
      return const DataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState<String>> cancelSymbolTicks(id) async{
    try{
      /// close tick
      tickChannel!.sink.close();
      apiProvider.callSymbolTicks(id);

      /// convert json to models class
      // final SymbolEntity symbolEntity = SymbolModel.fromJson(streamData);
      return const DataSuccess("previous Ticks canceled");
    }catch(e){
      print(e.toString());
      return const DataFailed("please check your connection...");
    }
  }

}