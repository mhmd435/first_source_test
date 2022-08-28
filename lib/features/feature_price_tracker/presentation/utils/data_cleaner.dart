
import 'package:first_source_test/features/feature_price_tracker/data/models/symbol_model.dart';

class DataCleaner {
  static List<String> getAllMarketNames(data){
    /// get all market name
    List<String> marketDropDown = [];
    for(ActiveSymbols activeSymbols in data){
      marketDropDown.add(activeSymbols.marketDisplayName!);
    }
    /// remove duplicates
    List<String> finalMarketDropDown = marketDropDown.toSet().toList();

    return finalMarketDropDown;
  }

  static List<ActiveSymbols> getAllSymbolsFromMarketName(List<ActiveSymbols> data, String currentMarket) {
    List<ActiveSymbols> holder = [];

    for(ActiveSymbols activeSymbols in data){
      if(activeSymbols.marketDisplayName == currentMarket){
        holder.add(activeSymbols);
      }
    }

    return holder;
  }
}