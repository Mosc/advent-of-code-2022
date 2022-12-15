import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

class Day12 extends Day<List<String>, int> {
  const Day12() : super(12);

  @override
  int processPart1(List<String> input) {
    final grid = <List<int>>[];
    late Point<int> start;
    late Point<int> goal;

    for (final line in input) {
      grid.add(
        line.codeUnits.mapIndexed((index, codeUnit) {
          final point = Point(index, grid.length);

          if (codeUnit == 'S'.codeUnits.single) {
            start = point;
            return 'a'.codeUnits.single;
          } else if (codeUnit == 'E'.codeUnits.single) {
            goal = point;
            return 'z'.codeUnits.single;
          } else {
            return codeUnit;
          }
        }).toList(),
      );
    }

    return _dijkstraLowestCost(
      start: start,
      goal: goal,
      costTo: (a, b) => 1,
      neighborsOf: (current) => [
        Point(current.x, current.y - 1),
        Point(current.x, current.y + 1),
        Point(current.x - 1, current.y),
        Point(current.x + 1, current.y),
      ].where(
        (point) =>
            point.y >= 0 &&
            point.y < grid.length &&
            point.x >= 0 &&
            point.x < grid[point.y].length &&
            grid[point.y][point.x] - grid[current.y][current.x] <= 1,
      ),
    )!
        .toInt();
  }

  // Based on https://github.com/darrenaustin/advent-of-code-dart/blob/main/lib/src/util/pathfinding.dart.
  double? _dijkstraLowestCost<L>({
    required L start,
    required L goal,
    required double Function(L, L) costTo,
    required Iterable<L> Function(L) neighborsOf,
  }) {
    final dist = <L, double>{start: 0};
    final prev = <L, L>{};
    final queue = PriorityQueue<L>(
      (L a, L b) =>
          (dist[a] ?? double.infinity).compareTo(dist[b] ?? double.infinity),
    )..add(start);

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();

      if (current == goal) {
        return dist[goal];
      }

      for (final neighbor in neighborsOf(current)) {
        final score = dist[current]! + costTo(current, neighbor);

        if (score < (dist[neighbor] ?? double.infinity)) {
          dist[neighbor] = score;
          prev[neighbor] = current;
          queue.add(neighbor);
        }
      }
    }

    return null;
  }
}
