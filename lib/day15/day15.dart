import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day15 extends Day<Map<Point<int>, Point<int>>, int> {
  const Day15() : super(15);

  @override
  Map<Point<int>, Point<int>> preprocess(List<String> input) {
    final beacons = <Point<int>, Point<int>>{};

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
      beacons[sensor] = beacon;
    }

    return beacons;
  }

  @override
  int processPart1(Map<Point<int>, Point<int>> input) {
    final beacons = input.entries.toList(growable: false);
    final distances = input
        .map(
          (key, value) => MapEntry(key, key.manhattanDistanceTo(value)),
        )
        .entries
        .toList(growable: false);

    final minX = distances.map((entry) => entry.key.x - entry.value).min;
    final maxX = distances.map((entry) => entry.key.x + entry.value).max;
    final y = example ? 10 : 2000000;

    return Iterable.generate(maxX - minX + 1, (index) => minX + index)
        .where(
          (x) => beacons.any(
            (entry) =>
                entry.key.manhattanDistanceTo(Point(x, y)) <=
                    entry.key.manhattanDistanceTo(entry.value) &&
                Point(x, y) != entry.value,
          ),
        )
        .length;
  }

  @override
  int processPart2(Map<Point<int>, Point<int>> input) {
    final distances = input
        .map(
          (key, value) => MapEntry(key, key.manhattanDistanceTo(value)),
        )
        .entries
        .toList(growable: false);

    const minXY = 0;
    final maxXY = example ? 20 : 4000000;
    const xMultiplier = 4000000;

    for (int x = minXY; x <= maxXY; x++) {
      for (int y = minXY; y <= maxXY; y++) {
        final point = Point(x, y);
        final overlap = distances.firstWhereOrNull(
          (entry) => entry.key.manhattanDistanceTo(point) <= entry.value,
        );

        if (overlap == null) {
          return x * xMultiplier + y;
        }

        y = overlap.key.y + overlap.value - (overlap.key.x - x).abs();
      }
    }

    throw Exception();
  }
}

extension _IntPointExtension on Point<int> {
  int manhattanDistanceTo(Point<int> other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return dx.abs() + dy.abs();
  }
}
