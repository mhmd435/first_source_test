
import 'dart:convert';

import 'package:first_source_test/config/strings.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/symbol_model.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/tick_model.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/entities/tick_entity.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/price_tracker_cubit/price_tracker_cubit.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/utils/data_cleaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../widgets/dot_loading_widget.dart';
import '../widgets/theme_switcher.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormFieldState> symbolDropDownKey = GlobalKey();
  WebSocketChannel? tickChannel;
  double? prevPrice;
  String? prevTick;
  bool shouldCheck = false;
  String? ticksId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// call symbol api
    BlocProvider.of<PriceTrackerCubit>(context).callSymbolsApi();
  }

  @override
  Widget build(BuildContext context) {

    /// get theme
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,

      /// appbar
      appBar: AppBar(
        title: const Text(Strings.appName),
        centerTitle: true,
        actions: const [
          /// theme switch IconBtn
          ThemeSwitcher(),
        ],
      ),


      /// body
      body: BlocBuilder<PriceTrackerCubit, PriceTrackerState>(
        builder: (context, state){

          /// show loading state
          if(state.allSymbolsStatus is AllSymbolsLoading){
            return const Center(
              child: DotLoadingWidget(size: 50,),
            );
          }

          /// show Completed state
          if(state.allSymbolsStatus is AllSymbolsCompleted){
            /// casting for getting data
            final AllSymbolsCompleted allSymbolsCompleted = state.allSymbolsStatus as AllSymbolsCompleted;
            final data = allSymbolsCompleted.data;

            /// get all Market names -- forex/cryptoCurrency/...
            var marketData = DataCleaner.getAllMarketNames(data);


            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20,),

                  /// market DropDown
                  DropdownButtonFormField<String>(
                    hint: Text("select a market", style: textTheme.titleSmall,),
                    onChanged: (String? value){
                      /// close tick channel
                      if(tickChannel != null){
                        tickChannel!.sink.close();
                        shouldCheck = true;
                      }
                      /// reset the second dropDown to init state --- show 'select a symbol'
                      symbolDropDownKey.currentState?.reset();
                      /// change market and second dropDown State
                      BlocProvider.of<PriceTrackerCubit>(context).changeMarket(value!, ticksId);
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // value: marketData[0],
                    selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                      return marketData.map((String value) {
                        return Text(value,style: textTheme.titleSmall);
                      }).toList();
                    },
                    items: marketData.map((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: textTheme.labelSmall,),);
                    }).toList(),
                  ),

                  const SizedBox(height: 20,),

                  /// symbol dropDown
                  BlocBuilder<PriceTrackerCubit, PriceTrackerState>(
                    /// just rebuild when Market changed
                  buildWhen: (previous, current){
                      if(previous.currentMarket == current.currentMarket){
                        return false;
                      }
                      return true;
                    },
                    builder: (context, state){
                      /// get all symbol by market name
                      List<ActiveSymbols> symbols = DataCleaner.getAllSymbolsFromMarketName(data, state.currentMarket);

                      return DropdownButtonFormField<ActiveSymbols>(
                        key: symbolDropDownKey,
                        hint: Text("select a Symbol", style: textTheme.titleSmall,),
                        menuMaxHeight: 400,
                        onChanged: (ActiveSymbols? value){
                          /// close tick channel
                          if(tickChannel != null){
                            tickChannel!.sink.close();
                            shouldCheck = true;
                          }
                          /// call tick api for showing price
                          BlocProvider.of<PriceTrackerCubit>(context).callSymbolTicksApi(value!,ticksId);
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        // value: symbols[0],
                        selectedItemBuilder: (BuildContext context) { //<-- SEE HERE
                          return symbols.map((ActiveSymbols value) {
                            return Text(value.displayName!,style: textTheme.titleSmall);
                          }).toList();
                        },
                        items: symbols.map((ActiveSymbols value){
                          return DropdownMenuItem<ActiveSymbols>(
                            value: value,
                            child: Text(value.displayName!,style: textTheme.labelSmall,),);
                        }).toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 40,),

                  /// price
                  BlocBuilder<PriceTrackerCubit, PriceTrackerState>(
                    /// just rebuild when symbolTicks changed
                    buildWhen: (previous, current){
                      if(previous.symbolTicksStatus == current.symbolTicksStatus){
                        return false;
                      }
                      return true;
                    },
                    builder: (context, state) {

                      /// show loading state
                      if(state.symbolTicksStatus is SymbolTicksLoading){
                        return const Center(
                          child: DotLoadingWidget(size: 30,),
                        );
                      }

                      /// show Completed state
                      if(state.symbolTicksStatus is SymbolTicksCompleted){
                        /// casting for getting data
                        final SymbolTicksCompleted symbolTicksCompleted = state.symbolTicksStatus as SymbolTicksCompleted;
                        tickChannel = symbolTicksCompleted.tickChannel;

                        return StreamBuilder(
                          stream: tickChannel!.stream,
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              final TickEntity tickEntity = TickModel.fromJson(jsonDecode(snapshot.data.toString()));

                              if(shouldCheck){
                                if(prevTick == tickEntity.echoReq!.ticks){
                                  shouldCheck = false;
                                  return const Center(
                                    child: DotLoadingWidget(size: 30),
                                  );
                                }
                              }

                              if(tickEntity.tickError != null){
                                return Text(tickEntity.tickError!.message! , style: textTheme.titleSmall?.apply(fontSizeDelta: 2),);
                              }else{
                                /// manage color of price text
                                Color color = Colors.grey;
                                if(prevPrice != null){
                                  color = getColor(tickEntity);
                                }

                                prevPrice = tickEntity.tick!.quote;
                                prevTick = tickEntity.echoReq!.ticks;
                                ticksId = tickEntity.tick!.id!;
                                return Text(tickEntity.tick!.quote!.toString() , style: textTheme.titleSmall?.apply(fontSizeDelta: 2,color: color),);
                              }
                            }else{
                              return const Center(
                                child: DotLoadingWidget(size: 30),
                              );
                            }
                          }
                        );
                      }

                      /// show Error state
                      if(state.symbolTicksStatus is SymbolTicksError){
                        final SymbolTicksError symbolTickError = state.symbolTicksStatus as SymbolTicksError;

                        return Center(
                          child: Text(symbolTickError.errorMessage,style: textTheme.titleSmall,),
                        );
                      }

                      /// for initial state
                      return Container();
                    },
                  ),

                ],
              ),
            );
          }

          /// show Error state
          if(state.allSymbolsStatus is AllSymbolsError){
            final AllSymbolsError allSymbolsError = state.allSymbolsStatus as AllSymbolsError;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text(allSymbolsError.errorMessage,style: GoogleFonts.ubuntu(color: Colors.white,fontSize: 15),),
                  const SizedBox(height: 12,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor,
                    ),
                    onPressed: (){
                      /// call symbol data again
                      BlocProvider.of<PriceTrackerCubit>(context).callSymbolsApi();
                    },
                    child: const Text(Strings.reload),)
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Color getColor(TickEntity tickEntity) {
    double currentPrice = tickEntity.tick!.quote!;
    if(prevPrice! > currentPrice){
      return Colors.red;
    }else if(prevPrice! < currentPrice){
      return Colors.green;
    }else{
      return Colors.grey;
    }
  }
}
