import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final line = File('lib/day6/input').readAsStringSync();

  var part1 = await _calculatePart1(line);
  var part2 = await _calculatePart2(line);

  print('Day 6');
  print('Part 1: $part1');
  print('Part 2: $part2');
  print('');
}

Future<int> _calculatePart1(String line) async {
  return _findMarker(line, markerLength: 4);
}

Future<int> _calculatePart2(String line) async {
  return _findMarker(line, markerLength: 14);
}

int _findMarker(String line, {required int markerLength}) {
  final markerCandidates = line
      .substring(0, line.length - markerLength + 1)
      .codeUnits
      .mapIndexed((index, _) => line.substring(index, index + markerLength));
  return markerCandidates
          .map((candidate) => candidate.codeUnits.toSet().length)
          .toList()
          .indexOf(markerLength) +
      markerLength;
}
