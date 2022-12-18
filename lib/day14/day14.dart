import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day14 extends Day<Map<int, Map<int, Element>>, int> {
  const Day14() : super(14);

  static const start = Point(500, 0);

  @override
  Map<int, Map<int, Element>> preprocess(List<String> input) {
    final grid = <int, Map<int, Element>>{};

    for (final line in input) {
      final rockLines = line
          .split(' -> ')
          .map((point) => point.split(',').map(int.parse))
          .map((coordinates) => Point(coordinates.first, coordinates.last))
          .toList(growable: false);

      for (int i = 0; i < rockLines.length - 1; i++) {
        final from = rockLines[i];
        final to = rockLines[i + 1];

        if (from.x == to.x) {
          for (int j = min(from.y, to.y); j <= max(from.y, to.y); j++) {
            grid.putIfAbsent(j, () => <int, Element>{})[from.x] = Element.rock;
          }
        } else {
          for (int j = min(from.x, to.x); j <= max(from.x, to.x); j++) {
            grid.putIfAbsent(from.y, () => <int, Element>{})[j] = Element.rock;
          }
        }
      }
    }

    return grid;
  }

  @override
  int processPart1(Map<int, Map<int, Element>> input) {
    final maxY = input.keys.max;
    var sandCount = 0;
    var fallingIntoAbyss = false;

    while (true) {
      var sand = start;

      while (true) {
        if (sand.y >= maxY) {
          fallingIntoAbyss = true;
          break;
        } else if (input[sand.y + 1]?[sand.x] == null) {
          sand += Point(0, 1);
        } else if (input[sand.y + 1]?[sand.x - 1] == null) {
          sand += Point(-1, 1);
        } else if (input[sand.y + 1]?[sand.x + 1] == null) {
          sand += Point(1, 1);
        } else {
          input.putIfAbsent(sand.y, () => <int, Element>{})[sand.x] =
              Element.sand;
          break;
        }
      }

      if (fallingIntoAbyss) {
        return sandCount;
      }

      sandCount++;
    }
  }

  @override
  int processPart2(Map<int, Map<int, Element>> input) {
    final maxY = input.keys.max + 1;
    var sandCount = 0;

    while (true) {
      var sand = start;

      while (true) {
        if (sand.y >= maxY) {
          input.putIfAbsent(sand.y, () => <int, Element>{})[sand.x] =
              Element.sand;
          break;
        } else if (input[sand.y + 1]?[sand.x] == null) {
          sand += Point(0, 1);
        } else if (input[sand.y + 1]?[sand.x - 1] == null) {
          sand += Point(-1, 1);
        } else if (input[sand.y + 1]?[sand.x + 1] == null) {
          sand += Point(1, 1);
        } else {
          input.putIfAbsent(sand.y, () => <int, Element>{})[sand.x] =
              Element.sand;
          break;
        }
      }

      sandCount++;

      if (sand == start) {
        return sandCount;
      }
    }
  }
}

enum Element {
  rock,
  sand,
}
