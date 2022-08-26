part of 'price_tracker_cubit.dart';

@immutable
abstract class SymbolTicksStatus extends Equatable{}

class SymbolTicksInitial extends SymbolTicksStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SymbolTicksLoading extends SymbolTicksStatus {
  @override
  List<Object?> get props => [];
}

class SymbolTicksCompleted extends SymbolTicksStatus {
  final TickEntity tickEntity;
  SymbolTicksCompleted(this.tickEntity);

  @override
  List<Object?> get props => [tickEntity];
}

class SymbolTicksError extends SymbolTicksStatus {
  final String errorMessage;
  SymbolTicksError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
