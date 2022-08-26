import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:first_source_test/core/usecases/usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/tick_model.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/entities/tick_entity.dart';
import 'package:flutter/material.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../data/models/symbol_model.dart';
import '../../../domain/entities/symbol_entity.dart';
import '../../../domain/usecases/cancel_symbol_ticks_usecase.dart';
import '../../../domain/usecases/get_all_symbols_usecase.dart';
import '../../../domain/usecases/get_symbol_ticks_usecase.dart';

part 'all_symbols_status.dart';
part 'price_tracker_state.dart';
part 'symbol_ticks_status.dart';

class PriceTrackerCubit extends Cubit<PriceTrackerState> {
  GetAllSymbolsUseCase getAllSymbolsUseCase;
  GetSymbolTicksUseCase getSymbolTicksUseCase;
  CancelSymbolTicksUseCase cancelSymbolTicksUseCase;
  String? ticksId;


  PriceTrackerCubit(
      this.getAllSymbolsUseCase,
      this.getSymbolTicksUseCase,
      this.cancelSymbolTicksUseCase) : super(PriceTrackerState(
    allSymbolsStatus: AllSymbolsLoading(),
    currentMarket: "",
    symbolTicksStatus: SymbolTicksInitial()
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
  void changeMarket(String market) => emit(state.copyWith(newCurrentMarket: market));

  /// call and state manage for symbol Ticks api call
  Future<void> callSymbolTicksApi(ActiveSymbols activeSymbols) async {
    
    /// close ticks
    if(ticksId != null){
      cancelTicks(ticksId!);
    }

    /// emit loading status
    emit(state.copyWith(
        newSymbolTicksStatus: SymbolTicksLoading()),);



    /// get All Champion Data
    final DataState dataState = await getSymbolTicksUseCase(activeSymbols.symbol!);


    /// emit completed -- api call Success
    if(dataState is DataSuccess){
      Stream tickStream = dataState.data;

      /// listen to api stream
      tickStream.listen((event) {
        /// serialization
        final TickEntity tickEntity = TickModel.fromJson(jsonDecode(event));
        /// get tick id for cancel --- next time
        ticksId = tickEntity.tick!.id;

        emit(state.copyWith(
          newSymbolTicksStatus: SymbolTicksCompleted(tickEntity),
        ));
      });

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
