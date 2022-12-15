import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day15 extends Day<List<String>, int> {
  const Day15() : super(15);

  @override
  int processPart1(List<String> input) {
    const y = 2000000;
    final sensors = <Point<int>, Point<int>>{};

    for (final line in input) {
      final xMatches = RegExp(r'x=(-?\d+)')
          .allMatches(line)
          .map((match) => match.group(1)!)
          .map(int.parse);
      final yMatches = RegExp(r'y=(-?\d+)')
          .allMatches(line)
          .map((match) => match.group(1)!)
          .map(int.parse);
      final sensor = Point(xMatches.first, yMatches.first);
      final beacon = Point(xMatches.last, yMatches.last);
      sensors[sensor] = beacon;
    }

    final minX = sensors.entries
        .map(
          (entry) => entry.key.x - entry.key.manhattanDistanceTo(entry.value),
        )
        .min;
    final maxX = sensors.entries
        .map(
          (entry) => entry.key.x + entry.key.manhattanDistanceTo(entry.value),
        )
        .max;
    return Iterable.generate(maxX - minX + 1, (index) => minX + index)
        .where(
          (x) => sensors.entries.any(
            (entry) =>
                entry.key.manhattanDistanceTo(Point(x, y)) <=
                    entry.key.manhattanDistanceTo(entry.value) &&
                Point(x, y) != entry.value,
          ),
        )
        .length;
  }
}

extension _IntPointExtension on Point<int> {
  int manhattanDistanceTo(Point<int> other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return dx.abs() + dy.abs();
  }
}
