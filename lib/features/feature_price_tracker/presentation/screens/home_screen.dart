
import 'package:first_source_test/config/strings.dart';
import 'package:first_source_test/features/feature_price_tracker/data/models/symbol_model.dart';
import 'package:first_source_test/features/feature_price_tracker/domain/entities/tick_entity.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/price_tracker_cubit/price_tracker_cubit.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/utils/data_cleaner.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/widgets/dot_loading_widget.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormFieldState> symbolDropDownKey = GlobalKey();

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
            final marketData = DataCleaner.getAllMarketNames(data);


            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20,),

                  /// market DropDown
                  DropdownButtonFormField<String>(
                    hint: Text("select a market", style: textTheme.titleSmall,),
                    onChanged: (String? value){
                      /// reset the second dropDown to init state --- show 'select a symbol'
                      symbolDropDownKey.currentState?.reset();
                      /// change market and second dropDown State
                      BlocProvider.of<PriceTrackerCubit>(context).changeMarket(value!);
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
                      final List<ActiveSymbols> symbols = DataCleaner.getAllSymbolsFromMarketName(data, state.currentMarket);

                      return DropdownButtonFormField<ActiveSymbols>(
                        key: symbolDropDownKey,
                        hint: Text("select a Symbol", style: textTheme.titleSmall,),
                        menuMaxHeight: 400,
                        onChanged: (ActiveSymbols? value){
                          /// call tick api for showing price
                          BlocProvider.of<PriceTrackerCubit>(context).callSymbolTicksApi(value!);
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
                        final TickEntity tickEntity = symbolTicksCompleted.tickEntity;

                        return Text(tickEntity.tick!.quote!.toString() , style: textTheme.titleSmall?.apply(fontSizeDelta: 2,color: state.priceColor),);
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
}
