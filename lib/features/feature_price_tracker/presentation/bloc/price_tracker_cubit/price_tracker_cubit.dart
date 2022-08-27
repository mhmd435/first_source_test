import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:first_source_test/core/usecases/usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/entities/tick_entity.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/repositories/price_tracker_repository.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../../core/resources/data_state.dart';
import '../../../data/models/symbol_model.dart';
import '../../../domain/entities/symbol_entity.dart';
import '../../../domain/usecases/cancel_symbol_ticks_usecase.dart';
import '../../../domain/usecases/get_all_symbols_usecase.dart';

part 'all_symbols_status.dart';
part 'price_tracker_state.dart';
part 'symbol_ticks_status.dart';

class PriceTrackerCubit extends Cubit<PriceTrackerState> {
  GetAllSymbolsUseCase getAllSymbolsUseCase;
  PriceTrackerRepository priceTrackerRepository;
  CancelSymbolTicksUseCase cancelSymbolTicksUseCase;

  PriceTrackerCubit(
      this.getAllSymbolsUseCase,
      this.priceTrackerRepository,
      this.cancelSymbolTicksUseCase) : super(PriceTrackerState(
    allSymbolsStatus: AllSymbolsLoading(),
    currentMarket: "",
    symbolTicksStatus: SymbolTicksInitial(),
    priceColor: Colors.grey
  ));

  /// call and state manage for symbol api call
  Future<void> callSymbolsApi() async {

    /// emit loading status
    emit(state.copyWith(
      newAllSymbolsStatus: AllSymbolsLoading()),);

    /// get All Champion Data
    final DataState dataState = await getAllSymbolsUseCase(NoParams());


    /// emit completed -- api call Success
    if(dataState is DataSuccess){
      Stream data = dataState.data;

      /// listen to api stream
      data.listen((event) {
        /// serialization
        final SymbolEntity symbolEntity = SymbolModel.fromJson(jsonDecode(event));

        emit(state.copyWith(
            newAllSymbolsStatus: AllSymbolsCompleted(symbolEntity.activeSymbols!),
        ));
      });

    }

    /// emit error --  api call Failed
    if(dataState is DataFailed){
      emit(state.copyWith(
        newAllSymbolsStatus: AllSymbolsError(dataState.error!),),);
    }
  }

  /// change market by dropDown and rebuild the second dropdown
  void changeMarket(String market,String? ticksId) {

    /// close ticks
    if(ticksId != null){
      cancelTicks(ticksId);
    }

    emit(state.copyWith(newCurrentMarket: market,newSymbolTicksStatus: SymbolTicksInitial()));
  }

  /// call and state manage for symbol Ticks api call
  Future<void> callSymbolTicksApi(ActiveSymbols activeSymbols, String? ticksId) async {
    /// emit loading status
    emit(state.copyWith(newSymbolTicksStatus: SymbolTicksLoading()),);

    /// close ticks
    if(ticksId != null){
      await cancelTicks(ticksId);
    }

    /// get All Champion Data
    final DataState dataState = await priceTrackerRepository.fetchSymbolTicks(activeSymbols.symbol!);

    /// emit completed -- api call Success
    if(dataState is DataSuccess){
          emit(state.copyWith(
              newSymbolTicksStatus: SymbolTicksCompleted(dataState.data),
          ));
    }

    /// emit error --  api call Failed
    if(dataState is DataFailed){
      emit(state.copyWith(
        newSymbolTicksStatus: SymbolTicksError(dataState.error!),),);
    }
  }

  Future<void> cancelTicks(String ticksId) async {
    DataState dataState = await cancelSymbolTicksUseCase(ticksId);
  }


}
