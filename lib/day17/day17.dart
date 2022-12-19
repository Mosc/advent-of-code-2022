import 'dart:math';

import 'package:advent_of_code_2022/day.dart';
import 'package:collection/collection.dart';

const shapes = [
  [Point(0, 0), Point(1, 0), Point(2, 0), Point(3, 0)],
  [Point(1, 0), Point(0, 1), Point(1, 1), Point(1, 2), Point(2, 1)],
  [Point(0, 0), Point(1, 0), Point(2, 0), Point(2, 1), Point(2, 2)],
  [Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3)],
  [Point(0, 0), Point(1, 0), Point(0, 1), Point(1, 1)],
];

class Day17 extends Day<List<Direction>, int> {
  const Day17() : super(17);

  @override
  List<Direction> preprocess(List<String> input) => input.single
      .split('')
      .map((character) => Direction.parse(character))
      .toList(growable: false);

  @override
  int processPart1(List<Direction> input) => dropRocks(input, 2022);

  @override
  int processPart2(List<Direction> input) => dropRocks(input, 1000000000000);

  int dropRocks(List<Direction> input, int totalRocks) {
    const chamberWidth = 7;
    final cache = <String, List<int>>{};
    final grid = <List<bool>>[];
    var jetIndex = 0;
    int? skippedHeight;

    for (var rockIndex = 0; rockIndex < totalRocks; rockIndex++) {
      final rock = Rock.create(number: rockIndex, gridHeight: grid.length);
      var stopped = false;

      if (grid.isNotEmpty && skippedHeight == null) {
        final cacheKey = '${rock.shapeIndex}-$jetIndex-${grid.last.render()}';
        final cacheValue = cache[cacheKey];

        if (cacheValue != null) {
          int rockPeriod = rockIndex - cacheValue.first;
          int height = grid.length - cacheValue.last;
          final skippedCycles = (totalRocks - rockIndex) ~/ rockPeriod;
          rockIndex += skippedCycles * rockPeriod;
          skippedHeight = skippedCycles * height;
        } else {
          cache[cacheKey] = [rockIndex, grid.length];
        }
      }

      while (!stopped) {
        final jet = input[jetIndex];

        for (final direction in [jet, Direction.down]) {
          final tentativePosition = rock.position + direction.offset;
          final partPositions =
              rock.shape.map((part) => tentativePosition + part);
          final partsX = partPositions.map((partPosition) => partPosition.x);
          final isWithinBoundsX = direction == Direction.down ||
              partsX.min >= 0 && partsX.max < chamberWidth;
          final canMove = isWithinBoundsX &&
              partPositions.every(
                (partPosition) =>
                    partPosition.y >= grid.length ||
                    partPosition.y >= 0 &&
                        !grid[partPosition.y][partPosition.x],
              );

          if (canMove) {
            rock.position = tentativePosition;
          } else if (direction == Direction.down) {
            stopped = true;
          }
        }

        jetIndex = ++jetIndex % input.length;
      }

      final partPositions = rock.shape.map((part) => rock.position + part);

      for (final partPosition in partPositions) {
        while (partPosition.y >= grid.length) {
          grid.add(List.generate(chamberWidth, (_) => false, growable: false));
        }

        grid[partPosition.y][partPosition.x] = true;
      }
    }

    return grid.length + (skippedHeight ?? 0);
  }
}

extension GridRowExtension on List<bool> {
  String render() => map((filled) => filled ? '#' : '.').join();
}

class Rock {
  Rock.create({required int number, int gridHeight = 0})
      : shapeIndex = number % shapes.length,
        position = Point(2, gridHeight + 3);

  final int shapeIndex;
  Point<int> position;

  late List<Point<int>> shape = shapes[shapeIndex];
}

enum Direction {
  left,
  right,
  down;

  static Direction parse(String character) {
    switch (character) {
      case '<':
        return Direction.left;
      case '>':
        return Direction.right;
    }

    throw Exception();
  }

  Point<int> get offset {
    switch (this) {
      case left:
        return Point(-1, 0);
      case right:
        return Point(1, 0);
      case down:
        return Point(0, -1);
    }
  }
}
