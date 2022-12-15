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

    return _fewestSteps(start, goal, grid)!;
  }

  @override
  int processPart2(List<String> input) {
    final grid = <List<int>>[];
    final possibleStarts = <Point<int>>[];
    late Point<int> goal;

    for (final line in input) {
      grid.add(
        line.codeUnits.mapIndexed((index, codeUnit) {
          final point = Point(index, grid.length);

          if (codeUnit == 'S'.codeUnits.single) {
            possibleStarts.add(point);
            return 'a'.codeUnits.single;
          } else if (codeUnit == 'E'.codeUnits.single) {
            goal = point;
            return 'z'.codeUnits.single;
          } else {
            if (codeUnit == 'a'.codeUnits.single) {
              possibleStarts.add(point);
            }

            return codeUnit;
          }
        }).toList(),
      );
    }

    return possibleStarts
        .map((start) => _fewestSteps(start, goal, grid))
        .whereType<int>()
        .min;
  }

  int? _fewestSteps(Point<int> start, Point<int> goal, List<List<int>> grid) =>
      _dijkstraLowestCost(
        start: start,
        goal: goal,
        costTo: (a, b) => 1,
        neighborsOf: (current) => [
          if (current.y > 0) Point(current.x, current.y - 1),
          if (current.y < grid.length - 1) Point(current.x, current.y + 1),
          if (current.x > 0) Point(current.x - 1, current.y),
          if (current.x < grid[current.y].length - 1)
            Point(current.x + 1, current.y),
        ].where(
          (point) => grid[point.y][point.x] - grid[current.y][current.x] <= 1,
        ),
      )?.toInt();

  // Based on https://github.com/darrenaustin/advent-of-code-dart/blob/main/lib/src/util/pathfinding.dart.
  double? _dijkstraLowestCost<L>({
    required L start,
    required L goal,
    required double Function(L, L) costTo,
    required Iterable<L> Function(L) neighborsOf,
  }) {
    final dist = <L, double>{start: 0};
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
          queue.add(neighbor);
        }
      }
    }

    return null;
  }
}
