import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:first_source_test/core/resources/data_state.dart';
import 'package:first_source_test/core/usecases/usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/symbol_model.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/tick_model.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/entities/symbol_entity.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/entities/tick_entity.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/cancel_symbol_ticks_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/get_all_symbols_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/usecases/get_symbol_ticks_usecase.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/utils/color_handler.dart';
import 'package:flutter/material.dart';

part 'all_symbols_status.dart';
part 'price_tracker_state.dart';
part 'symbol_ticks_status.dart';

class PriceTrackerCubit extends Cubit<PriceTrackerState> {
  GetAllSymbolsUseCase getAllSymbolsUseCase;
  GetSymbolTicksUseCase getSymbolTicksUseCase;
  CancelSymbolTicksUseCase cancelSymbolTicksUseCase;
  String? ticksId;
  double? prevPrice;
  String? prevTick;
  bool shouldCheck = false;

  PriceTrackerCubit(
      this.getAllSymbolsUseCase,
      this.getSymbolTicksUseCase,
      this.cancelSymbolTicksUseCase,) : super(PriceTrackerState(
    allSymbolsStatus: AllSymbolsLoading(),
    currentMarket: "",
    symbolTicksStatus: SymbolTicksInitial(),
    priceColor: Colors.grey,
  ),);

  /// call and state manage for symbol api call
  Future<void> callSymbolsApi() async {

    /// emit loading status
    emit(state.copyWith(
      newAllSymbolsStatus: AllSymbolsLoading(),),);

    /// get All Champion Data
    final DataState dataState = await getAllSymbolsUseCase(NoParams());


    /// emit completed -- api call Success
    if(dataState is DataSuccess){
      final Stream data = dataState.data;

      /// listen to api stream
      data.listen((event) {
        /// serialization
        final SymbolEntity symbolEntity = SymbolModel.fromJson(jsonDecode(event));

        emit(state.copyWith(
            newAllSymbolsStatus: AllSymbolsCompleted(symbolEntity.activeSymbols!),
        ),);
      });

    }

    /// emit error --  api call Failed
    if(dataState is DataFailed){
      emit(state.copyWith(
        newAllSymbolsStatus: AllSymbolsError(dataState.error!),),);
    }
  }

  /// change market by dropDown and rebuild the second dropdown
  void changeMarket(String market) {

    /// close ticks
    if(ticksId != null){
      // استریم لغو میشود و از این پس باید بوسیله shouldCheck تمام emit های غیرمجاز بررسی شود
      // shouldCheck = true;
      cancelTicks(ticksId!);
    }

    emit(state.copyWith(newCurrentMarket: market,newSymbolTicksStatus: SymbolTicksInitial()));
  }

  /// call and state manage for symbol Ticks api call
  Future<void> callSymbolTicksApi(ActiveSymbols activeSymbols) async {

    /// close ticks
    if(ticksId != null){
      // استریم لغو میشود و از این پس باید بوسیله shouldCheck تمام emit های غیرمجاز بررسی شود
      shouldCheck = true;
      cancelTicks(ticksId!);
    }

    /// emit loading status
    emit(state.copyWith(
        newSymbolTicksStatus: SymbolTicksLoading(),),);

    /// get All Champion Data
    final DataState dataState = await getSymbolTicksUseCase(activeSymbols.symbol!);

    /// emit completed -- api call Success
    if(dataState is DataSuccess){
      Stream tickStream = dataState.data;

      /// listen to api stream
      tickStream.listen((event) {

        /// serialization
        final TickEntity tickEntity = TickModel.fromJson(jsonDecode(event));

        /// error handling
        if(tickEntity.tickError != null){
            emit(state.copyWith(
                newSymbolTicksStatus: SymbolTicksError(tickEntity.tickError!.message!),
            ),);

        }else{
          /// get tick id for cancel --- next time
          ticksId = tickEntity.tick!.id;

          /// manage color of price text
          final Color color = ColorHandler.getColor(tickEntity.tick!.quote!, prevPrice);
          /// update prevPrice
          prevPrice = tickEntity.tick!.quote;

          /// what is shouldCheck ->
          /*
           چون ممکن است بعد درخواست لغو استریم همچنان استریمی که درحال گوش داده شدن است یک emit بزند
            متغیری بنام shouldCheck قرار دادم
           و زمانی که دستور لغو استریم آمد true میشود
           و اطمینان حاصل میکند تا زمانی که symbol جدید نیامده تمام emit ها از نوع loading باشد
           */
          if(shouldCheck){
            /// same symbol after emit
            // بعد از لغو استریم اگر tick قبلی و کنونی یکی بود یعنی یک emit غیرمجاز از symbol قبلی دریافت شده
            // پس نباید نمایش داده شود و باید همچنان loading را نمایش دهد
            if(prevTick == tickEntity.echoReq!.ticks){
              emit(state.copyWith(
                  newSymbolTicksStatus: SymbolTicksLoading(),
              ),);

              // اگر بعد از لغو استریم tick قبلی و کنونی یکی نبود یعنی با موفقیت symbol جدید دریافت شده
              // و باید به حالت completed برویم با اطلاعات جدید
            }else{
              shouldCheck = false;

              emit(state.copyWith(
                  newSymbolTicksStatus: SymbolTicksCompleted(tickEntity),
                  newPriceColor: color,
              ),);
            }


            // اگر shouldCheck این قسمت false بود یعنی استریم فعال است و باید طبق روال قبل tick های جدید رو دریافت کند
          }else{
            emit(state.copyWith(
                newSymbolTicksStatus: SymbolTicksCompleted(tickEntity),
                newPriceColor: color,
            ),);
          }

          /// update preTick
          prevTick = tickEntity.echoReq!.ticks;


        }
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
