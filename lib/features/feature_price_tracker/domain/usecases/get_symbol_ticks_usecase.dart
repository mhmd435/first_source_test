
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetSymbolTicksUseCase extends UseCase<DataState<Stream>, String>{
  final PriceTrackerRepository priceTrackerRepository;
  GetSymbolTicksUseCase(this.priceTrackerRepository);

  @override
  Future<DataState<Stream>> call(String params) {
    return priceTrackerRepository.fetchSymbolTicks(params);
  }
}
