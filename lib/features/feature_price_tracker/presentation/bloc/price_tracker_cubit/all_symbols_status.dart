part of 'price_tracker_cubit.dart';

@immutable
abstract class AllSymbolsStatus extends Equatable{}

class AllSymbolsLoading extends AllSymbolsStatus {
  @override
  List<Object?> get props => [];
}

class AllSymbolsCompleted extends AllSymbolsStatus {
  final List<ActiveSymbols> data;
  AllSymbolsCompleted(this.data);

  @override
  List<Object?> get props => [data];
}

class AllSymbolsError extends AllSymbolsStatus {
  final String errorMessage;
  AllSymbolsError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
