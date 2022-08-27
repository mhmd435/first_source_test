
import 'package:flutter/material.dart';
import '../../domain/entities/tick_entity.dart';

class ColorHandler {

  static Color getColor(TickEntity tickEntity, prevPrice){
    Color color = Colors.grey;

    double currentPrice = tickEntity.tick!.quote!;
    if(prevPrice! > currentPrice){
      color = Colors.red;
    }else if(prevPrice! < currentPrice){
      color = Colors.green;
    }else{
      color = Colors.grey;
    }

    return color;
  }
}