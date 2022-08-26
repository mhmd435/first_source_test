

import 'package:first_source_test/features/feature_price_tracker/data/data_source/price_api_provider.dart';
import 'package:first_source_test/features/feature_price_tracker/data/repositories/price_tracker_repository_impl.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/cancel_symbol_ticks_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/get_all_symbols_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/theme_cubit/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'features/feature_price_tracker/domain/usecases/get_symbol_ticks_usecase.dart';
import 'features/feature_price_tracker/presentation/bloc/price_tracker_cubit/price_tracker_cubit.dart';

GetIt locator = GetIt.instance;

Future<void> initLocator() async {
  /// api provider
  locator.registerSingleton<PriceApiProvider>(PriceApiProvider());

  /// repository provider
  locator.registerSingleton<PriceTrackerRepository>(PriceTrackerRepositoryImpl(locator<PriceApiProvider>()));

  /// use case provide
  locator.registerSingleton<GetAllSymbolsUseCase>(GetAllSymbolsUseCase(locator<PriceTrackerRepository>()));
  locator.registerSingleton<GetSymbolTicksUseCase>(GetSymbolTicksUseCase(locator<PriceTrackerRepository>()));
  locator.registerSingleton<CancelSymbolTicksUseCase>(CancelSymbolTicksUseCase(locator<PriceTrackerRepository>()));


  /// cubit providers
  locator.registerSingleton<ThemeCubit>(ThemeCubit());
  locator.registerSingleton<PriceTrackerCubit>(PriceTrackerCubit(
      locator<GetAllSymbolsUseCase>(),
      locator<GetSymbolTicksUseCase>(),
      locator<CancelSymbolTicksUseCase>()
  ));
}
