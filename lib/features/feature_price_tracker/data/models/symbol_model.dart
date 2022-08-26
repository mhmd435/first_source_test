import 'package:first_source_test/features/feature_price_tracker/domain/entities/symbol_entity.dart';

/// active_symbols : [{"allow_forward_starting":0,"display_name":"AUD/JPY","exchange_is_open":1,"is_trading_suspended":0,"market":"forex","market_display_name":"Forex","pip":0.001,"submarket":"major_pairs","submarket_display_name":"Major Pairs","symbol":"frxAUDJPY","symbol_type":"forex"}]
/// echo_req : {"active_symbols":"brief","product_type":"basic"}
/// msg_type : "active_symbols"

class SymbolModel extends SymbolEntity{

  const SymbolModel({
    List<ActiveSymbols>? activeSymbols,
    EchoReq? echoReq,
    String? msgType,}) : super(
    activeSymbols: activeSymbols,
    echoReq: echoReq,
    msgType: msgType
  );

  factory SymbolModel.fromJson(dynamic json) {
    List<ActiveSymbols>? activeSymbols = [];
    if (json['active_symbols'] != null) {
      json['active_symbols'].forEach((v) {
        activeSymbols.add(ActiveSymbols.fromJson(v));
      });
    }

    return SymbolModel(
      activeSymbols: activeSymbols,
      echoReq: json['echo_req'] != null ? EchoReq.fromJson(json['echo_req']) : null,
      msgType: json['msg_type']
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (activeSymbols != null) {
      map['active_symbols'] = activeSymbols?.map((v) => v.toJson()).toList();
    }
    if (echoReq != null) {
      map['echo_req'] = echoReq?.toJson();
    }
    map['msg_type'] = msgType;
    return map;
  }

}

/// active_symbols : "brief"
/// product_type : "basic"

class EchoReq {
  EchoReq({
      this.activeSymbols, 
      this.productType,});

  EchoReq.fromJson(dynamic json) {
    activeSymbols = json['active_symbols'];
    productType = json['product_type'];
  }
  String? activeSymbols;
  String? productType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['active_symbols'] = activeSymbols;
    map['product_type'] = productType;
    return map;
  }

}

/// allow_forward_starting : 0
/// display_name : "AUD/JPY"
/// exchange_is_open : 1
/// is_trading_suspended : 0
/// market : "forex"
/// market_display_name : "Forex"
/// pip : 0.001
/// submarket : "major_pairs"
/// submarket_display_name : "Major Pairs"
/// symbol : "frxAUDJPY"
/// symbol_type : "forex"

class ActiveSymbols {
  ActiveSymbols({
      this.allowForwardStarting, 
      this.displayName, 
      this.exchangeIsOpen, 
      this.isTradingSuspended, 
      this.market, 
      this.marketDisplayName, 
      this.pip, 
      this.submarket, 
      this.submarketDisplayName, 
      this.symbol, 
      this.symbolType,});

  ActiveSymbols.fromJson(dynamic json) {
    allowForwardStarting = json['allow_forward_starting'];
    displayName = json['display_name'];
    exchangeIsOpen = json['exchange_is_open'];
    isTradingSuspended = json['is_trading_suspended'];
    market = json['market'];
    marketDisplayName = json['market_display_name'];
    pip = json['pip'];
    submarket = json['submarket'];
    submarketDisplayName = json['submarket_display_name'];
    symbol = json['symbol'];
    symbolType = json['symbol_type'];
  }
  int? allowForwardStarting;
  String? displayName;
  int? exchangeIsOpen;
  int? isTradingSuspended;
  String? market;
  String? marketDisplayName;
  double? pip;
  String? submarket;
  String? submarketDisplayName;
  String? symbol;
  String? symbolType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['allow_forward_starting'] = allowForwardStarting;
    map['display_name'] = displayName;
    map['exchange_is_open'] = exchangeIsOpen;
    map['is_trading_suspended'] = isTradingSuspended;
    map['market'] = market;
    map['market_display_name'] = marketDisplayName;
    map['pip'] = pip;
    map['submarket'] = submarket;
    map['submarket_display_name'] = submarketDisplayName;
    map['symbol'] = symbol;
    map['symbol_type'] = symbolType;
    return map;
  }

}