part of 'price_tracker_cubit.dart';

class PriceTrackerState extends Equatable{
  final AllSymbolsStatus allSymbolsStatus;
  final String currentMarket;
  final SymbolTicksStatus symbolTicksStatus;
  final Color priceColor;

  const PriceTrackerState({
    required this.allSymbolsStatus,
    required this.currentMarket,
    required this.symbolTicksStatus,
    required this.priceColor
  });


  PriceTrackerState copyWith({
    AllSymbolsStatus? newAllSymbolsStatus,
    String? newCurrentMarket,
    SymbolTicksStatus? newSymbolTicksStatus,
    Color? newPriceColor,
  }){
    return PriceTrackerState(
        allSymbolsStatus: newAllSymbolsStatus ?? allSymbolsStatus,
        currentMarket: newCurrentMarket ?? currentMarket,
        symbolTicksStatus: newSymbolTicksStatus ?? symbolTicksStatus,
        priceColor: newPriceColor ?? priceColor
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    allSymbolsStatus,
    currentMarket,
    symbolTicksStatus
  ];

}
