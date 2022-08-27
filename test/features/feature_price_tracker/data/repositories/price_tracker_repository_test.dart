
import 'package:first_source_test/core/resources/data_state.dart';
import 'package:first_source_test/features/feature_price_tracker/data/data_source/price_api_provider.dart';
import 'package:first_source_test/features/feature_price_tracker/data/repositories/price_tracker_repository_impl.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'price_tracker_repository_test.mocks.dart';

@GenerateMocks([PriceApiProvider])
void main(){
  MockPriceApiProvider mockPriceApiProvider = MockPriceApiProvider();
  late PriceTrackerRepository priceTrackerRepository;

  setUp((){
    priceTrackerRepository = PriceTrackerRepositoryImpl(mockPriceApiProvider);
  });


  test('test Success fetch symbol ', () async {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089'),
    );

    /// arrange
    when(mockPriceApiProvider.callAllSymbol()).thenAnswer((_) => channel);

    /// act
    final result = await priceTrackerRepository.fetchSymbols();

    /// assert
    expect(result, isA<DataSuccess<dynamic>>());
  });

}