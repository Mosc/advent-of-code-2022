import 'dart:io';

import 'package:collection/collection.dart';

Future<void> calculate() async {
  final lines = File('lib/day1/input').readAsLinesSync();

  final caloriesPerElf =
      lines.split((line) => line.isEmpty).map((line) => line.map(int.parse));
  final caloriesSumsPerElf = caloriesPerElf.map((calories) => calories.sum);

  var part1 = await _calculatePart1(caloriesSumsPerElf);
  var part2 = await _calculatePart2(caloriesSumsPerElf);

  print('Day 1');
  print('Part 1: $part1');
  print('Part 2: $part2');
  print('');
}

Future<int> _calculatePart1(Iterable<int> caloriesSums) async {
  return caloriesSums.max;
}

Future<int> _calculatePart2(Iterable<int> caloriesSums) async {
  return caloriesSums.sorted((a, b) => b.compareTo(a)).take(3).sum;
}

extension _Iterablextension<T> on Iterable<T> {
  Iterable<Iterable<T>> split(bool Function(T) on) sync* {
    final List<T> innerList = [];

    for (final row in this) {
      if (!on(row)) {
        innerList.add(row);
      } else if (innerList.isNotEmpty) {
        yield innerList;
        innerList.clear();
      }
    }

    if (innerList.isNotEmpty) {
      yield innerList;
    }
  }
}
