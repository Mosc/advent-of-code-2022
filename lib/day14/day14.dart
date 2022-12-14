import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day14 extends Day<List<String>, int> {
  const Day14() : super(14);

  @override
  int processPart1(List<String> input) {
    const startingPoint = Point(500, 0);

    final map = <int, Map<int, Element>>{};

    for (final line in input) {
      final rockLines = line
          .split(' -> ')
          .map((point) => point.split(',').map(int.parse))
          .map((coordinates) => Point(coordinates.first, coordinates.last))
          .toList();

      for (int i = 0; i < rockLines.length - 1; i++) {
        final from = rockLines[i];
        final to = rockLines[i + 1];

        if (from.x == to.x) {
          for (int j = min(from.y, to.y); j <= max(from.y, to.y); j++) {
            if (map[j] == null) {
              map[j] = <int, Element>{};
            }

            map[j]![from.x] = Element.rock;
          }
        } else {
          for (int j = min(from.x, to.x); j <= max(from.x, to.x); j++) {
            if (map[from.y] == null) {
              map[from.y] = <int, Element>{};
            }

            map[from.y]![j] = Element.rock;
          }
        }
      }
    }

    var sandCount = 0;
    var fallingIntoAbyss = false;

    while (!fallingIntoAbyss) {
      var sandPoint = startingPoint;

      while (true) {
        if (sandPoint.y >= map.keys.max) {
          fallingIntoAbyss = true;
          break;
        } else if (map[sandPoint.y + 1]?[sandPoint.x] == null) {
          sandPoint += Point(0, 1);
        } else if (map[sandPoint.y + 1]?[sandPoint.x - 1] == null) {
          sandPoint += Point(-1, 1);
        } else if (map[sandPoint.y + 1]?[sandPoint.x + 1] == null) {
          sandPoint += Point(1, 1);
        } else {
          if (map[sandPoint.y] == null) {
            map[sandPoint.y] = <int, Element>{};
          }

          map[sandPoint.y]![sandPoint.x] = Element.sand;
          break;
        }
      }

      if (!fallingIntoAbyss) {
        sandCount++;
      }
    }

    return sandCount;
  }
}

enum Element {
  rock,
  sand,
}
