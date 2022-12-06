import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final line = File('lib/day6/input').readAsStringSync();

  var part1 = await _calculatePart1(line);

  print('Day 6');
  print('Part 1: $part1');
  print('');
}

Future<int> _calculatePart1(String line) async {
  const markerLength = 4;
  final markerCandidates = line
      .substring(0, line.length - markerLength + 1)
      .codeUnits
      .mapIndexed((index, _) => line.substring(index, index + markerLength));
  return markerCandidates
          .map((e) => e.codeUnits.toSet().length)
          .toList()
          .indexOf(markerLength) +
      markerLength;
}
