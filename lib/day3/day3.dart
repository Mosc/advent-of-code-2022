import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final lines = File('lib/day3/input').readAsLinesSync();

  var part1 = await _calculatePart1(lines);

  print('Day 3');
  print('Part 1: $part1');
  print('');
}

Future<int> _calculatePart1(Iterable<String> lines) async {
  final compartments = lines.map((line) {
    final halfWay = line.length ~/ 2;
    return [line.substring(0, halfWay), line.substring(halfWay)]
        .map((splitLine) => splitLine.split('').toSet());
  });
  final duplicates = compartments.map(
    (compartment) => compartment.first.intersection(compartment.last).single,
  );
  return duplicates.map(
    (duplicate) {
      final isUpper = duplicate == duplicate.toUpperCase();
      return duplicate.codeUnits.single -
          (isUpper ? 'A' : 'a').codeUnits.single +
          (isUpper ? 26 : 0) +
          1;
    },
  ).sum;
}
