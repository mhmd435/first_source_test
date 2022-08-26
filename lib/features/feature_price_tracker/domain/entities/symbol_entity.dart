
import 'package:equatable/equatable.dart';

import '../../data/models/symbol_model.dart';

class SymbolEntity extends Equatable{
  final List<ActiveSymbols>? activeSymbols;
  final EchoReq? echoReq;
  final String? msgType;

  const SymbolEntity({this.activeSymbols, this.echoReq, this.msgType});

  @override
  // TODO: implement props
  List<Object?> get props => [
    activeSymbols,
    echoReq,
    msgType
  ];

}