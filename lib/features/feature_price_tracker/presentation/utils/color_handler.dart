
import 'package:flutter/material.dart';

class ColorHandler {

  static Color getColor(double currentPrice, prevPrice){
    Color color = Colors.grey;

    if(prevPrice != null){
      if(prevPrice! > currentPrice){
        color = Colors.red;
      }else if(prevPrice! < currentPrice){
        color = Colors.green;
      }else{
        color = Colors.grey;
      }
    }

    return color;
  }
}