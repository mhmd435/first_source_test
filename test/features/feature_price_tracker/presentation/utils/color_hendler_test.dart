
import 'package:first_source_test/features/feature_price_tracker/presentation/utils/color_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

  group('get color test', () {

    test('green color', () {

      var result = ColorHandler.getColor(2, 1);

      expect(result, Colors.green);
    });

    test('red color', () {

      var result = ColorHandler.getColor(1, 2);

      expect(result, Colors.red);
    });

    test('grey color', () {

      var result = ColorHandler.getColor(1, 1);

      expect(result, Colors.grey);
    });
  });
}