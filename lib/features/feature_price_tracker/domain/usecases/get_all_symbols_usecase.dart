
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllSymbolsUseCase extends UseCase<DataState<Stream>, NoParams>{
  final PriceTrackerRepository priceTrackerRepository;
  GetAllSymbolsUseCase(this.priceTrackerRepository);

  @override
  Future<DataState<Stream>> call(NoParams params) {
    return priceTrackerRepository.fetchSymbols();
  }

}
