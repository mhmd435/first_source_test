import 'package:first_source_test/features/feature_price_tracker/domain/entities/tick_entity.dart';

/// echo_req : {"subscribe":1,"ticks":"R_50"}
/// msg_type : "tick"
/// subscription : {"id":"1ef7334b-252f-ede0-e262-385237f422ba"}
/// tick : {"ask":232.4234,"bid":232.4034,"epoch":1661542766,"id":"1ef7334b-252f-ede0-e262-385237f422ba","pip_size":4,"quote":232.4134,"symbol":"R_50"}

class TickModel extends TickEntity{
  const TickModel({
    EchoReq? echoReq,
    String? msgType,
    Subscription? subscription,
    Tick? tick,
    TickError? error}) : super(
    echoReq: echoReq,
    msgType: msgType,
    subscription: subscription,
    tick: tick,
    tickError : error
  );

  factory TickModel.fromJson(dynamic json) {
    return TickModel(
      echoReq: json['echo_req'] != null ? EchoReq.fromJson(json['echo_req']) : null,
      msgType: json['msg_type'],
      subscription: json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null,
      tick: json['tick'] != null ? Tick.fromJson(json['tick']) : null,
      error: json['error'] != null ? TickError.fromJson(json['error']) : null
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (echoReq != null) {
      map['echo_req'] = echoReq?.toJson();
    }
    map['msg_type'] = msgType;
    if (subscription != null) {
      map['subscription'] = subscription?.toJson();
    }
    if (tick != null) {
      map['tick'] = tick?.toJson();
    }
    return map;
  }

}

/// ask : 232.4234
/// bid : 232.4034
/// epoch : 1661542766
/// id : "1ef7334b-252f-ede0-e262-385237f422ba"
/// pip_size : 4
/// quote : 232.4134
/// symbol : "R_50"

class Tick {
  Tick({
      this.ask, 
      this.bid, 
      this.epoch, 
      this.id, 
      this.pipSize, 
      this.quote, 
      this.symbol,});

  Tick.fromJson(dynamic json) {
    ask = json['ask'].toDouble();
    bid = json['bid'].toDouble();
    epoch = json['epoch'];
    id = json['id'];
    pipSize = json['pip_size'];
    quote = json['quote'].toDouble();
    symbol = json['symbol'];
  }
  double? ask;
  double? bid;
  int? epoch;
  String? id;
  int? pipSize;
  double? quote;
  String? symbol;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ask'] = ask;
    map['bid'] = bid;
    map['epoch'] = epoch;
    map['id'] = id;
    map['pip_size'] = pipSize;
    map['quote'] = quote;
    map['symbol'] = symbol;
    return map;
  }

}

class TickError {
  TickError({
    this.code,
    this.details,
    this.message,});

  TickError.fromJson(dynamic json) {
    code = json['code'];
    details = json['details'] != null ? Details.fromJson(json['details']) : null;
    message = json['message'];
  }
  String? code;
  Details? details;
  String? message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    if (details != null) {
      map['details'] = details?.toJson();
    }
    map['message'] = message;
    return map;
  }

}

/// field : "symbol"

class Details {
  Details({
    this.field,});

  Details.fromJson(dynamic json) {
    field = json['field'];
  }
  String? field;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['field'] = field;
    return map;
  }

}

/// id : "1ef7334b-252f-ede0-e262-385237f422ba"

class Subscription {
  Subscription({
      this.id,});

  Subscription.fromJson(dynamic json) {
    id = json['id'];
  }
  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }

}

/// subscribe : 1
/// ticks : "R_50"

class EchoReq {
  EchoReq({
      this.subscribe, 
      this.ticks,});

  EchoReq.fromJson(dynamic json) {
    subscribe = json['subscribe'];
    ticks = json['ticks'];
  }
  int? subscribe;
  String? ticks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['subscribe'] = subscribe;
    map['ticks'] = ticks;
    return map;
  }

}