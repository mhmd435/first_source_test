import 'package:first_source_test/core/resources/data_state.dart';
import 'package:first_source_test/core/usecases/usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/get_all_symbols_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_all_symbol_usecase_test.mocks.dart';

@GenerateMocks([PriceTrackerRepository])
void main(){
  late GetAllSymbolsUseCase getAllSymbolsUseCase;
  MockPriceTrackerRepository mockPriceTrackerRepository = MockPriceTrackerRepository();

  setUp(() {
    getAllSymbolsUseCase = GetAllSymbolsUseCase(mockPriceTrackerRepository);
  });


  group('get symbol usecase test', () {
    test('should get dataSuccess Stream from the repository', () async {
      Stream stream = Stream.value(20);
      DataSuccess<Stream> dataSuccess =  DataSuccess(stream);

      /// arrange
      when(mockPriceTrackerRepository.fetchSymbols()).thenAnswer((_) => Future.value(dataSuccess));

      /// act
      final result = await getAllSymbolsUseCase(NoParams());

      /// assert
      expect(result, dataSuccess);
    });

    test('should get dataFailed Stream from the repository', () async {
      DataFailed<String> dataFailed = const DataFailed("error");

      /// arrange
      when(mockPriceTrackerRepository.fetchSymbols()).thenAnswer((_) => Future.value(dataFailed));

      /// act
      final result = await getAllSymbolsUseCase(NoParams());

      /// assert
      expect(result, dataFailed);
    });
  });
}