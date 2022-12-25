import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day25 extends Day<List<String>, String> {
  const Day25() : super(25);

  static const snafuDigits = ['=', '-', '0', '1', '2'];
  static final zeroIndex = snafuDigits.indexOf(0.toString());

  @override
  String processPart1(List<String> input) =>
      _toSnafu(input.map(_toDecimal).sum);

  int _toDecimal(String snafu) => snafu
      .split('')
      .reversed
      .mapIndexed(
        (i, digit) =>
            pow(snafuDigits.length, i).toInt() *
            (snafuDigits.indexOf(digit) - zeroIndex),
      )
      .sum;

  String _toSnafu(int decimal) {
    var result = '';

    while (decimal > 0) {
      final index = (decimal + zeroIndex) % snafuDigits.length;
      result = snafuDigits[index] + result;
      decimal = (decimal - index + zeroIndex) ~/ snafuDigits.length;
    }

    return result;
  }
}
