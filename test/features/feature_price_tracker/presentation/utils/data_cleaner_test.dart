
import 'package:first_source_test/features/feature_price_tracker/data/models/symbol_model.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/utils/data_cleaner.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group('getAllMarketNames test', () {

    test('test 1', (){
      List<ActiveSymbols> testList = [
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'b'),
        ActiveSymbols(marketDisplayName: 'f'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'd'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'b'),
      ];

      /// act
      final result = DataCleaner.getAllMarketNames(testList);

      expect(result, ['a','b','f','c','d',]);
    });


    test('test 2', (){
      List<ActiveSymbols> testList = [
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'b'),
        ActiveSymbols(marketDisplayName: 'f'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'd'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'b'),
      ];

      /// act
      final result = DataCleaner.getAllMarketNames(testList);

      expect(result, ['c','a','b' ,'f','d',]);
    });

  });


  group('getAllSymbolsFromMarketName test', () {

    test('test 2', (){
      List<ActiveSymbols> testList = [
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'b'),
        ActiveSymbols(marketDisplayName: 'f'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'd'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'b'),
        ActiveSymbols(marketDisplayName: 'b'),
        ActiveSymbols(marketDisplayName: 'b'),
      ];

      /// act
      final result = DataCleaner.getAllSymbolsFromMarketName(testList,'b');

      expect(result.length, 4);
    });

    test('test 1', (){
      List<ActiveSymbols> testList = [
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'a'),
        ActiveSymbols(marketDisplayName: 'b'),
        ActiveSymbols(marketDisplayName: 'f'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'd'),
        ActiveSymbols(marketDisplayName: 'c'),
        ActiveSymbols(marketDisplayName: 'b'),
      ];

      /// act
      final result = DataCleaner.getAllSymbolsFromMarketName(testList,'a');

      expect(result.length, 2);
    });

  });
}