
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllSymbolsUseCase extends UseCase<DataState<dynamic>, NoParams>{
  final PriceTrackerRepository priceTrackerRepository;
  GetAllSymbolsUseCase(this.priceTrackerRepository);

  @override
  Future<DataState<dynamic>> call(NoParams params) {
    return priceTrackerRepository.fetchSymbols();
  }

}
