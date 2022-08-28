
import 'package:first_source_test/core/resources/data_state.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/symbol_model.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/cancel_symbol_ticks_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/get_all_symbols_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/get_symbol_ticks_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/price_tracker_cubit/price_tracker_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'price_tracker_cubit_test.mocks.dart';

@GenerateMocks([GetAllSymbolsUseCase,GetSymbolTicksUseCase,CancelSymbolTicksUseCase])
void main(){
  MockGetAllSymbolsUseCase mockGetAllSymbolsUseCase = MockGetAllSymbolsUseCase();
  MockGetSymbolTicksUseCase mockGetSymbolTicksUseCase = MockGetSymbolTicksUseCase();
  MockCancelSymbolTicksUseCase mockCancelSymbolTicksUseCase = MockCancelSymbolTicksUseCase();
  late PriceTrackerCubit priceTrackerCubit;

  setUp((){
    priceTrackerCubit = PriceTrackerCubit(mockGetAllSymbolsUseCase, mockGetSymbolTicksUseCase, mockCancelSymbolTicksUseCase);
  });

  String error = "error";

  test('callSymbolsApi test when DataFailed come to cubit --- should emit Error state', () {
    when(mockGetAllSymbolsUseCase(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

    priceTrackerCubit.callSymbolsApi();

    expectLater(priceTrackerCubit.stream,emitsInOrder([
      // priceTrackerCubit.state.copyWith(newAllSymbolsStatus: AllSymbolsLoading()),
      priceTrackerCubit.state.copyWith(newAllSymbolsStatus: AllSymbolsError(error)),
    ]));
  });
}