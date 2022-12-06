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

int _findMarker(String line, {required int markerLength}) =>
    line.codeUnits
        .sublist(0, line.length - markerLength + 1)
        .mapIndexed(
          (index, _) => MapEntry(
            index,
            line.codeUnits.sublist(index, index + markerLength).toSet().length,
          ),
        )
        .firstWhere((indexedLength) => indexedLength.value == markerLength)
        .key +
    markerLength;
