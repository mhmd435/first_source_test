import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetSymbolTicksUseCase extends UseCase<DataState<WebSocketChannel>, String>{
  final PriceTrackerRepository priceTrackerRepository;
  GetSymbolTicksUseCase(this.priceTrackerRepository);

  @override
  Future<DataState<WebSocketChannel>> call(String params) {
    return priceTrackerRepository.fetchSymbolTicks(params);
  }
}