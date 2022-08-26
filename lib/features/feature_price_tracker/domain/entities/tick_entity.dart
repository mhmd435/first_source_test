
import 'package:equatable/equatable.dart';
import '../../data/models/tick_model.dart';

class TickEntity extends Equatable {

  final EchoReq? echoReq;
  final String? msgType;
  final Subscription? subscription;
  final Tick? tick;
  final TickError? tickError;

  const TickEntity({this.echoReq, this.msgType, this.subscription, this.tick,this.tickError});

  @override
  // TODO: implement props
  List<Object?> get props => [
    echoReq,
    msgType,
    subscription,
    tick,
    tickError
  ];

}