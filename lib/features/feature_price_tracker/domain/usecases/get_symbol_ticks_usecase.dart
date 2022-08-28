
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetSymbolTicksUseCase extends UseCase<DataState<dynamic>, String>{
  final PriceTrackerRepository priceTrackerRepository;
  GetSymbolTicksUseCase(this.priceTrackerRepository);

  @override
  Future<DataState<dynamic>> call(String params) {
    return priceTrackerRepository.fetchSymbolTicks(params);
  }
}
