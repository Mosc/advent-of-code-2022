import 'dart:math';

import 'package:advent_of_code_2022/day.dart';

class Day9 extends Day<List<String>, int> {
  const Day9() : super(9);

  @override
  int processPart1(List<String> value) {
    Point<int> getOffset(String direction) {
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

    var headPos = const Point(0, 0);
    var tailPos = const Point(0, 0);
    final visitedTailPos = <Point<int>>{tailPos};

    for (final line in value) {
      final tokens = line.split(' ');

      final offset = getOffset(tokens[0]);
      final times = int.parse(tokens[1]);

      for (int i = 0; i < times; i++) {
        headPos += offset;
        final distance = headPos - tailPos;

        if (distance.x.abs() > 1) {
          tailPos += Point(distance.x.isNegative ? -1 : 1, distance.y);
        } else if (distance.y.abs() > 1) {
          tailPos += Point(distance.x, distance.y.isNegative ? -1 : 1);
        }

        visitedTailPos.add(tailPos);
      }
    }

    return visitedTailPos.length;
  }
}
