import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day25 extends Day<List<String>, String> {
  const Day25() : super(25);

  static const digits = ['=', '-', '0', '1', '2'];
  static final zeroIndex = digits.indexOf(0.toString());

  @override
  String processPart1(List<String> input) =>
      _toSnafu(input.map(_toDecimal).sum);

  int _toDecimal(String snafu) => snafu.split('').fold(
        0,
        (previous, digit) =>
            previous * digits.length + digits.indexOf(digit) - zeroIndex,
      );

  String _toSnafu(int decimal) => decimal > 0
      ? _toSnafu((decimal + zeroIndex) ~/ digits.length) +
          digits[(decimal + zeroIndex) % digits.length]
      : '';
}
