import 'dart:math';

import 'package:advent_of_code_2022/day.dart';

class Day9 extends Day<List<String>, Set<Point<int>>> {
  const Day9() : super(9);

  @override
  Set<Point<int>> processPart1(List<String> input) =>
      _getVisited(input, length: 2);

  @override
  Set<Point<int>> processPart2(List<String> input) =>
      _getVisited(input, length: 10);

  @override
  int postprocess(Set<Point<int>> input) => input.length;

  Set<Point<int>> _getVisited(List<String> value, {required int length}) {
    final knots = List<Point<int>>.generate(length, (_) => const Point(0, 0));
    final visitedTailPos = <Point<int>>{knots.last};

    for (final line in value) {
      final tokens = line.split(' ');
      final offset = _getOffset(tokens[0]);
      final times = int.parse(tokens[1]);

      for (int i = 0; i < times; i++) {
        knots.first += offset;

        for (int j = 1; j < knots.length; j++) {
          final distance = knots[j - 1] - knots[j];

          if (distance.x.abs() > 1 || distance.y.abs() > 1) {
            knots[j] += Point(distance.x.clamp(-1, 1), distance.y.clamp(-1, 1));
          }
        }

        visitedTailPos.add(knots.last);
      }
    }

    return visitedTailPos;
  }

  Point<int> _getOffset(String direction) {
    switch (direction) {
      case 'L':
        return const Point(-1, 0);
      case 'R':
        return const Point(1, 0);
      case 'U':
        return const Point(0, -1);
      case 'D':
        return const Point(0, 1);
    }

    throw Exception();
  }
}
