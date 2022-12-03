import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final lines = File('lib/day3/input').readAsLinesSync();

  var part1 = await _calculatePart1(lines);
  var part2 = await _calculatePart2(lines);

  print('Day 3');
  print('Part 1: $part1');
  print('Part 2: $part2');
  print('');
}

Future<int> _calculatePart1(Iterable<String> lines) async {
  final compartments = lines.map((line) {
    final halfWay = line.length ~/ 2;
    return [
      line.substring(0, halfWay),
      line.substring(halfWay),
    ].map((splitLine) => splitLine.split('').toSet());
  });
  final duplicates = compartments.map(
    (compartment) => compartment.first.intersection(compartment.last).single,
  );
  return _sumDuplicatePriorities(duplicates);
}

Future<int> _calculatePart2(Iterable<String> lines) async {
  final groups = lines
      .toList()
      .asMap()
      .entries
      .groupListsBy((indexedLine) => indexedLine.key ~/ 3)
      .values
      .map(
        (indexedGroup) => indexedGroup.map(
          (indexedLine) => indexedLine.value.split('').toSet(),
        ),
      );
  final duplicates = groups.map(
    (group) => group
        .fold(
          group.first,
          (previous, current) => previous.intersection(current),
        )
        .single,
  );
  return _sumDuplicatePriorities(duplicates);
}

int _sumDuplicatePriorities(Iterable<String> duplicates) => duplicates.map(
      (duplicate) {
        final isUpper = duplicate == duplicate.toUpperCase();
        return duplicate.codeUnits.single -
            (isUpper ? 'A' : 'a').codeUnits.single +
            (isUpper ? 26 : 0) +
            1;
      },
    ).sum;
