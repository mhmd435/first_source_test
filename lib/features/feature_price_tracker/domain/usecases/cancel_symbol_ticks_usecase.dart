
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class CancelSymbolTicksUseCase extends UseCase<DataState<String>, String>{
  final PriceTrackerRepository priceTrackerRepository;
  CancelSymbolTicksUseCase(this.priceTrackerRepository);

  @override
  Future<DataState<String>> call(String params) {
    return priceTrackerRepository.cancelSymbolTicks(params);
  }
}
