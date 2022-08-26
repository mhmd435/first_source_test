part of 'price_tracker_cubit.dart';

class PriceTrackerState extends Equatable{
  final AllSymbolsStatus allSymbolsStatus;
  final String currentMarket;
  final SymbolTicksStatus symbolTicksStatus;

  const PriceTrackerState({
    required this.allSymbolsStatus,
    required this.currentMarket,
    required this.symbolTicksStatus
  });


  PriceTrackerState copyWith({
    AllSymbolsStatus? newAllSymbolsStatus,
    String? newCurrentMarket,
    SymbolTicksStatus? newSymbolTicksStatus
  }){
    return PriceTrackerState(
        allSymbolsStatus: newAllSymbolsStatus ?? allSymbolsStatus,
        currentMarket: newCurrentMarket ?? currentMarket,
        symbolTicksStatus: newSymbolTicksStatus ?? symbolTicksStatus
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
