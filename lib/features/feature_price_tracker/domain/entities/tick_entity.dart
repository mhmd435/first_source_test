
import 'package:equatable/equatable.dart';
import '../../data/models/tick_model.dart';

class TickEntity extends Equatable {

  final EchoReq? echoReq;
  final String? msgType;
  final Subscription? subscription;
  final Tick? tick;

  const TickEntity({this.echoReq, this.msgType, this.subscription, this.tick});

  @override
  // TODO: implement props
  List<Object?> get props => [
    echoReq,
    msgType,
    subscription,
    tick
  ];

}