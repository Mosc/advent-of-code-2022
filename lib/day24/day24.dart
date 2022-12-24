import 'dart:math';

import 'package:advent_of_code_2022/day.dart';

class Day24 extends Day<List<String>, int> {
  const Day24() : super(24);

  @override
  int processPart1(List<String> input) {
    final blizzards = <Blizzard>{};
    final walls = <Point<int>>{};
    final start = Point(input.first.indexOf('.'), 0);
    final goal = Point(input.last.indexOf('.'), input.length);

    for (var y = 0; y < input.length; y++) {
      for (var x = 0; x < input[y].length; x++) {
        final character = input[y][x];

        if (Direction.values.map((e) => e.character).contains(character)) {
          var direction = Direction.parse(character);
          blizzards.add(
            Blizzard(
              Point(x, y),
              direction,
              width: input[y].length,
              height: input.length,
            ),
          );
        } else if (character == '#') {
          walls.add(Point(x, y));
        }
      }
    }

    var current = <Point<int>>{start};
    var minutes = 0;

    while (true) {
      for (final blizzard in blizzards) {
        blizzard.move();
      }

      final blizzardPositions =
          blizzards.map((blizzard) => blizzard.position).toSet();
      final next = <Point<int>>{};

      for (final position in current) {
        next.addAll(
          {
            position,
            ...Direction.values.map((direction) => position + direction.offset),
          }.where(
            (position) =>
                position.y >= 0 &&
                !walls.contains(position) &&
                !blizzardPositions.contains(position),
          ),
        );
      }

      if (next.contains(goal)) break;

      current = next;
      minutes++;
    }

    return minutes;
  }
}

class Blizzard {
  Blizzard(
    this.position,
    this.direction, {
    required this.width,
    required this.height,
  });

  Point<int> position;
  final Direction direction;
  final int width;
  final int height;

  void move() {
    position += direction.offset;

    switch (direction) {
      case Direction.right:
        if (position.x == width - 1) position = Point(1, position.y);
        break;
      case Direction.down:
        if (position.y == height - 1) position = Point(position.x, 1);
        break;
      case Direction.left:
        if (position.x == 0) position = Point(width - 2, position.y);
        break;
      case Direction.up:
        if (position.y == 0) position = Point(position.x, height - 2);
        break;
    }
  }
}

enum Direction {
  right('>', Point(1, 0)),
  down('v', Point(0, 1)),
  left('<', Point(-1, 0)),
  up('^', Point(0, -1));

  const Direction(this.character, this.offset);

  final String character;
  final Point<int> offset;

  static Direction parse(String character) => Direction.values
      .singleWhere((direction) => direction.character == character);
}
